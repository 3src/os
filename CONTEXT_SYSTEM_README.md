# Système de Contextes .3src - Documentation Complète

## Vue d'Ensemble

Le **système de contextes** permet de définir des profils de filtrage réutilisables dans des fichiers `.3src` pour simplifier les opérations de compression/décompression.

## Fichiers Créés

- **smcompress.sh** - Smart Compression avec système de contextes
- **highlander.3src** - "There can be only one" - Uniquement l'essentiel
- **full.3src** - Backup complet sans filtres
- **docs.3src** - Documentation seulement
- **clean.3src** - Backup propre sans binaires/cache
- **test_smcompress.sh** - Suite de tests complète

## Le Contexte Highlander 🗡️

**"There can be only one"** - Seuls les fichiers essentiels survivent !

Le contexte highlander est parfait pour créer des backups minimaux contenant uniquement :
- ✅ Code source (PHP, JS, Python, etc.)
- ✅ Fichiers de configuration (JSON, YAML, INI, etc.)

Et excluant tout le reste :
- ❌ Binaires et exécutables
- ❌ Images et médias
- ❌ Archives
- ❌ Fichiers temporaires et cache

### Utilisation de Highlander

```bash
# Compression avec le contexte highlander
./smcompress.sh --context highlander system/ backup_essential 50

# Sur 16 fichiers → seulement 8 essentiels gardés
# Économie d'espace significative !
```

## Utilisation Générale

### Commandes de Base

```bash
# Lister les contextes disponibles
./smcompress.sh --list-contexts

# Utiliser un contexte
./smcompress.sh --context <nom> <source> <output> <size_MB>

# Aide détaillée
./smcompress.sh --help
```

### Exemples par Contexte

#### Highlander - L'Essentiel Seulement
```bash
./smcompress.sh --context highlander project/ backup_code 50
# Garde: code + configs
# Exclut: binaires, images, archives
```

#### Full - Tout Inclure
```bash
./smcompress.sh --context full project/ backup_full 100
# Inclut absolument tout
```

#### Docs - Documentation
```bash
./smcompress.sh --context docs project/ backup_docs 10
# Garde: .md, .txt, .pdf, .doc
# Exclut: code, binaires, images
```

#### Clean - Backup Propre
```bash
./smcompress.sh --context clean project/ backup_clean 50
# Garde: code, configs, docs
# Exclut: binaires, archives, .tmp, .cache
```

### Override Manuel

Vous pouvez combiner un contexte avec des options manuelles :

```bash
# Highlander + ajouter les fichiers XML
./smcompress.sh --context highlander --ext xml system/ backup 50

# Clean + exclure aussi les logs
./smcompress.sh --context clean --exclude-ext log project/ backup 25
```

## Format des Fichiers .3src

### Structure

```bash
# Nom et description
CONTEXT_NAME="nom_du_contexte"
CONTEXT_DESC="Description du contexte"

# Types à inclure (bash, code, text, config, etc.)
INCLUDE_TYPES="code config"

# Extensions à inclure
INCLUDE_EXTS=".sh .php .js .json .yaml"

# Types à exclure
EXCLUDE_TYPES="binary archive image"

# Extensions à exclure
EXCLUDE_EXTS=".exe .bin .tmp .cache"

# Options
INCLUDE_HIDDEN=0        # 0=non, 1=oui
MAX_FILE_SIZE_MB=10     # Limite de taille (future feature)
```

### Créer Votre Propre Contexte

Exemple : `myproject.3src`

```bash
# MyProject Context
CONTEXT_NAME="myproject"
CONTEXT_DESC="Configuration spécifique à mon projet"

# Uniquement PHP et JS
INCLUDE_TYPES="code"
INCLUDE_EXTS=".php .js"

# Pas d'images ni de cache
EXCLUDE_TYPES="image"
EXCLUDE_EXTS=".cache .tmp"

INCLUDE_HIDDEN=0
MAX_FILE_SIZE_MB=0
```

Utilisation :
```bash
./smcompress.sh --context myproject src/ backup 25
```

## Workflow Typique avec Highlander

### 1. Développement - Backup Quotidien

```bash
# Backup rapide du code uniquement (highlander)
./smcompress.sh --context highlander ~/project backup_daily 50
```

### 2. Pré-Production - Backup Complet

```bash
# Backup complet avant déploiement
./smcompress.sh --context full ~/project backup_preprod 100
```

### 3. Documentation - Pour Partage

```bash
# Extraire seulement la doc pour l'équipe
./smcompress.sh --context docs ~/project docs_team 5
```

### 4. Archive Propre - Pour Git

```bash
# Archive sans binaires pour versionner
./smcompress.sh --context clean ~/project archive_git 25
```

## Décompression avec Contextes

Les métadonnées du contexte sont sauvegardées dans l'archive :

```bash
# Lister le contenu (montre le contexte utilisé)
./decompress_filtered.sh --list backup

# Extraire normalement
./decompress_filtered.sh backup extracted/

# Ou filtrer encore plus à l'extraction
./decompress_filtered.sh --ext php backup php_only/
```

## Comparaison des Tailles

Test sur 16 fichiers mixtes :

