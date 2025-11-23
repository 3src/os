#!/bin/bash
# smcompress.sh - Smart Compression with Context System
# Usage: ./smcompress.sh [OPTIONS] <source> <output_prefix> <size_in_MB>

# Affichage de l'aide
show_help() {
    cat << EOF
Usage: $0 [OPTIONS] <source> <output_prefix> <size_in_MB>

SMART COMPRESSION avec système de CONTEXTES (.3src)

OPTIONS DE CONTEXTE:
  --context NAME       Charger un contexte depuis NAME.3src
                       Contextes disponibles:
                         highlander  : Uniquement code + config (essentiel)
                         full        : Tout inclure
                         docs        : Documentation seulement
                         clean       : Backup propre sans binaires/cache

  --list-contexts      Lister tous les contextes disponibles

OPTIONS MANUELLES (overrides le contexte):
  --type TYPE          Filtrer par type
  --ext EXT            Filtrer par extension
  --exclude-type TYPE  Exclure un type
  --exclude-ext EXT    Exclure une extension
  --include-hidden     Inclure fichiers cachés
  --dry-run            Simuler sans compresser

  -h, --help           Afficher cette aide

EXEMPLES:
  # Utiliser le contexte highlander
  $0 --context highlander system/ backup 50

  # Utiliser le contexte docs
  $0 --context docs project/ docs_backup 10

  # Lister les contextes disponibles
  $0 --list-contexts

  # Contexte + override manuel
  $0 --context clean --ext xml system/ backup 25

SYSTÈME DE CONTEXTES:
  Les fichiers .3src définissent des profils de filtrage réutilisables.
  Créez vos propres contextes en créant un fichier .3src avec:
    - INCLUDE_TYPES
    - INCLUDE_EXTS
    - EXCLUDE_TYPES
    - EXCLUDE_EXTS
    - INCLUDE_HIDDEN
    - MAX_FILE_SIZE_MB
EOF
    exit 0
}

# Liste les contextes disponibles
list_contexts() {
    echo "=========================================="
    echo "CONTEXTES DISPONIBLES (.3src)"
    echo "=========================================="
    echo ""

    CONTEXT_FILES=(*.3src)
    if [ ! -e "${CONTEXT_FILES[0]}" ]; then
        echo "Aucun contexte trouvé"
        exit 0
    fi

    for context_file in *.3src; do
        if [ -f "$context_file" ]; then
            CONTEXT_NAME=""
            CONTEXT_DESC=""

            # Charger le contexte
            source "$context_file" 2>/dev/null

            echo "📦 $(basename "$context_file" .3src)"
            if [ -n "$CONTEXT_DESC" ]; then
                echo "   Description: $CONTEXT_DESC"
            fi
            if [ -n "$INCLUDE_TYPES" ]; then
                echo "   Inclus: types=$INCLUDE_TYPES"
            fi
            if [ -n "$EXCLUDE_TYPES" ]; then
                echo "   Exclus: types=$EXCLUDE_TYPES"
            fi
            echo ""
        fi
    done

    exit 0
}

# Chargement d'un contexte
load_context() {
    local context_name="$1"
    local context_file="${context_name}.3src"

    if [ ! -f "$context_file" ]; then
        echo "Erreur: Contexte '$context_name' non trouvé ($context_file)"
        echo "Utilisez --list-contexts pour voir les contextes disponibles"
        exit 1
    fi

    echo "Chargement du contexte: $context_name"

    # Reset des variables
    CONTEXT_NAME=""
    CONTEXT_DESC=""
    INCLUDE_TYPES=""
    INCLUDE_EXTS=""
    EXCLUDE_TYPES=""
    EXCLUDE_EXTS=""
    INCLUDE_HIDDEN=0
    MAX_FILE_SIZE_MB=0

    # Charger le fichier contexte
    source "$context_file"

    echo "  Description: $CONTEXT_DESC"
    echo ""
}

# Variables par défaut
CONTEXT=""
INCLUDE_TYPES_MANUAL=()
INCLUDE_EXTS_MANUAL=()
EXCLUDE_TYPES_MANUAL=()
EXCLUDE_EXTS_MANUAL=()
INCLUDE_HIDDEN_MANUAL=""
DRY_RUN=0

