#!/bin/bash
# Script de décompression avec filtres utilisant un for loop
# Usage: ./decompress_filtered.sh [OPTIONS] <archive_prefix> [output_dir]

# Affichage de l'aide
show_help() {
    cat << EOF
Usage: $0 [OPTIONS] <archive_prefix> [output_dir]

OPTIONS:
  --type TYPE          Extraire uniquement les fichiers de ce type
                       (mêmes types que compress_filtered.sh)
  --ext EXT            Extraire uniquement les fichiers avec cette extension
  --exclude-type TYPE  Exclure un type de fichier
  --exclude-ext EXT    Exclure une extension
  --list               Lister le contenu de l'archive sans extraire
  --dry-run            Afficher ce qui serait extrait sans le faire
  -h, --help           Afficher cette aide

EXEMPLES:
  # Décompresser tout
  $0 archive /path/to/extract

  # Lister le contenu
  $0 --list archive

  # Extraire uniquement les scripts bash
  $0 --type bash archive /path/to/extract

  # Extraire tout sauf les binaires
  $0 --exclude-type binary archive /path/to/extract

  # Extraire uniquement .sh et .md
  $0 --ext sh --ext md archive /path/to/extract
EOF
    exit 0
}

# Variables par défaut
INCLUDE_TYPES=()
INCLUDE_EXTS=()
EXCLUDE_TYPES=()
EXCLUDE_EXTS=()
LIST_ONLY=0
DRY_RUN=0

# Définition des types de fichiers (même que compress_filtered.sh)
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
        --list)
            LIST_ONLY=1
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

# Vérification des arguments
if [ "$#" -lt 1 ]; then
    echo "Erreur: Arguments manquants"
    echo ""
    show_help
fi

ARCHIVE_PREFIX="$1"
OUTPUT_DIR="${2:-.}"

echo "==================================================="
echo "Décompression avec filtres - FOR LOOP"
echo "==================================================="
echo "Préfixe d'archive: $ARCHIVE_PREFIX"

if [ $LIST_ONLY -eq 0 ]; then
    echo "Répertoire de sortie: $OUTPUT_DIR"
fi

# Vérification que les fichiers existent
PART_FILES=("${ARCHIVE_PREFIX}_part_"*)
if [ ! -e "${PART_FILES[0]}" ]; then
    echo "Erreur: Aucun fichier trouvé avec le préfixe '${ARCHIVE_PREFIX}_part_'"
    exit 1
fi

# Lecture des métadonnées si disponibles
METADATA_FILE="${ARCHIVE_PREFIX}_metadata.txt"
if [ -f "$METADATA_FILE" ]; then
    echo ""
    echo "Métadonnées de l'archive:"
    echo "-------------------------"
    cat "$METADATA_FILE"
    echo "-------------------------"
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

