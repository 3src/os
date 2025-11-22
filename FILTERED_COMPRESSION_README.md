# Compression avec Filtres Avancés - Proof of Concept

## Description

Scripts robustes pour compresser/décompresser des fichiers avec **filtres avancés par type et extension** en utilisant des **for loops**.

## Nouveaux Fichiers

- `compress_filtered.sh` - Compression avec filtres de types de fichiers
- `decompress_filtered.sh` - Décompression avec filtres utilisant for loops
- `test_filtered_compression.sh` - Tests de démonstration complets

## Fonctionnalités Principales

### ✨ Filtrage Intelligent

**Filtres par contexte flou** (langage naturel):
- `bash`, `sh` - Scripts bash
- `markdown`, `md` - Documentation markdown
- `text`, `txt` - Fichiers texte
- `code` - Code source (PHP, JS, Python, C, Java, etc.)
- `config` - Fichiers de configuration
- `bin`, `binary` - Fichiers binaires
- `image` - Images
- `archive` - Archives
- `doc` - Documents

**Filtres par extension** spécifique:
- `.sh`, `.php`, `.js`, `.md`, etc.

**Modes inclusion/exclusion**:
- `--type` / `--ext` pour inclure
- `--exclude-type` / `--exclude-ext` pour exclure

## Utilisation

### Compression avec Filtres

```bash
./compress_filtered.sh [OPTIONS] <source> <output_prefix> <size_in_MB>
```

**Options:**
```
--type TYPE          Filtrer par type (bash, code, text, etc.)
--ext EXT            Filtrer par extension (.sh, .php, etc.)
--exclude-type TYPE  Exclure un type
--exclude-ext EXT    Exclure une extension
--include-hidden     Inclure fichiers cachés
--dry-run            Simuler sans compresser
-h, --help           Afficher l'aide
```

**Exemples:**

```bash
# Compresser uniquement les scripts bash
./compress_filtered.sh --type bash /path/to/dir archive 10

# Compresser le code source (PHP, JS, Python, etc.)
./compress_filtered.sh --type code system/ code_backup 50

# Compresser markdown + texte
./compress_filtered.sh --type markdown --type text docs/ docs_backup 5

# Tout SAUF les binaires et archives
./compress_filtered.sh --exclude-type binary --exclude-type archive project/ clean_backup 10

# Uniquement extensions .sh et .md
./compress_filtered.sh --ext sh --ext md scripts/ scripts_backup 5

# Voir ce qui serait compressé (dry-run)
./compress_filtered.sh --dry-run --type code system/ test 10
```

### Décompression avec Filtres

```bash
./decompress_filtered.sh [OPTIONS] <archive_prefix> [output_dir]
```

**Options:**
```
--type TYPE          Extraire uniquement ce type
--ext EXT            Extraire uniquement cette extension
--exclude-type TYPE  Exclure un type
--exclude-ext EXT    Exclure une extension
--list               Lister sans extraire
--dry-run            Simuler sans extraire
-h, --help           Afficher l'aide
```

**Exemples:**

```bash
# Lister le contenu de l'archive
./decompress_filtered.sh --list archive

# Décompresser tout
./decompress_filtered.sh archive /path/to/extract

# Extraire uniquement les fichiers PHP
./decompress_filtered.sh --ext php archive /path/to/extract

# Extraire uniquement le code source
./decompress_filtered.sh --type code archive extracted_code/

# Extraire tout sauf les binaires
./decompress_filtered.sh --exclude-type binary archive extracted/

# Voir ce qui serait extrait (dry-run)
./decompress_filtered.sh --dry-run --type code archive test/
```

## Exemples Pratiques

### 1. Backup du Code Source Uniquement

```bash
# Compression
./compress_filtered.sh --type code my_project/ project_code 50

# Décompression
./decompress_filtered.sh project_code restored_code/
```

### 2. Backup de la Documentation

```bash
# Compresser MD + TXT
./compress_filtered.sh --type markdown --type text docs/ docs_backup 10

# Lister le contenu
./decompress_filtered.sh --list docs_backup
```

### 3. Archive Propre (sans binaires ni archives)

```bash
# Exclure binaires et archives
./compress_filtered.sh \
  --exclude-type binary \
  --exclude-type archive \
  --exclude-type image \
  project/ clean_archive 25
```