# Définition des types de fichiers
declare -A FILE_TYPES
FILE_TYPES[bash]=".sh .bash"
FILE_TYPES[sh]=".sh .bash"
FILE_TYPES[markdown]=".md .markdown"
FILE_TYPES[md]=".md .markdown"
FILE_TYPES[text]=".txt .text .log"
FILE_TYPES[txt]=".txt .text .log"
FILE_TYPES[code]=".php .js .py .c .cpp .h .hpp .java .go .rb .pl .cs .swift .kt .rs .ts .jsx .tsx .vue"
FILE_TYPES[config]=".conf .cfg .ini .json .xml .yaml .yml .toml .env"
FILE_TYPES[bin]=".exe .bin .so .dll .a .o .pyc .class"
FILE_TYPES[binary]=".exe .bin .so .dll .a .o .pyc .class"
FILE_TYPES[image]=".jpg .jpeg .png .gif .bmp .svg .ico .webp .tiff"
FILE_TYPES[archive]=".zip .tar .gz .bz2 .xz .7z .rar .tgz .tbz2"
FILE_TYPES[doc]=".pdf .doc .docx .odt .ods .odp .xls .xlsx .ppt .pptx"
FILE_TYPES[all]="*"

# Parsing des arguments
POSITIONAL_ARGS=()
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            ;;
        --list-contexts)
            list_contexts
            ;;
        --context)
            CONTEXT="$2"
            shift 2
            ;;
        --type)
            INCLUDE_TYPES_MANUAL+=("$2")
            shift 2
            ;;
        --ext)
            INCLUDE_EXTS_MANUAL+=("$2")
            shift 2
            ;;
        --exclude-type)
            EXCLUDE_TYPES_MANUAL+=("$2")
            shift 2
            ;;
        --exclude-ext)
            EXCLUDE_EXTS_MANUAL+=("$2")
            shift 2
            ;;
        --include-hidden)
            INCLUDE_HIDDEN_MANUAL=1
            shift
            ;;
        --dry-run)
            DRY_RUN=1
            shift
            ;;
        -*)
            echo "Option inconnue: $1"
            echo "Utilisez -h pour l'aide"
            exit 1
            ;;
        *)
            POSITIONAL_ARGS+=("$1")
            shift
            ;;
    esac
done

# Restauration des arguments positionnels
set -- "${POSITIONAL_ARGS[@]}"

# Vérification des arguments requis
if [ "$#" -ne 3 ]; then
    echo "Erreur: Arguments manquants"
    echo ""
    show_help
fi

SOURCE="$1"
OUTPUT_PREFIX="$2"
SIZE_MB="$3"

# Vérification que la source existe
if [ ! -e "$SOURCE" ]; then
    echo "Erreur: La source '$SOURCE' n'existe pas"
    exit 1
fi

# Vérification que la taille est un nombre valide
if ! [[ "$SIZE_MB" =~ ^[0-9]+$ ]]; then
    echo "Erreur: La taille doit être un nombre entier (en MB)"
    exit 1
fi

# Charger le contexte si spécifié
if [ -n "$CONTEXT" ]; then
    load_context "$CONTEXT"
fi

# Merge du contexte avec les options manuelles
# Les options manuelles ont priorité sur le contexte

FINAL_INCLUDE_TYPES=()
FINAL_INCLUDE_EXTS=()
FINAL_EXCLUDE_TYPES=()
FINAL_EXCLUDE_EXTS=()
FINAL_INCLUDE_HIDDEN=0

# Si contexte chargé, utiliser ses valeurs
if [ -n "$CONTEXT" ]; then
    # Parser INCLUDE_TYPES du contexte
    for type in $INCLUDE_TYPES; do
        FINAL_INCLUDE_TYPES+=("$type")
    done

    # Parser INCLUDE_EXTS du contexte
    for ext in $INCLUDE_EXTS; do
        FINAL_INCLUDE_EXTS+=("$ext")
    done

    # Parser EXCLUDE_TYPES du contexte
    for type in $EXCLUDE_TYPES; do
        FINAL_EXCLUDE_TYPES+=("$type")
    done

    # Parser EXCLUDE_EXTS du contexte
    for ext in $EXCLUDE_EXTS; do
        FINAL_EXCLUDE_EXTS+=("$ext")
    done

    FINAL_INCLUDE_HIDDEN=$INCLUDE_HIDDEN
fi

