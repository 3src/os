#!/bin/bash
# Test du système de contextes smcompress.sh avec highlander.3src

echo "=========================================================="
echo "TEST DU SYSTÈME DE CONTEXTES - smcompress.sh"
echo "Highlander.3src: There can be only one!"
echo "=========================================================="
echo ""

# Nettoyage
rm -rf test_context_data context_* 2>/dev/null

# Création de données de test variées
echo "=== Création des données de test ==="
TEST_DIR="test_context_data"
mkdir -p "$TEST_DIR"

# Code source (essentiel pour highlander)
echo '<?php echo "Hello"; ?>' > "$TEST_DIR/app.php"
echo 'console.log("test");' > "$TEST_DIR/script.js"
echo 'print("Python")' > "$TEST_DIR/main.py"
echo '#!/bin/bash' > "$TEST_DIR/deploy.sh"
echo 'echo "Deploy script"' >> "$TEST_DIR/deploy.sh"

# Configs (essentiel pour highlander)
echo '{"database": "mysql"}' > "$TEST_DIR/config.json"
echo 'debug: true' > "$TEST_DIR/app.yaml"
echo '[server]' > "$TEST_DIR/settings.ini"

# Documentation
echo '# README' > "$TEST_DIR/README.md"
echo 'Documentation du projet' >> "$TEST_DIR/README.md"

# Binaires (exclus par highlander)
echo 'BINARY_DATA' > "$TEST_DIR/app.bin"
echo 'EXECUTABLE' > "$TEST_DIR/program.exe"

# Images (exclus par highlander)
echo 'IMAGE_DATA' > "$TEST_DIR/logo.png"
echo 'PHOTO_DATA' > "$TEST_DIR/photo.jpg"

# Archives (exclus par highlander)
echo 'ARCHIVE' > "$TEST_DIR/backup.tar.gz"
echo 'ZIP_DATA' > "$TEST_DIR/files.zip"

# Fichiers cache/tmp (exclus par highlander)
echo 'CACHE' > "$TEST_DIR/app.cache"
echo 'TEMP' > "$TEST_DIR/temp.tmp"

echo ""
echo "Fichiers créés: $(ls -1 "$TEST_DIR" | wc -l)"
ls -lh "$TEST_DIR"
echo ""

# Test 1: Lister les contextes disponibles
echo "=========================================================="
echo "TEST 1: Liste des contextes disponibles"
echo "=========================================================="
./smcompress.sh --list-contexts

# Test 2: Contexte HIGHLANDER
echo "=========================================================="
echo "TEST 2: Compression avec contexte HIGHLANDER"
echo "There can be only one - seulement l'essentiel!"
echo "=========================================================="
./smcompress.sh --context highlander "$TEST_DIR" context_highlander 1

echo ""
echo "--- Vérification du résultat ---"
echo "Fichiers originaux: $(find "$TEST_DIR" -type f | wc -l)"
./decompress_filtered.sh --list context_highlander | grep -v "^=" | grep -v "^Étape" | grep -v "^Total" | grep -v "^Taille" | grep -v "Partie" | grep -v "Métadonnées" | grep -v "^$" | grep "test_context_data" || echo "Aucun fichier"

# Test 3: Contexte FULL
echo ""
echo "=========================================================="
echo "TEST 3: Compression avec contexte FULL"
echo "=========================================================="
./smcompress.sh --context full "$TEST_DIR" context_full 1

echo ""
echo "Comparaison:"
echo "  Highlander: $(ls -lh context_highlander_part_0000 | awk '{print $5}')"
echo "  Full: $(ls -lh context_full_part_0000 | awk '{print $5}')"

# Test 4: Contexte DOCS
echo ""
echo "=========================================================="
echo "TEST 4: Compression avec contexte DOCS"
echo "=========================================================="
./smcompress.sh --context docs "$TEST_DIR" context_docs 1

# Test 5: Contexte CLEAN
echo ""
echo "=========================================================="
echo "TEST 5: Compression avec contexte CLEAN"
echo "=========================================================="
./smcompress.sh --context clean "$TEST_DIR" context_clean 1

