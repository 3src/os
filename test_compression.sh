#!/bin/bash
# Script de test pour démontrer le proof of concept

echo "=========================================="
echo "TEST DE COMPRESSION/DÉCOMPRESSION"
echo "Proof of Concept - FOR LOOP"
echo "=========================================="
echo ""

# Création d'un répertoire de test avec des fichiers
echo "Création des données de test..."
TEST_DIR="test_data"
mkdir -p "$TEST_DIR"

# Création de plusieurs fichiers de test
for i in {1..5}; do
    echo "Contenu du fichier de test numéro $i" > "$TEST_DIR/file_$i.txt"
    echo "Ligne 2 avec des données supplémentaires" >> "$TEST_DIR/file_$i.txt"
    echo "Ligne 3 - timestamp: $(date)" >> "$TEST_DIR/file_$i.txt"
done

echo "Fichiers de test créés dans $TEST_DIR:"
ls -lh "$TEST_DIR"
echo ""

# Test de compression avec taille de 1 MB par fichier
echo "=========================================="
echo "ÉTAPE 1: COMPRESSION"
echo "=========================================="
./compress_fixed_size.sh "$TEST_DIR" "test_archive" 1

echo ""
echo "=========================================="
echo "ÉTAPE 2: VÉRIFICATION DES ARCHIVES"
echo "=========================================="
echo "Fichiers d'archive créés:"
ls -lh test_archive_part_* 2>/dev/null

echo ""
echo "=========================================="
echo "ÉTAPE 3: DÉCOMPRESSION AVEC FOR LOOP"
echo "=========================================="
EXTRACT_DIR="extracted_data"
rm -rf "$EXTRACT_DIR"
./decompress_archives.sh "test_archive" "$EXTRACT_DIR"

echo ""
echo "=========================================="
echo "ÉTAPE 4: COMPARAISON DES DONNÉES"
echo "=========================================="
echo "Données originales:"
ls -lhR "$TEST_DIR"
echo ""
echo "Données extraites:"
ls -lhR "$EXTRACT_DIR"

echo ""
echo "=========================================="
echo "VÉRIFICATION DE L'INTÉGRITÉ"
echo "=========================================="
if diff -r "$TEST_DIR" "$EXTRACT_DIR/$TEST_DIR" > /dev/null 2>&1; then
    echo "✓ SUCCESS: Les données sont identiques!"
    echo "Le proof of concept fonctionne correctement."
else
    echo "✗ ERREUR: Les données diffèrent"
    exit 1
fi

echo ""
echo "=========================================="
echo "TEST TERMINÉ AVEC SUCCÈS"
echo "=========================================="
echo ""
echo "Pour nettoyer les fichiers de test:"
echo "  rm -rf test_data extracted_data test_archive_*"
