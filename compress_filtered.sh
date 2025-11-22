#!/bin/bash
# Script de compression avec filtres de fichiers et taille fixe
# Usage: ./compress_filtered.sh [OPTIONS] <source> <output_prefix> <size_in_MB>

# Affichage de l'aide
show_help() {
    cat << EOF
Usage: $0 [OPTIONS] <source> <output_prefix> <size_in_MB>

OPTIONS:
  --type TYPE          Filtrer par type de fichier (peut être utilisé plusieurs fois)
                       Types disponibles:
                         bash, sh       : Scripts bash (.sh, .bash)
                         markdown, md   : Fichiers markdown (.md, .markdown)
                         text, txt      : Fichiers texte (.txt, .text)
                         code           : Code source (.php, .js, .py, .c, .cpp, .java, .go)
                         config         : Fichiers de config (.conf, .cfg, .ini, .json, .xml, .yaml, .yml)
                         bin, binary    : Fichiers binaires (.exe, .bin, .so, .dll, .a, .o)
                         image          : Images (.jpg, .jpeg, .png, .gif, .bmp, .svg, .ico)
                         archive        : Archives (.zip, .tar, .gz, .bz2, .xz, .7z, .rar)
                         doc            : Documents (.pdf, .doc, .docx, .odt)
                         all            : Tous les fichiers (par défaut)

  --ext EXT            Filtrer par extension spécifique (peut être utilisé plusieurs fois)
                       Exemples: --ext sh --ext bash --ext md

  --exclude-type TYPE  Exclure un type de fichier
  --exclude-ext EXT    Exclure une extension

  --include-hidden     Inclure les fichiers cachés (commençant par .)
  --dry-run            Afficher ce qui serait compressé sans le faire

  -h, --help           Afficher cette aide

EXEMPLES:
  # Compresser uniquement les scripts bash
  $0 --type bash /path/to/dir archive 10

  # Compresser markdown et texte
  $0 --type markdown --type text /path/to/dir archive 5

  # Compresser tout sauf les binaires et archives
  $0 --exclude-type binary --exclude-type archive /path/to/dir archive 10

  # Compresser uniquement .sh et .php
  $0 --ext sh --ext php /path/to/dir archive 10

  # Compresser le code source seulement
  $0 --type code system/ code_backup 50
EOF
    exit 0
}

# Variables par défaut
INCLUDE_TYPES=()
INCLUDE_EXTS=()
EXCLUDE_TYPES=()
EXCLUDE_EXTS=()
INCLUDE_HIDDEN=0
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
        --type)
            INCLUDE_TYPES+=("$2")
            shift 2
            ;;
        --ext)
            INCLUDE_EXTS+=("$2")
            shift 2
            ;;
        --exclude-type)
            EXCLUDE_TYPES+=("$2")
            shift 2
            ;;
        --exclude-ext)
            EXCLUDE_EXTS+=("$2")
            shift 2
            ;;
        --include-hidden)
            INCLUDE_HIDDEN=1
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

# Construction de la liste des extensions à inclure
ALL_INCLUDE_EXTS=()
for type in "${INCLUDE_TYPES[@]}"; do
    if [ -n "${FILE_TYPES[$type]}" ]; then
        for ext in ${FILE_TYPES[$type]}; do
            ALL_INCLUDE_EXTS+=("$ext")
        done
    else
        echo "Attention: Type '$type' non reconnu, ignoré"
    fi
done

# Ajout des extensions directes
for ext in "${INCLUDE_EXTS[@]}"; do
    if [[ ! "$ext" =~ ^\. ]]; then
        ext=".$ext"
    fi
    ALL_INCLUDE_EXTS+=("$ext")
done

# Construction de la liste des extensions à exclure
ALL_EXCLUDE_EXTS=()
for type in "${EXCLUDE_TYPES[@]}"; do
    if [ -n "${FILE_TYPES[$type]}" ]; then
        for ext in ${FILE_TYPES[$type]}; do
            ALL_EXCLUDE_EXTS+=("$ext")
        done
    fi
done

for ext in "${EXCLUDE_EXTS[@]}"; do
    if [[ ! "$ext" =~ ^\. ]]; then
        ext=".$ext"
    fi
    ALL_EXCLUDE_EXTS+=("$ext")
done

# Affichage des informations
echo "==================================================="
echo "Compression avec filtres - Proof of Concept"
echo "==================================================="
echo "Source: $SOURCE"
echo "Préfixe de sortie: $OUTPUT_PREFIX"
echo "Taille par fichier: $SIZE_MB MB"

if [ ${#ALL_INCLUDE_EXTS[@]} -gt 0 ]; then
    echo "Extensions incluses: ${ALL_INCLUDE_EXTS[*]}"
fi

if [ ${#ALL_EXCLUDE_EXTS[@]} -gt 0 ]; then
    echo "Extensions exclues: ${ALL_EXCLUDE_EXTS[*]}"
fi

echo "Fichiers cachés: $([ $INCLUDE_HIDDEN -eq 1 ] && echo "Oui" || echo "Non")"
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
    if [[ "$basename" =~ ^\. ]] && [ $INCLUDE_HIDDEN -eq 0 ]; then
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
    echo "INCLUDE_TYPES=${INCLUDE_TYPES[*]}" >> "$METADATA_FILE"
    echo "INCLUDE_EXTS=${INCLUDE_EXTS[*]}" >> "$METADATA_FILE"
    echo "EXCLUDE_TYPES=${EXCLUDE_TYPES[*]}" >> "$METADATA_FILE"
    echo "EXCLUDE_EXTS=${EXCLUDE_EXTS[*]}" >> "$METADATA_FILE"
    echo "DATE=$(date)" >> "$METADATA_FILE"

    echo "Métadonnées: $METADATA_FILE"
else
    echo "Erreur lors de la compression"
    exit 1
fi