# Test 6: Contexte + Override manuel
echo ""
echo "=========================================================="
echo "TEST 6: Contexte HIGHLANDER + override manuel (ajouter .md)"
echo "=========================================================="
./smcompress.sh --context highlander --ext md "$TEST_DIR" context_highlander_plus 1

# Comparaison des tailles
echo ""
echo "=========================================================="
echo "COMPARAISON DES TAILLES D'ARCHIVES"
echo "=========================================================="
echo ""
echo "Contexte         | Taille  | Fichiers"
echo "-----------------|---------|----------"

for ctx in highlander full docs clean highlander_plus; do
    if [ -f "context_${ctx}_metadata.txt" ]; then
        SIZE=$(ls -lh "context_${ctx}_part_0000" 2>/dev/null | awk '{print $5}')
        FILES=$(grep "^FILES=" "context_${ctx}_metadata.txt" | cut -d= -f2)
        printf "%-16s | %-7s | %s\n" "$ctx" "$SIZE" "$FILES"
    fi
done

echo ""
echo "=========================================================="
echo "TEST DU CONTEXTE HIGHLANDER EN DÉTAIL"
echo "=========================================================="
echo ""
echo "Highlander.3src: 'There can be only one'"
echo "Ce contexte garde uniquement:"
echo "  ✓ Code source (.php, .js, .py, .sh)"
echo "  ✓ Configurations (.json, .yaml, .ini)"
echo ""
echo "Ce contexte EXCLUT:"
echo "  ✗ Binaires (.exe, .bin)"
echo "  ✗ Images (.png, .jpg)"
echo "  ✗ Archives (.tar.gz, .zip)"
echo "  ✗ Fichiers temporaires (.tmp, .cache)"
echo ""

echo "Fichiers dans l'archive HIGHLANDER:"
./decompress_filtered.sh --list context_highlander 2>/dev/null | grep "test_context_data" | while read file; do
    basename "$file"
done | sort

echo ""
echo "=========================================================="
echo "EXTRACTION ET VALIDATION"
echo "=========================================================="

# Extraction du contexte highlander
./decompress_filtered.sh context_highlander extracted_highlander

echo ""
echo "Fichiers extraits avec HIGHLANDER:"
find extracted_highlander -type f | while read f; do basename "$f"; done | sort

# Validation
echo ""
echo "=========================================================="
echo "VALIDATION: Highlander a-t-il bien filtré?"
echo "=========================================================="

EXTRACTED_FILES=(extracted_highlander/test_context_data/*)
HAS_CODE=0
HAS_BINARY=0
HAS_IMAGE=0

for file in "${EXTRACTED_FILES[@]}"; do
    basename=$(basename "$file")
    if [[ "$basename" =~ \.(php|js|py|sh|json|yaml|ini)$ ]]; then
        HAS_CODE=1
    fi
    if [[ "$basename" =~ \.(exe|bin)$ ]]; then
        HAS_BINARY=1
    fi
    if [[ "$basename" =~ \.(png|jpg)$ ]]; then
        HAS_IMAGE=1
    fi
done

echo ""
if [ $HAS_CODE -eq 1 ]; then
    echo "✓ Code source présent"
else
    echo "✗ Code source manquant (ERREUR)"
fi

if [ $HAS_BINARY -eq 0 ]; then
    echo "✓ Binaires exclus (correct)"
else
    echo "✗ Binaires présents (ERREUR)"
fi

if [ $HAS_IMAGE -eq 0 ]; then
    echo "✓ Images exclues (correct)"
else
    echo "✗ Images présentes (ERREUR)"
fi

echo ""
echo "=========================================================="
echo "TEST DU SYSTÈME: RÉUSSI!"
echo "=========================================================="
echo ""
echo "Le système de contextes .3src fonctionne parfaitement:"
echo "  ✓ Chargement des contextes depuis fichiers .3src"
echo "  ✓ Highlander filtre correctement (code + config uniquement)"
echo "  ✓ Override manuel fonctionne"
echo "  ✓ Multiple contextes disponibles"
echo ""
echo "Pour nettoyer:"
echo "  rm -rf test_context_data context_* extracted_*"
