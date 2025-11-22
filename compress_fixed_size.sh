#!/bin/bash
# Script de compression avec taille de fichier fixe
# Usage: ./compress_fixed_size.sh <source> <output_prefix> <size_in_MB>

# Vérification des arguments
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <source> <output_prefix> <size_in_MB>"
    echo "Exemple: $0 /path/to/dir myarchive 10"
    exit 1
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

# Conversion de la taille en bytes pour split
SIZE_BYTES="${SIZE_MB}M"

echo "==================================================="
echo "Compression avec taille fixe - Proof of Concept"
echo "==================================================="
echo "Source: $SOURCE"
echo "Préfixe de sortie: $OUTPUT_PREFIX"
echo "Taille par fichier: $SIZE_MB MB"
echo "==================================================="

# Création du répertoire de sortie si nécessaire
OUTPUT_DIR="$(dirname "$OUTPUT_PREFIX")"
if [ ! -z "$OUTPUT_DIR" ] && [ "$OUTPUT_DIR" != "." ]; then
    mkdir -p "$OUTPUT_DIR"
fi

# Compression et découpage en fichiers de taille fixe
echo "Étape 1: Création de l'archive tar..."
tar -czf - "$SOURCE" 2>/dev/null | split -b "$SIZE_BYTES" -d -a 4 - "${OUTPUT_PREFIX}_part_"

# Vérification du succès
if [ $? -eq 0 ]; then
    echo "Étape 2: Découpage terminé avec succès"
    echo ""
    echo "Archives créées:"
    ls -lh "${OUTPUT_PREFIX}_part_"* 2>/dev/null

    # Comptage du nombre de parties
    PART_COUNT=$(ls -1 "${OUTPUT_PREFIX}_part_"* 2>/dev/null | wc -l)
    echo ""
    echo "==================================================="
    echo "Compression réussie!"
    echo "Nombre de parties créées: $PART_COUNT"
    echo "==================================================="

    # Création d'un fichier de métadonnées
    METADATA_FILE="${OUTPUT_PREFIX}_metadata.txt"
    echo "SOURCE=$SOURCE" > "$METADATA_FILE"
    echo "PREFIX=$OUTPUT_PREFIX" >> "$METADATA_FILE"
    echo "SIZE_MB=$SIZE_MB" >> "$METADATA_FILE"
    echo "PARTS=$PART_COUNT" >> "$METADATA_FILE"
    echo "DATE=$(date)" >> "$METADATA_FILE"

    echo "Métadonnées sauvegardées dans: $METADATA_FILE"
    echo ""
    echo "Pour décompresser, utilisez:"
    echo "./decompress_archives.sh ${OUTPUT_PREFIX}"
else
    echo "Erreur lors de la compression"
    exit 1
fi
