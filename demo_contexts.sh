#!/bin/bash
# Démonstration complète de tous les contextes .3src

echo "=========================================================="
echo "DÉMONSTRATION COMPLÈTE DES CONTEXTES .3src"
echo "Smart Compression System - Context Gallery"
echo "=========================================================="
echo ""

# Création de données de test complètes
echo "=== Création d'un projet complet de test ==="
TEST_DIR="demo_project"
rm -rf "$TEST_DIR" 2>/dev/null
mkdir -p "$TEST_DIR"/{src,config,docs,public,database,security}

# Backend code
echo '<?php echo "API endpoint"; ?>' > "$TEST_DIR/src/api.php"
echo 'print("Backend service")' > "$TEST_DIR/src/service.py"
echo 'package main; func main() {}' > "$TEST_DIR/src/server.go"
echo 'class Server { }' > "$TEST_DIR/src/Server.java"

# Frontend code
echo '<!DOCTYPE html><html></html>' > "$TEST_DIR/public/index.html"
echo 'body { color: blue; }' > "$TEST_DIR/public/style.css"
echo 'console.log("app");' > "$TEST_DIR/public/app.js"
echo 'import React from "react";' > "$TEST_DIR/public/App.jsx"

# Configuration files
echo '{"database": "mysql"}' > "$TEST_DIR/config/database.json"
echo 'server: production' > "$TEST_DIR/config/app.yaml"
echo '[server]' > "$TEST_DIR/config/settings.ini"

# Documentation
echo '# Project README' > "$TEST_DIR/docs/README.md"
echo 'User guide content' > "$TEST_DIR/docs/guide.txt"
echo 'API documentation' > "$TEST_DIR/docs/api.md"

# Database
echo 'CREATE TABLE users (id INT);' > "$TEST_DIR/database/schema.sql"
echo 'ALTER TABLE users ADD email;' > "$TEST_DIR/database/migration_001.sql"

# Security files
echo 'DB_PASSWORD=secret123' > "$TEST_DIR/security/.env"
echo '-----BEGIN CERTIFICATE-----' > "$TEST_DIR/security/cert.pem"

# Scripts
echo '#!/bin/bash' > "$TEST_DIR/deploy.sh"
echo 'echo "Deploying..."' >> "$TEST_DIR/deploy.sh"

# Media files
echo 'LOGO_DATA' > "$TEST_DIR/public/logo.png"
echo 'ICON_DATA' > "$TEST_DIR/public/favicon.ico"
echo 'IMAGE_DATA' > "$TEST_DIR/public/banner.jpg"

# Binaries
echo 'BINARY' > "$TEST_DIR/app.exe"
echo 'BINARY' > "$TEST_DIR/server.bin"

# Archives
echo 'ARCHIVE' > "$TEST_DIR/backup.tar.gz"
echo 'ZIP' > "$TEST_DIR/assets.zip"

# Temp files
echo 'CACHE' > "$TEST_DIR/.cache"
echo 'TMP' > "$TEST_DIR/temp.tmp"

echo ""
echo "Projet de test créé:"
echo "  Total des fichiers: $(find "$TEST_DIR" -type f | wc -l)"
tree "$TEST_DIR" 2>/dev/null || find "$TEST_DIR" -type f | head -20
echo ""

# Liste tous les contextes disponibles
echo "=========================================================="
echo "CONTEXTES DISPONIBLES"
echo "=========================================================="
./smcompress.sh --list-contexts
echo ""

# Fonction pour tester un contexte
test_context() {
    local context_name="$1"
    local description="$2"

    echo "=========================================================="
    echo "TEST: $context_name"
    echo "$description"
    echo "=========================================================="

    # Dry-run pour voir ce qui serait compressé
    echo ""
    echo "Fichiers qui seraient inclus avec --context $context_name:"
    ./smcompress.sh --dry-run --context "$context_name" "$TEST_DIR" "test_$context_name" 1 2>&1 | \
        grep -A 100 "Fichiers qui seraient compressés:" | \
        grep "$TEST_DIR" | \
        sed 's|^.*/demo_project/||' | \
        sort

    echo ""
    echo "---"
    echo ""
}

# Tests de tous les contextes
test_context "highlander" "🗡️  HIGHLANDER - There can be only one (code + config)"

test_context "full" "📦 FULL - Backup complet"

test_context "clean" "🧹 CLEAN - Sans binaires ni cache"

test_context "docs" "📚 DOCS - Documentation uniquement"

test_context "web" "🌐 WEB - Fichiers web (HTML, CSS, JS, PHP)"

test_context "backend" "⚙️  BACKEND - Code serveur uniquement"

test_context "frontend" "🎨 FRONTEND - Code client + assets"

test_context "source" "💻 SOURCE - Code pur sans configs"

test_context "minimal" "⚡ MINIMAL - Ultra minimal (configs critiques)"

test_context "database" "🗄️  DATABASE - Schémas et migrations"

test_context "security" "🔒 SECURITY - Fichiers sensibles"