| Contexte        | Fichiers | Taille | Usage                        |
|-----------------|----------|--------|------------------------------|
| **highlander**  | 8        | 436B   | Code + config essentiel      |
| **clean**       | 7        | 398B   | Sans binaires/cache          |
| **docs**        | 1        | 166B   | Documentation seule          |
| **full**        | 16       | ~900B  | Backup complet               |

**Highlander économise ~50% d'espace** en gardant uniquement l'essentiel !

## Avantages du Système

### 1. Réutilisabilité
- Définir une fois, utiliser partout
- Partager des contextes entre projets
- Standardiser les backups

### 2. Simplicité
```bash
# Au lieu de :
./compress_filtered.sh --type code --type config --exclude-type binary --exclude-type archive --exclude-ext .tmp --exclude-ext .cache project/ backup 50

# Simplement :
./smcompress.sh --context highlander project/ backup 50
```

### 3. Traçabilité
- Le contexte utilisé est sauvegardé dans les métadonnées
- On sait exactement comment l'archive a été créée

### 4. Flexibilité
- Combiner contextes et options manuelles
- Override facile pour cas spéciaux

## Cas d'Usage Réels

### Backup de Serveur Web (oneye)

```bash
# Code source uniquement (highlander)
./smcompress.sh --context highlander /var/www/oneye oneye_code 50

# Tout sauf les uploads utilisateurs
./smcompress.sh --context clean --exclude-ext jpg --exclude-ext png /var/www/oneye oneye_clean 100
```

### Projet de Développement

```bash
# Backup quotidien (code + configs)
./smcompress.sh --context highlander ~/myproject backup_$(date +%Y%m%d) 25

# Archive pour déploiement
./smcompress.sh --context clean ~/myproject deploy_package 50
```

### Migration de Projet

```bash
# Extraire juste le code PHP d'une archive complète
./decompress_filtered.sh --ext php old_backup extracted_php/
```

## Liste des Contextes Disponibles

Utilisez `./smcompress.sh --list-contexts` pour voir tous les contextes :

```
📦 highlander
   Description: There can be only one - Only the essential files
   Inclus: types=code config
   Exclus: types=binary archive image doc

📦 full
   Description: Full backup - All files included
   Inclus: types=all

📦 docs
   Description: Documentation files only
   Inclus: types=markdown text doc
   Exclus: types=code binary archive image

📦 clean
   Description: Clean backup without binaries, caches and temporary files
   Inclus: types=code config markdown text
   Exclus: types=binary archive
```

## Tests et Validation

```bash
# Exécuter la suite de tests complète
./test_smcompress.sh

# Tester le contexte highlander spécifiquement
./smcompress.sh --dry-run --context highlander system/ test 10
```

## Architecture

```
.
├── smcompress.sh              # Script principal
├── decompress_filtered.sh     # Décompression avec filtres
│
├── Contextes (.3src)
│   ├── highlander.3src        # L'essentiel seulement
│   ├── full.3src              # Tout inclure
│   ├── docs.3src              # Documentation
│   ├── clean.3src             # Backup propre
│   └── custom.3src            # Vos contextes personnalisés
│
└── test_smcompress.sh         # Suite de tests
```

## Philosophie Highlander

**"There can be only one"** - Dans un projet, seuls certains fichiers sont vraiment essentiels :

1. Le **code source** - C'est le cœur du projet
2. Les **configurations** - Sans elles, rien ne fonctionne
3. La **documentation** - Pour comprendre le projet

Tout le reste (binaires, cache, images, archives) peut être :
- Régénéré (binaires compilés)
- Récupéré (images, assets)
- Ignoré (cache, temporaires)

**Highlander garde uniquement ce qui ne peut pas être régénéré facilement.**

## Tips & Tricks

### Créer un Alias
```bash
alias backup-code='smcompress.sh --context highlander'
backup-code ~/project backup_$(date +%Y%m%d) 50
```

### Chaîne de Contextes
```bash
# Backup complet
./smcompress.sh --context full project/ full_backup 100

# Extraire juste le code depuis le backup complet
./decompress_filtered.sh --type code full_backup code_only/
```

### Dry-Run pour Tester
```bash
# Voir ce que highlander garderait
./smcompress.sh --dry-run --context highlander project/ test 10
```

## Dépannage

### "Aucun fichier ne correspond aux critères"
- Vérifiez le contexte avec `--list-contexts`
- Testez avec `--dry-run` pour voir les filtres appliqués
- Le contexte exclut peut-être trop de fichiers

### "Contexte non trouvé"
- Le fichier `.3src` doit être dans le répertoire courant
- Vérifiez l'orthographe : `--context highlander` cherche `highlander.3src`

### Vérifier les Métadonnées
```bash
cat backup_metadata.txt
# Montre le contexte utilisé et tous les filtres
```

## Conclusion

Le système de contextes `.3src` avec **smcompress.sh** offre :

✅ **Simplicité** - Une commande courte au lieu de multiples options
✅ **Puissance** - Le contexte Highlander garde l'essentiel
✅ **Flexibilité** - Créez vos propres contextes
✅ **Traçabilité** - Tout est dans les métadonnées
✅ **Réutilisabilité** - Définir une fois, utiliser partout

**"There can be only one"** - Highlander.3src est votre allié pour des backups essentiels ! 🗡️