# Override avec les options manuelles
if [ ${#INCLUDE_TYPES_MANUAL[@]} -gt 0 ]; then
    FINAL_INCLUDE_TYPES=("${INCLUDE_TYPES_MANUAL[@]}")
fi

if [ ${#INCLUDE_EXTS_MANUAL[@]} -gt 0 ]; then
    FINAL_INCLUDE_EXTS=("${FINAL_INCLUDE_EXTS[@]}" "${INCLUDE_EXTS_MANUAL[@]}")
fi

if [ ${#EXCLUDE_TYPES_MANUAL[@]} -gt 0 ]; then
    FINAL_EXCLUDE_TYPES=("${FINAL_EXCLUDE_TYPES[@]}" "${EXCLUDE_TYPES_MANUAL[@]}")
fi

if [ ${#EXCLUDE_EXTS_MANUAL[@]} -gt 0 ]; then
    FINAL_EXCLUDE_EXTS=("${FINAL_EXCLUDE_EXTS[@]}" "${EXCLUDE_EXTS_MANUAL[@]}")
fi

if [ -n "$INCLUDE_HIDDEN_MANUAL" ]; then
    FINAL_INCLUDE_HIDDEN=$INCLUDE_HIDDEN_MANUAL
fi

# Construction de la liste des extensions à inclure
ALL_INCLUDE_EXTS=()
for type in "${FINAL_INCLUDE_TYPES[@]}"; do
    if [ -n "${FILE_TYPES[$type]}" ]; then
        for ext in ${FILE_TYPES[$type]}; do
            ALL_INCLUDE_EXTS+=("$ext")
        done
    fi
done

for ext in "${FINAL_INCLUDE_EXTS[@]}"; do
    if [[ ! "$ext" =~ ^\. ]]; then
        ext=".$ext"
    fi
    ALL_INCLUDE_EXTS+=("$ext")
done

# Construction de la liste des extensions à exclure
ALL_EXCLUDE_EXTS=()
for type in "${FINAL_EXCLUDE_TYPES[@]}"; do
    if [ -n "${FILE_TYPES[$type]}" ]; then
        for ext in ${FILE_TYPES[$type]}; do
            ALL_EXCLUDE_EXTS+=("$ext")
        done
    fi
done

for ext in "${FINAL_EXCLUDE_EXTS[@]}"; do
    if [[ ! "$ext" =~ ^\. ]]; then
        ext=".$ext"
    fi
    ALL_EXCLUDE_EXTS+=("$ext")
done

# Affichage des informations
echo "==================================================="
echo "SMART COMPRESSION - Système de Contextes"
echo "==================================================="
echo "Source: $SOURCE"
echo "Préfixe de sortie: $OUTPUT_PREFIX"
echo "Taille par fichier: $SIZE_MB MB"

if [ -n "$CONTEXT" ]; then
    echo "Contexte: $CONTEXT ($CONTEXT_DESC)"
fi

if [ ${#ALL_INCLUDE_EXTS[@]} -gt 0 ]; then
    echo "Extensions incluses: ${ALL_INCLUDE_EXTS[*]}"
fi

if [ ${#ALL_EXCLUDE_EXTS[@]} -gt 0 ]; then
    echo "Extensions exclues: ${ALL_EXCLUDE_EXTS[*]}"
fi

echo "Fichiers cachés: $([ $FINAL_INCLUDE_HIDDEN -eq 1 ] && echo "Oui" || echo "Non")"
echo "Mode dry-run: $([ $DRY_RUN -eq 1 ] && echo "Oui" || echo "Non")"
echo "==================================================="

# Création de la liste des fichiers à compresser
TEMP_FILE_LIST=$(mktemp)

# Fonction pour vérifier si un fichier doit être inclus
should_include_file() {
    local file="$1"
    local basename=$(basename "$file")
    local ext="${basename##*.}"

    # Si commence par . et pas de flag include-hidden
    if [[ "$basename" =~ ^\. ]] && [ $FINAL_INCLUDE_HIDDEN -eq 0 ]; then
        return 1
    fi

    # Ajouter le point à l'extension
    if [ "$ext" != "$basename" ]; then
        ext=".$ext"
    else
        ext=""
    fi

    # Vérifier les exclusions en premier
    for excl in "${ALL_EXCLUDE_EXTS[@]}"; do
        if [ "$ext" = "$excl" ]; then
            return 1
        fi
    done

    # Si pas de filtres d'inclusion, inclure tout (sauf exclusions)
    if [ ${#ALL_INCLUDE_EXTS[@]} -eq 0 ]; then
        return 0
    fi

    # Vérifier les inclusions
    for incl in "${ALL_INCLUDE_EXTS[@]}"; do
        if [ "$incl" = "*" ] || [ "$ext" = "$incl" ]; then
            return 0
        fi
    done

    return 1
}

# Collecte des fichiers
echo ""
echo "Analyse des fichiers..."
FILE_COUNT=0

if [ -f "$SOURCE" ]; then
    # Source est un fichier unique
    if should_include_file "$SOURCE"; then
        echo "$SOURCE" >> "$TEMP_FILE_LIST"
        FILE_COUNT=1
    fi
else
    # Source est un répertoire
    while IFS= read -r -d '' file; do
        if should_include_file "$file"; then
            echo "$file" >> "$TEMP_FILE_LIST"
            FILE_COUNT=$((FILE_COUNT + 1))
        fi
    done < <(find "$SOURCE" -type f -print0)
fi

echo "Fichiers trouvés: $FILE_COUNT"

if [ $FILE_COUNT -eq 0 ]; then
    echo "Erreur: Aucun fichier ne correspond aux critères"
    rm -f "$TEMP_FILE_LIST"
    exit 1
fi

# Mode dry-run
if [ $DRY_RUN -eq 1 ]; then
    echo ""
    echo "Fichiers qui seraient compressés:"
    cat "$TEMP_FILE_LIST" | head -20
    if [ $FILE_COUNT -gt 20 ]; then
        echo "... et $((FILE_COUNT - 20)) autres fichiers"
    fi
    rm -f "$TEMP_FILE_LIST"
    exit 0
fi

# Conversion de la taille en bytes pour split
SIZE_BYTES="${SIZE_MB}M"

# Création du répertoire de sortie si nécessaire
OUTPUT_DIR="$(dirname "$OUTPUT_PREFIX")"
if [ ! -z "$OUTPUT_DIR" ] && [ "$OUTPUT_DIR" != "." ]; then
    mkdir -p "$OUTPUT_DIR"
fi

# Compression et découpage
echo ""
echo "Compression en cours..."
tar -czf - -T "$TEMP_FILE_LIST" 2>/dev/null | split -b "$SIZE_BYTES" -d -a 4 - "${OUTPUT_PREFIX}_part_"

# Nettoyage
rm -f "$TEMP_FILE_LIST"

# Vérification du succès
if [ $? -eq 0 ]; then
    echo ""
    echo "Archives créées:"
    ls -lh "${OUTPUT_PREFIX}_part_"* 2>/dev/null

    PART_COUNT=$(ls -1 "${OUTPUT_PREFIX}_part_"* 2>/dev/null | wc -l)
    echo ""
    echo "==================================================="
    echo "Compression réussie!"
    echo "Fichiers compressés: $FILE_COUNT"
    echo "Nombre de parties créées: $PART_COUNT"
    echo "==================================================="

    # Création d'un fichier de métadonnées
    METADATA_FILE="${OUTPUT_PREFIX}_metadata.txt"
    echo "SOURCE=$SOURCE" > "$METADATA_FILE"
    echo "PREFIX=$OUTPUT_PREFIX" >> "$METADATA_FILE"
    echo "SIZE_MB=$SIZE_MB" >> "$METADATA_FILE"
    echo "PARTS=$PART_COUNT" >> "$METADATA_FILE"
    echo "FILES=$FILE_COUNT" >> "$METADATA_FILE"
    echo "CONTEXT=$CONTEXT" >> "$METADATA_FILE"
    echo "CONTEXT_DESC=$CONTEXT_DESC" >> "$METADATA_FILE"
    echo "INCLUDE_TYPES=${FINAL_INCLUDE_TYPES[*]}" >> "$METADATA_FILE"
    echo "INCLUDE_EXTS=${FINAL_INCLUDE_EXTS[*]}" >> "$METADATA_FILE"
    echo "EXCLUDE_TYPES=${FINAL_EXCLUDE_TYPES[*]}" >> "$METADATA_FILE"
    echo "EXCLUDE_EXTS=${FINAL_EXCLUDE_EXTS[*]}" >> "$METADATA_FILE"
    echo "DATE=$(date)" >> "$METADATA_FILE"

    echo "Métadonnées: $METADATA_FILE"
else
    echo "Erreur lors de la compression"
    exit 1
fi
