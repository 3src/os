# Plan d'Intégration sbmerge_v2

## Vue d'ensemble

Ce document décrit le plan d'intégration de **sbmerge_v2**, un système de fusion et compression en deux passes pour optimiser les fichiers du projet oneye.

## Architecture en Deux Passes

### Pass 1 : Analyse et Préparation
**Objectif** : Scanner et analyser les fichiers sources pour identifier les opportunités d'optimisation

**Tâches** :
- Parcourir l'arborescence des fichiers (system/apps, system/libs, etc.)
- Identifier les fichiers candidats (.php, .eyecode, .js)
- Exclure les répertoires tiers (system/extern)
- Générer un rapport d'analyse avec :
  - Liste des fichiers à traiter
  - Tailles actuelles
  - Dépendances détectées
  - Estimation de gain potentiel

**Sortie** :
- Fichier manifest JSON : `sbmerge_manifest.json`
- Log d'analyse : `sbmerge_pass1.log`

### Pass 2 : Fusion et Compression
**Objectif** : Appliquer les optimisations identifiées lors de la Pass 1

**Tâches** :
- Lire le manifest généré par Pass 1
- Appliquer les transformations :
  - Suppression des espaces blancs
  - Suppression des commentaires (optionnel)
  - Minification du code
  - Fusion de fichiers similaires (si applicable)
- Générer les fichiers optimisés
- Créer un mapping source pour debug

**Sortie** :
- Fichiers compressés : `*.min.php`, `*.min.js`
- Source maps : `*.map`
- Rapport final : `sbmerge_pass2.log`

## Implémentation

### Script Principal : smcompress.ss

```bash
#!/bin/bash
# smcompress.ss - Script de compression sbmerge_v2

usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --analyze         Pass 1: Analyse des fichiers"
    echo "  --compress        Pass 2: Compression des fichiers"
    echo "  --full            Exécuter les deux passes"
    echo "  --exclude PATH    Exclure un chemin"
    echo "  --help            Afficher cette aide"
}

# Configuration
EXCLUDE_DIRS=("system/extern" ".git" "docs")
OUTPUT_DIR="build/compressed"
MANIFEST="sbmerge_manifest.json"

# Pass 1: Analyse
analyze() {
    echo "=== PASS 1: Analyse ==="

    # Trouver tous les fichiers PHP et eyecode
    find ./system -type f \( -name "*.php" -o -name "*.eyecode" \) \
        | grep -v "system/extern" \
        | grep -v ".git" \
        > files_to_analyze.tmp

    # Trouver tous les fichiers JS (hors extern)
    find ./system -type f -name "*.js" \
        | grep -v "system/extern" \
        | grep -v ".git" \
        >> files_to_analyze.tmp

    # Générer le manifest
    echo "Génération du manifest..."
    # TODO: Parser et analyser chaque fichier
    # TODO: Créer sbmerge_manifest.json

    echo "Pass 1 terminée. Manifest: $MANIFEST"
}

# Pass 2: Compression
compress() {
    echo "=== PASS 2: Compression ==="

    if [ ! -f "$MANIFEST" ]; then
        echo "Erreur: Manifest introuvable. Exécutez --analyze d'abord."
        exit 1
    fi

    # Lire le manifest et compresser
    while IFS= read -r file; do
        echo "Compression: $file"
        # TODO: Appliquer la compression
        # TODO: Générer les fichiers .min
    done < "$MANIFEST"

    echo "Pass 2 terminée. Fichiers dans: $OUTPUT_DIR"
}

# Main
case "$1" in
    --analyze)
        analyze
        ;;
    --compress)
        compress
        ;;
    --full)
        analyze
        compress
        ;;
    --help)
        usage
        ;;
    *)
        usage
        exit 1
        ;;
esac
```

## Commandes d'Utilisation

### Exécution Complète (2 passes)
```bash
./smcompress.ss --full
```

### Exécution Manuelle des Passes

**Pass 1 uniquement :**
```bash
./smcompress.ss --analyze
```

**Pass 2 uniquement (après Pass 1) :**
```bash
./smcompress.ss --compress
```

### Avec Filtres Personnalisés

```bash
# Analyser uniquement les apps
find ./system/apps -type f -name "*.eyecode" | ./smcompress.ss --compress

# Exclure certains dossiers
./smcompress.ss --analyze --exclude "system/extern" --exclude "docs"
```

## Structure des Fichiers de Sortie

```
/home/user/os/
├── docs/
│   └── sbmerge_v2_integration_plan.md (ce fichier)
├── smcompress.ss (script principal)
├── sbmerge_manifest.json (généré par Pass 1)
├── sbmerge_pass1.log (log Pass 1)
├── sbmerge_pass2.log (log Pass 2)
└── build/
    └── compressed/
        ├── system/
        │   ├── apps/
        │   │   └── *.min.eyecode
        │   └── libs/
        │       └── *.min.php
        └── maps/
            └── *.map
```

## Intégration avec oneye

### Modifications Requises

1. **Chargement Conditionnel** : Ajouter une option de configuration pour utiliser les versions compressées
2. **Mode Debug** : Conserver les fichiers originaux en mode développement
3. **Cache** : Implémenter un système de cache pour les fichiers compressés

### Fichier de Configuration

Ajouter dans `settings.php` :
```php
// sbmerge_v2 configuration
define('SBMERGE_ENABLED', false); // true en production
define('SBMERGE_USE_COMPRESSED', SBMERGE_ENABLED);
define('SBMERGE_COMPRESSED_PATH', 'build/compressed/');
```

## Timeline d'Implémentation

1. ✅ Créer le plan d'intégration (ce document)
2. ⏳ Implémenter smcompress.ss (Pass 1)
3. ⏳ Implémenter smcompress.ss (Pass 2)
4. ⏳ Tester sur un sous-ensemble de fichiers
5. ⏳ Intégrer avec le système de build oneye
6. ⏳ Documentation utilisateur
7. ⏳ Déploiement et validation

## Tests et Validation

### Tests Unitaires
- Vérifier la compression sans perte de fonctionnalité
- Valider les source maps
- Tester les exclusions de fichiers

### Tests d'Intégration
- Vérifier que oneye démarre avec les fichiers compressés
- Tester toutes les applications principales
- Benchmark des performances (temps de chargement, taille)

### Métriques de Succès
- Réduction de taille : objectif 30-50%
- Performance : pas de dégradation
- Compatibilité : 100% des fonctionnalités préservées

## Notes Techniques

### Fichiers à Exclure
- `system/extern/**` (bibliothèques tierces)
- `*.min.js` (déjà minifiés)
- `*.min.php` (déjà minifiés)
- Fichiers de configuration

### Gestion des Erreurs
- Sauvegarde automatique avant compression
- Rollback en cas d'échec
- Logs détaillés pour debugging

### Performance
- Traitement parallèle des fichiers (si possible)
- Cache des résultats d'analyse
- Compression incrémentale (uniquement fichiers modifiés)

## Références

- Compression PHP : PHP Minifier, php-compressor
- Compression JS : Closure Compiler (déjà présent dans docs/)
- YUI Compressor : déjà disponible dans docs/yuicompressor/

---

**Version** : 1.0
**Date** : 2025-11-23
**Auteur** : Claude Code
**Branch** : claude/sbmerge-integration-plan-01Tkk7HGfWkFExVQgLUjRBgu
