#!/bin/bash
# Script de test pour la compression/décompression avec filtres

echo "=========================================================="
echo "TEST DE COMPRESSION/DÉCOMPRESSION AVEC FILTRES"
echo "Proof of Concept - FOR LOOP avec filtres avancés"
echo "=========================================================="
echo ""

# Nettoyage des anciennes données de test
rm -rf test_mixed_data filtered_* 2>/dev/null

# Création d'un répertoire de test avec différents types de fichiers
echo "=== Création des données de test variées ==="
TEST_DIR="test_mixed_data"
mkdir -p "$TEST_DIR"

# Scripts bash
echo '#!/bin/bash' > "$TEST_DIR/script1.sh"
echo 'echo "Hello World"' >> "$TEST_DIR/script1.sh"
echo '#!/bin/bash' > "$TEST_DIR/backup.bash"
echo 'tar -czf backup.tar.gz *' >> "$TEST_DIR/backup.bash"

# Fichiers markdown
echo '# Documentation' > "$TEST_DIR/README.md"
echo 'Ceci est un fichier markdown' >> "$TEST_DIR/README.md"
echo '# Guide' > "$TEST_DIR/guide.markdown"

# Fichiers texte
echo 'Fichier texte simple' > "$TEST_DIR/notes.txt"
echo 'Données textuelles' > "$TEST_DIR/data.text"
echo 'Log entry 1' > "$TEST_DIR/app.log"

# Code source
echo '<?php echo "Hello"; ?>' > "$TEST_DIR/index.php"
echo 'console.log("test");' > "$TEST_DIR/app.js"
echo 'print("Python")' > "$TEST_DIR/script.py"

# Fichiers de config
echo '[config]' > "$TEST_DIR/config.ini"
echo '{"key": "value"}' > "$TEST_DIR/settings.json"
echo 'debug: true' > "$TEST_DIR/app.yaml"

# Fichiers binaires simulés (petits fichiers)
echo 'BINARY_DATA' > "$TEST_DIR/app.bin"
echo 'EXECUTABLE' > "$TEST_DIR/program.exe"

# Archives
echo 'ARCHIVE_CONTENT' > "$TEST_DIR/backup.tar.gz"
echo 'ZIP_DATA' > "$TEST_DIR/files.zip"

# Images (fichiers texte nommés comme images pour le test)
echo 'IMAGE_DATA' > "$TEST_DIR/photo.jpg"
echo 'PNG_DATA' > "$TEST_DIR/icon.png"

# Documents
echo 'PDF_CONTENT' > "$TEST_DIR/document.pdf"

echo ""
echo "Fichiers créés dans $TEST_DIR:"
ls -lh "$TEST_DIR"
echo ""
echo "Total: $(ls -1 "$TEST_DIR" | wc -l) fichiers"
echo ""

# Test 1: Compression de tous les fichiers
echo "=========================================================="
echo "TEST 1: Compression de TOUS les fichiers"
echo "=========================================================="
./compress_filtered.sh "$TEST_DIR" "filtered_all" 1

echo ""
echo "=========================================================="
echo "TEST 2: Compression UNIQUEMENT des scripts bash"
echo "=========================================================="
./compress_filtered.sh --type bash "$TEST_DIR" "filtered_bash" 1

echo ""
echo "=========================================================="
echo "TEST 3: Compression du code source (PHP, JS, Python)"
echo "=========================================================="
./compress_filtered.sh --type code "$TEST_DIR" "filtered_code" 1

echo ""
echo "=========================================================="
echo "TEST 4: Compression markdown + texte"
echo "=========================================================="
./compress_filtered.sh --type markdown --type text "$TEST_DIR" "filtered_docs" 1

echo ""
echo "=========================================================="
echo "TEST 5: Tout SAUF les binaires et archives"
echo "=========================================================="
./compress_filtered.sh --exclude-type binary --exclude-type archive "$TEST_DIR" "filtered_no_bin" 1

echo ""
echo "=========================================================="
echo "TEST 6: Uniquement extensions .sh et .md"
echo "=========================================================="
./compress_filtered.sh --ext sh --ext md "$TEST_DIR" "filtered_sh_md" 1

echo ""
echo "=========================================================="
echo "TEST 7: Mode dry-run - config files"
echo "=========================================================="
./compress_filtered.sh --dry-run --type config "$TEST_DIR" "filtered_config" 1

echo ""
echo "=========================================================="
echo "TESTS DE DÉCOMPRESSION"
echo "=========================================================="

echo ""
echo "--- Liste du contenu de filtered_bash ---"
./decompress_filtered.sh --list filtered_bash

echo ""
echo "--- Extraction des scripts bash ---"
./decompress_filtered.sh filtered_bash extracted_bash

echo ""
echo "--- Extraction du code source uniquement depuis l'archive complète ---"
./decompress_filtered.sh --type code filtered_all extracted_code_only

echo ""
echo "--- Extraction de tout sauf binaires depuis l'archive complète ---"
./decompress_filtered.sh --exclude-type binary --exclude-type archive filtered_all extracted_no_bin

echo ""
echo "=========================================================="
echo "VÉRIFICATION DES RÉSULTATS"
echo "=========================================================="

echo ""
echo "Fichiers bash extraits:"
find extracted_bash -type f 2>/dev/null

echo ""
echo "Code source extrait:"
find extracted_code_only -type f 2>/dev/null

echo ""
echo "Fichiers extraits sans binaires:"
find extracted_no_bin -type f 2>/dev/null | head -10

echo ""
echo "=========================================================="
echo "RÉSUMÉ DES ARCHIVES CRÉÉES"
echo "=========================================================="
ls -lh filtered_*.tar.gz 2>/dev/null || ls -lh filtered_*_part_* 2>/dev/null

echo ""
echo "=========================================================="
echo "TESTS TERMINÉS AVEC SUCCÈS"
echo "=========================================================="
echo ""
echo "Pour nettoyer:"
echo "  rm -rf test_mixed_data filtered_* extracted_*"