if [ ${#ALL_INCLUDE_EXTS[@]} -gt 0 ]; then
    echo "Extensions à extraire: ${ALL_INCLUDE_EXTS[*]}"
fi

if [ ${#ALL_EXCLUDE_EXTS[@]} -gt 0 ]; then
    echo "Extensions à exclure: ${ALL_EXCLUDE_EXTS[*]}"
fi

echo "==================================================="

# Nom du fichier temporaire assemblé
TEMP_ARCHIVE="${ARCHIVE_PREFIX}_assembled.tar.gz"

echo ""
echo "Étape 1: Assemblage des parties avec FOR LOOP..."

# Suppression de l'archive assemblée si elle existe déjà
if [ -f "$TEMP_ARCHIVE" ]; then
    rm -f "$TEMP_ARCHIVE"
fi

# FOR LOOP pour assembler toutes les parties numérotées
PART_COUNT=0
for PART_FILE in "${ARCHIVE_PREFIX}_part_"*; do
    if [ -f "$PART_FILE" ]; then
        PART_COUNT=$((PART_COUNT + 1))
        echo "  Partie $PART_COUNT: $PART_FILE ($(du -h "$PART_FILE" | cut -f1))"
        cat "$PART_FILE" >> "$TEMP_ARCHIVE"
    fi
done

echo ""
echo "Total de parties assemblées: $PART_COUNT"
echo "Taille de l'archive: $(du -h "$TEMP_ARCHIVE" | cut -f1)"

# Vérification que l'assemblage a fonctionné
if [ ! -f "$TEMP_ARCHIVE" ] || [ ! -s "$TEMP_ARCHIVE" ]; then
    echo "Erreur: L'assemblage a échoué"
    exit 1
fi

# Mode liste seulement
if [ $LIST_ONLY -eq 1 ]; then
    echo ""
    echo "Contenu de l'archive:"
    echo "---------------------"
    tar -tzf "$TEMP_ARCHIVE" 2>/dev/null
    rm -f "$TEMP_ARCHIVE"
    exit 0
fi

# Fonction pour vérifier si un fichier doit être extrait
should_extract_file() {
    local file="$1"
    local basename=$(basename "$file")
    local ext="${basename##*.}"

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

    # Si pas de filtres d'inclusion, extraire tout (sauf exclusions)
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

echo ""
echo "Étape 2: Extraction avec filtres..."

# Création du répertoire de sortie
mkdir -p "$OUTPUT_DIR"

# Si pas de filtres, extraction simple
if [ ${#ALL_INCLUDE_EXTS[@]} -eq 0 ] && [ ${#ALL_EXCLUDE_EXTS[@]} -eq 0 ]; then
    cd "$OUTPUT_DIR"
    tar -xzf "../$TEMP_ARCHIVE" 2>/dev/null
    EXTRACT_STATUS=$?
    cd - > /dev/null
else
    # Extraction avec filtres
    TEMP_FILE_LIST=$(mktemp)
    EXTRACTED_COUNT=0

    # Liste tous les fichiers de l'archive et filtre
    while IFS= read -r file; do
        # Ignorer les répertoires
        if [[ "$file" =~ /$ ]]; then
            continue
        fi

        if should_extract_file "$file"; then
            echo "$file" >> "$TEMP_FILE_LIST"
            EXTRACTED_COUNT=$((EXTRACTED_COUNT + 1))
        fi
    done < <(tar -tzf "$TEMP_ARCHIVE" 2>/dev/null)

    # Vérifier si des fichiers correspondent
    if [ ! -f "$TEMP_FILE_LIST" ] || [ ! -s "$TEMP_FILE_LIST" ]; then
        echo "Attention: Aucun fichier ne correspond aux filtres"
        rm -f "$TEMP_FILE_LIST" "$TEMP_ARCHIVE"
        exit 0
    fi

    EXTRACTED_COUNT=$(wc -l < "$TEMP_FILE_LIST")
    echo "Fichiers à extraire: $EXTRACTED_COUNT"

    # Mode dry-run
    if [ $DRY_RUN -eq 1 ]; then
        echo ""
        echo "Fichiers qui seraient extraits:"
        cat "$TEMP_FILE_LIST" | head -20
        if [ $EXTRACTED_COUNT -gt 20 ]; then
            echo "... et $((EXTRACTED_COUNT - 20)) autres fichiers"
        fi
        rm -f "$TEMP_FILE_LIST" "$TEMP_ARCHIVE"
        exit 0
    fi

    # Extraction des fichiers filtrés
    # Utiliser un chemin absolu pour la liste de fichiers
    ABS_FILE_LIST="$(cd "$(dirname "$TEMP_FILE_LIST")" && pwd)/$(basename "$TEMP_FILE_LIST")"
    ABS_ARCHIVE="$(cd "$(dirname "$TEMP_ARCHIVE")" && pwd)/$(basename "$TEMP_ARCHIVE")"

    cd "$OUTPUT_DIR"
    tar -xzf "$ABS_ARCHIVE" -T "$ABS_FILE_LIST" 2>/dev/null
    EXTRACT_STATUS=$?
    cd - > /dev/null

    rm -f "$TEMP_FILE_LIST"
fi

# Vérification du succès
if [ $EXTRACT_STATUS -eq 0 ]; then
    echo ""
    echo "==================================================="
    echo "Décompression réussie!"
    echo "==================================================="
    echo "Contenu extrait dans: $OUTPUT_DIR"
    echo ""

    # Nettoyage du fichier temporaire
    rm -f "$TEMP_ARCHIVE"
    echo "Fichier temporaire nettoyé"

    echo ""
    echo "Fichiers extraits:"
    ls -lh "$OUTPUT_DIR" | head -20
else
    echo ""
    echo "Erreur lors de l'extraction de l'archive"
    rm -f "$TEMP_ARCHIVE"
    exit 1
fi