test_context "media" "🎬 MEDIA - Images, vidéos, audio"

# Compression réelle avec quelques contextes pour comparaison
echo "=========================================================="
echo "COMPARAISON DES TAILLES D'ARCHIVES"
echo "=========================================================="
echo ""

declare -A CONTEXTS
CONTEXTS[highlander]="Code + Config essentiel"
CONTEXTS[full]="Backup complet"
CONTEXTS[web]="Fichiers web"
CONTEXTS[minimal]="Ultra minimal"
CONTEXTS[docs]="Documentation"

for ctx in "${!CONTEXTS[@]}"; do
    echo "Compression avec contexte: $ctx"
    ./smcompress.sh --context "$ctx" "$TEST_DIR" "demo_$ctx" 1 > /dev/null 2>&1
done

echo ""
echo "Résultats:"
echo ""
printf "%-15s | %-8s | %-5s | %s\n" "Contexte" "Taille" "Files" "Description"
echo "----------------|----------|-------|----------------------------------"

for ctx in highlander full web minimal docs; do
    if [ -f "demo_${ctx}_part_0000" ]; then
        SIZE=$(ls -lh "demo_${ctx}_part_0000" 2>/dev/null | awk '{print $5}')
        FILES=$(grep "^FILES=" "demo_${ctx}_metadata.txt" 2>/dev/null | cut -d= -f2)
        DESC="${CONTEXTS[$ctx]}"
        printf "%-15s | %-8s | %-5s | %s\n" "$ctx" "$SIZE" "$FILES" "$DESC"
    fi
done

echo ""
echo "=========================================================="
echo "CAS D'USAGE PRATIQUES"
echo "=========================================================="
echo ""

echo "1. Backup quotidien de développement:"
echo "   ./smcompress.sh --context highlander ~/project backup_\$(date +%Y%m%d) 50"
echo ""

echo "2. Déploiement (web seulement):"
echo "   ./smcompress.sh --context web ~/project deploy_package 25"
echo ""

echo "3. Migration configs uniquement:"
echo "   ./smcompress.sh --context minimal ~/project configs_migrate 5"
echo ""

echo "4. Backup frontend pour CDN:"
echo "   ./smcompress.sh --context frontend ~/project cdn_assets 100"
echo ""

echo "5. Audit de sécurité:"
echo "   ./smcompress.sh --context security ~/project security_audit 1"
echo ""

echo "6. Archive documentation:"
echo "   ./smcompress.sh --context docs ~/project docs_archive 10"
echo ""

echo "=========================================================="
echo "WORKFLOWS AVANCÉS"
echo "=========================================================="
echo ""

echo "Scenario 1: Backup incrémental par type"
echo "  # Jour 1: Code"
echo "  ./smcompress.sh --context highlander project/ backup_code_day1 50"
echo "  # Jour 2: Media"
echo "  ./smcompress.sh --context media project/ backup_media_day2 100"
echo "  # Jour 3: Docs"
echo "  ./smcompress.sh --context docs project/ backup_docs_day3 10"
echo ""

echo "Scenario 2: Migration sélective"
echo "  # Extraire juste le backend depuis un backup complet"
echo "  ./decompress_filtered.sh --context backend full_backup backend_only/"
echo ""

echo "Scenario 3: Partage d'équipe"
echo "  # Devs: code uniquement"
echo "  ./smcompress.sh --context source project/ for_devs 25"
echo "  # Designers: frontend + media"
echo "  ./smcompress.sh --context frontend project/ for_designers 50"
echo "  # DevOps: configs + security"
echo "  ./smcompress.sh --context minimal project/ for_devops 5"
echo ""

echo "=========================================================="
echo "CRÉATION DE CONTEXTES PERSONNALISÉS"
echo "=========================================================="
echo ""

cat > "example_custom.3src" << 'EOF'
# Custom Context Example - Votre contexte personnalisé
CONTEXT_NAME="mycontext"
CONTEXT_DESC="Mon contexte personnalisé"

# Définir ce que vous voulez inclure
INCLUDE_TYPES="code config"
INCLUDE_EXTS=".myext .custom"

# Définir ce que vous voulez exclure
EXCLUDE_TYPES="binary archive"
EXCLUDE_EXTS=".tmp .cache"

# Options
INCLUDE_HIDDEN=0
MAX_FILE_SIZE_MB=50
EOF

echo "Exemple de contexte personnalisé créé: example_custom.3src"
echo ""
echo "Pour l'utiliser:"
echo "  ./smcompress.sh --context example_custom source/ output 25"
echo ""

echo "=========================================================="
echo "DÉMONSTRATION TERMINÉE!"
echo "=========================================================="
echo ""
echo "📁 Fichiers créés pour la démo:"
ls -lh demo_* 2>/dev/null | grep -v "^d" | head -10
echo ""
echo "Pour nettoyer:"
echo "  rm -rf demo_project demo_* example_custom.3src"
echo ""
echo "Pour voir tous les contextes:"
echo "  ./smcompress.sh --list-contexts"