### 4. Extraction Sélective depuis Archive Complète

```bash
# Compresser tout
./compress_filtered.sh project/ full_backup 100

# Extraire uniquement le PHP
./decompress_filtered.sh --ext php full_backup php_only/

# Extraire uniquement les configs
./decompress_filtered.sh --type config full_backup config_only/
```

## Types de Fichiers Supportés

| Type      | Extensions                                                |
|-----------|-----------------------------------------------------------|
| bash      | `.sh .bash`                                               |
| markdown  | `.md .markdown`                                           |
| text      | `.txt .text .log`                                         |
| code      | `.php .js .py .c .cpp .java .go .rb .pl .cs .ts` etc.    |
| config    | `.conf .cfg .ini .json .xml .yaml .yml .toml .env`       |
| binary    | `.exe .bin .so .dll .a .o .pyc .class`                   |
| image     | `.jpg .png .gif .bmp .svg .ico .webp`                    |
| archive   | `.zip .tar .gz .bz2 .xz .7z .rar`                        |
| doc       | `.pdf .doc .docx .odt .xls .xlsx .ppt`                   |

## Workflow Typique

```bash
# 1. Vérifier ce qui sera compressé (dry-run)
./compress_filtered.sh --dry-run --type code system/ backup 10

# 2. Compresser
./compress_filtered.sh --type code system/ backup 10

# 3. Lister le contenu de l'archive
./decompress_filtered.sh --list backup

# 4. Tester l'extraction (dry-run)
./decompress_filtered.sh --dry-run backup test_extract/

# 5. Extraire
./decompress_filtered.sh backup extracted/
```

## Métadonnées

Chaque compression crée un fichier `<prefix>_metadata.txt` contenant:
- Source
- Filtres utilisés
- Nombre de fichiers
- Nombre de parties
- Date de création

## Caractéristiques Techniques

- ✓ **Sans fonctions** - Code linéaire robuste
- ✓ **For loops** - Démonstration claire des boucles
- ✓ **Filtres flexibles** - Combiner plusieurs types/extensions
- ✓ **Inclusion/Exclusion** - Contrôle précis
- ✓ **Dry-run** - Simuler avant d'exécuter
- ✓ **Métadonnées** - Traçabilité complète
- ✓ **Validation** - Vérification robuste des arguments
- ✓ **Aide intégrée** - Documentation avec `-h`

## Test de Démonstration

```bash
./test_filtered_compression.sh
```

Ce script créé des fichiers de test variés et démontre:
1. Compression de tous les fichiers
2. Filtrage par type (bash, code, config, etc.)
3. Filtrage par extension
4. Exclusions
5. Décompression avec filtres
6. Extraction sélective

## Avantages

1. **Flexibilité maximale** - Combiner plusieurs critères
2. **Langage flou** - Types compréhensibles (bash, code, text)
3. **Extensions précises** - Contrôle fin si nécessaire
4. **Sécurité** - Dry-run avant exécution
5. **Traçabilité** - Métadonnées complètes
6. **Performance** - Filtrage au moment de la compression/extraction

## Exemples Réels

### Backup du système oneye

```bash
# Code PHP uniquement (économise de l'espace)
./compress_filtered.sh --type code system/ oneye_code 50

# Configs seulement
./compress_filtered.sh --type config system/ oneye_config 5

# Tout sauf images et archives
./compress_filtered.sh --exclude-type image --exclude-type archive system/ oneye_clean 50
```

### Restauration sélective

```bash
# Restaurer uniquement les fichiers PHP depuis une archive complète
./decompress_filtered.sh --ext php system_full_backup restored_php/

# Restaurer configs et code
./decompress_filtered.sh --type code --type config system_backup restored/
```

## Nettoyage

```bash
rm -rf test_mixed_data filtered_* extracted_*
```

## Notes

- Les filtres s'appliquent aux **fichiers** uniquement (pas aux répertoires)
- Les fichiers cachés (`.xxx`) sont exclus par défaut (utiliser `--include-hidden`)
- Combiner plusieurs `--type` ou `--ext` fait un **OU logique**
- Les exclusions sont prioritaires sur les inclusions
- Sans filtres, tous les fichiers sont inclus
