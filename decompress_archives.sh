#!/bin/bash
# Script de décompression utilisant un for loop
# Usage: ./decompress_archives.sh <archive_prefix> [output_dir]

# Vérification des arguments
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <archive_prefix> [output_dir]"
    echo "Exemple: $0 myarchive"
    echo "Exemple: $0 myarchive /path/to/extract"
    exit 1
fi

ARCHIVE_PREFIX="$1"
OUTPUT_DIR="${2:-.}"

echo "==================================================="
echo "Décompression avec FOR LOOP - Proof of Concept"
echo "==================================================="
echo "Préfixe d'archive: $ARCHIVE_PREFIX"
echo "Répertoire de sortie: $OUTPUT_DIR"
echo "==================================================="

# Vérification que les fichiers existent
PART_FILES=("${ARCHIVE_PREFIX}_part_"*)
if [ ! -e "${PART_FILES[0]}" ]; then
    echo "Erreur: Aucun fichier trouvé avec le préfixe '${ARCHIVE_PREFIX}_part_'"
    exit 1
fi

# Lecture des métadonnées si disponibles
METADATA_FILE="${ARCHIVE_PREFIX}_metadata.txt"
if [ -f "$METADATA_FILE" ]; then
    echo "Lecture des métadonnées..."
    cat "$METADATA_FILE"
    echo "==================================================="
fi

# Création du répertoire de sortie
mkdir -p "$OUTPUT_DIR"

# Nom du fichier temporaire assemblé
TEMP_ARCHIVE="${ARCHIVE_PREFIX}_assembled.tar.gz"

echo "Étape 1: Assemblage des parties avec FOR LOOP..."
echo ""

# Suppression de l'archive assemblée si elle existe déjà
if [ -f "$TEMP_ARCHIVE" ]; then
    rm -f "$TEMP_ARCHIVE"
fi

# FOR LOOP pour assembler toutes les parties numérotées
PART_COUNT=0
for PART_FILE in "${ARCHIVE_PREFIX}_part_"*; do
    if [ -f "$PART_FILE" ]; then
        PART_COUNT=$((PART_COUNT + 1))
        echo "  Ajout de la partie $PART_COUNT: $PART_FILE ($(du -h "$PART_FILE" | cut -f1))"
        cat "$PART_FILE" >> "$TEMP_ARCHIVE"
    fi
done

echo ""
echo "Total de parties assemblées: $PART_COUNT"
echo "Taille de l'archive assemblée: $(du -h "$TEMP_ARCHIVE" | cut -f1)"
echo ""

# Vérification que l'assemblage a fonctionné
if [ ! -f "$TEMP_ARCHIVE" ] || [ ! -s "$TEMP_ARCHIVE" ]; then
    echo "Erreur: L'assemblage a échoué"
    exit 1
fi

echo "Étape 2: Extraction de l'archive..."
cd "$OUTPUT_DIR"
tar -xzf "../$TEMP_ARCHIVE" 2>/dev/null

# Vérification du succès
if [ $? -eq 0 ]; then
    echo ""
    echo "==================================================="
    echo "Décompression réussie!"
    echo "==================================================="
    echo "Contenu extrait dans: $OUTPUT_DIR"
    echo ""

    # Nettoyage du fichier temporaire
    cd - > /dev/null
    rm -f "$TEMP_ARCHIVE"
    echo "Fichier temporaire nettoyé: $TEMP_ARCHIVE"

    echo ""
    echo "Fichiers extraits:"
    ls -lh "$OUTPUT_DIR"
else
    echo ""
    echo "Erreur lors de l'extraction de l'archive"
    cd - > /dev/null
    exit 1
fi
