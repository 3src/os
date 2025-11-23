# 🗡️ Smart Compression System with .3src Contexts

> **"There can be only one"** - Backup only what truly matters

Un système complet de compression/décompression avec **filtres intelligents** et **contextes réutilisables**.

---

## 🚀 Quick Start

```bash
# Lister tous les contextes disponibles
./smcompress.sh --list-contexts

# Backup essentiel avec Highlander (code + config uniquement)
./smcompress.sh --context highlander system/ backup 50

# Backup complet
./smcompress.sh --context full project/ full_backup 100

# Voir la démo complète
./demo_contexts.sh
```

---

## 📦 Trois Niveaux de Compression

### Niveau 1: Compression Simple
**Scripts**: `compress_fixed_size.sh`, `decompress_archives.sh`

Compression basique en fichiers de taille fixe avec for loops.

```bash
./compress_fixed_size.sh source/ backup 10
./decompress_archives.sh backup extracted/
```

### Niveau 2: Filtres Avancés
**Scripts**: `compress_filtered.sh`, `decompress_filtered.sh`

Filtrage flexible par type et extension.

```bash
# Compresser uniquement le code
./compress_filtered.sh --type code project/ backup 50

# Extraire uniquement les .php
./decompress_filtered.sh --ext php backup php_only/
```

### Niveau 3: Système de Contextes ⭐
**Script**: `smcompress.sh`

Profils de filtrage réutilisables via fichiers `.3src`.

```bash
# Simple et puissant
./smcompress.sh --context highlander project/ backup 50
```

---

## 🗡️ Les 12 Contextes Disponibles

### Contextes Essentiels

#### 1. **highlander** - "There can be only one"
Le contexte **vedette** - Garde uniquement l'essentiel :
- ✅ Code source (PHP, JS, Python, etc.)
- ✅ Configurations (JSON, YAML, INI, etc.)
- ❌ Exclut binaires, images, archives

**Usage**: Backup quotidien de développement
```bash
./smcompress.sh --context highlander ~/project backup_$(date +%Y%m%d) 50
```

#### 2. **full** - Backup Complet
Inclut absolument tout sans filtres.
```bash
./smcompress.sh --context full ~/project full_backup 100
```

#### 3. **clean** - Backup Propre
Code + configs + docs, sans binaires ni cache.
```bash
./smcompress.sh --context clean ~/project clean_backup 50
```

### Contextes Spécialisés

#### 4. **web** - Développement Web
HTML, CSS, JS, PHP - tous les fichiers web.
```bash
./smcompress.sh --context web ~/website deploy 25
```

#### 5. **backend** - Code Serveur
PHP, Python, Java, Go - uniquement le backend.
```bash
./smcompress.sh --context backend ~/api backend_backup 50
```

#### 6. **frontend** - Code Client
HTML, CSS, JS, React - frontend + assets.
```bash
./smcompress.sh --context frontend ~/app frontend_cdn 75
```

#### 7. **source** - Code Pur
Code source uniquement, sans configs ni docs.
```bash
./smcompress.sh --context source ~/project code_review 25
```

#### 8. **docs** - Documentation
Markdown, TXT, PDF - documentation uniquement.
```bash
./smcompress.sh --context docs ~/project docs_share 10
```

#### 9. **minimal** - Ultra Minimal
Uniquement les configs critiques.
```bash
./smcompress.sh --context minimal ~/project config_migrate 5
```

### Contextes Techniques

#### 10. **database** - Base de Données
Schémas SQL, migrations, fichiers DB.
```bash
./smcompress.sh --context database ~/project db_schemas 10
```

#### 11. **security** - Sécurité
Certificats, clés, .env - fichiers sensibles.
```bash
./smcompress.sh --context security ~/project security_audit 1
```

#### 12. **media** - Médias
Images, vidéos, audio.
```bash
./smcompress.sh --context media ~/project media_backup 500
```

---

## 📊 Comparaison des Contextes

Test sur un projet complet (28 fichiers) :

| Contexte   | Fichiers | Taille | Usage Principal                    |
|------------|----------|--------|------------------------------------|
| highlander | 11       | ~600B  | Backup quotidien dev               |
| web        | 8        | ~450B  | Déploiement web                    |
| frontend   | 7        | ~420B  | Assets pour CDN                    |
| backend    | 7        | ~380B  | Code serveur                       |
| docs       | 3        | ~200B  | Documentation                      |
| minimal    | 3        | ~150B  | Migration configs                  |
| source     | 7        | ~320B  | Code pour review                   |
| clean      | 14       | ~750B  | Archive propre                     |
| full       | 28       | ~1.2K  | Backup complet                     |

**Highlander économise ~50% d'espace** par rapport au backup complet ! 🎯

---

## 🎯 Cas d'Usage par Rôle

### Pour Développeurs
```bash
# Backup quotidien (code + config)
./smcompress.sh --context highlander ~/project backup_daily 50

# Code review (code pur)
./smcompress.sh --context source ~/project review 25
```

### Pour DevOps
```bash
# Configs et secrets
./smcompress.sh --context minimal ~/infra configs 5

# Audit sécurité
./smcompress.sh --context security ~/prod security_check 1
```

### Pour Designers
```bash
# Frontend + images
./smcompress.sh --context frontend ~/app design_assets 100

# Médias uniquement
./smcompress.sh --context media ~/project media 500
```

### Pour Équipe Docs
```bash
# Documentation complète
./smcompress.sh --context docs ~/project docs_v2 10
```

---

## 🛠️ Créer Vos Propres Contextes

### Format .3src

Créez un fichier `mycontext.3src` :

```bash
# Mon Contexte Personnalisé
CONTEXT_NAME="mycontext"
CONTEXT_DESC="Description de mon contexte"

# Ce qu'il faut inclure
INCLUDE_TYPES="code config"
INCLUDE_EXTS=".myext .custom"

# Ce qu'il faut exclure
EXCLUDE_TYPES="binary archive"
EXCLUDE_EXTS=".tmp .cache"

# Options
INCLUDE_HIDDEN=0        # 0=non, 1=oui
MAX_FILE_SIZE_MB=50     # Limite (future feature)
```

### Utilisation

```bash
./smcompress.sh --context mycontext source/ output 25
```

---

## 🔥 Workflows Avancés

### 1. Backup Incrémental par Type
```bash
# Lundi: Code
./smcompress.sh --context highlander project/ mon_code 50

# Mardi: Media
./smcompress.sh --context media project/ tue_media 100

# Mercredi: Docs
./smcompress.sh --context docs project/ wed_docs 10
```

### 2. Migration Serveur
```bash
# Serveur A: Extraire configs
./smcompress.sh --context minimal /var/www/ server_a_configs 5

# Serveur B: Restaurer
./decompress_filtered.sh server_a_configs /var/www/
```

### 3. Déploiement Multi-Environnement
```bash
# Dev: Code + docs
./smcompress.sh --context clean project/ deploy_dev 25

# Staging: Web seulement
./smcompress.sh --context web project/ deploy_staging 50

# Prod: Backend optimisé
./smcompress.sh --context backend project/ deploy_prod 30
```

### 4. Collaboration d'Équipe
```bash
# Pour devs backend
./smcompress.sh --context backend project/ team_backend 50

# Pour devs frontend
./smcompress.sh --context frontend project/ team_frontend 75

# Pour tout le monde
./smcompress.sh --context docs project/ team_docs 10
```

---

## 📚 Documentation Détaillée

- **COMPRESSION_README.md** - Guide des scripts de base
- **FILTERED_COMPRESSION_README.md** - Filtres avancés
- **CONTEXT_SYSTEM_README.md** - Système de contextes complet

---

## 🧪 Tests et Démos

```bash
# Tests de base
./test_compression.sh

# Tests des filtres
./test_filtered_compression.sh

# Tests des contextes
./test_smcompress.sh

# Démo complète de tous les contextes
./demo_contexts.sh
```

---

## 💡 Tips & Astuces

### Voir ce qui sera compressé (dry-run)
```bash
./smcompress.sh --dry-run --context highlander project/ test 10
```

### Combiner contexte + override
```bash
# Highlander + ajouter XML
./smcompress.sh --context highlander --ext xml project/ backup 50
```

### Créer des alias
```bash
alias backup-code='smcompress.sh --context highlander'
alias backup-full='smcompress.sh --context full'
alias backup-web='smcompress.sh --context web'
```

### Extraction sélective
```bash
# Extraire uniquement les .php depuis une archive complète
./decompress_filtered.sh --ext php full_backup php_only/
```

---

## 🎬 Exemple Complet

```bash
# 1. Voir les contextes disponibles
./smcompress.sh --list-contexts

# 2. Tester ce qui sera sauvegardé
./smcompress.sh --dry-run --context highlander system/ test 50

# 3. Compresser avec highlander
./smcompress.sh --context highlander system/ backup_essential 50

# 4. Lister le contenu
./decompress_filtered.sh --list backup_essential

# 5. Extraire
./decompress_filtered.sh backup_essential restored/
```

---

## 🗡️ Philosophie Highlander

**"There can be only one"**

Dans un projet, certains fichiers sont **irremplaçables** :
1. **Code source** - Le cœur du projet
2. **Configurations** - Sans elles, rien ne fonctionne

Tout le reste peut être **régénéré** ou **récupéré** :
- Binaires → Recompiler
- Images → Assets récupérables
- Cache → Se régénère
- Archives → Redondant

**Highlander garde uniquement ce qui ne peut pas être recréé.**

---

## 📦 Fichiers du Système

```
Compression System/
├── Scripts de base
│   ├── compress_fixed_size.sh
│   ├── decompress_archives.sh
│   └── test_compression.sh
│
├── Scripts avec filtres
│   ├── compress_filtered.sh
│   ├── decompress_filtered.sh
│   └── test_filtered_compression.sh
│
├── Système de contextes
│   ├── smcompress.sh (★ Principal)
│   └── test_smcompress.sh
│
├── Contextes .3src (12)
│   ├── highlander.3src (★ Vedette)
│   ├── full.3src
│   ├── clean.3src
│   ├── docs.3src
│   ├── web.3src
│   ├── backend.3src
│   ├── frontend.3src
│   ├── source.3src
│   ├── minimal.3src
│   ├── database.3src
│   ├── security.3src
│   └── media.3src
│
├── Démos et docs
│   ├── demo_contexts.sh (Démo complète)
│   ├── README_COMPRESSION.md (Ce fichier)
│   ├── COMPRESSION_README.md
│   ├── FILTERED_COMPRESSION_README.md
│   └── CONTEXT_SYSTEM_README.md
```

---

## 🚀 Installation Rapide

```bash
# Cloner le repo
git clone <repo-url>
cd os

# Rendre exécutable
chmod +x *.sh

# Voir les contextes
./smcompress.sh --list-contexts

# Première compression
./smcompress.sh --context highlander system/ my_first_backup 50
```

---

## ❓ FAQ

**Q: Quel contexte utiliser pour un backup quotidien ?**
R: `highlander` - Code + configs uniquement, rapide et efficace.

**Q: Comment migrer juste les configs ?**
R: `minimal` - Uniquement les fichiers de configuration critiques.

**Q: Besoin de tout sauvegarder ?**
R: `full` - Backup complet sans filtres.

**Q: Pour déployer un site web ?**
R: `web` - Tous les fichiers web (HTML, CSS, JS, PHP).

**Q: Créer mon propre contexte ?**
R: Créez un fichier `.3src` avec vos critères.

---

## 🎯 Résumé

- **12 contextes** prêts à l'emploi
- **3 niveaux** de compression (simple, filtré, contexte)
- **Highlander** économise ~50% d'espace
- **For loops** pour proof of concept
- **Documentation complète**
- **Tests exhaustifs**

**Le système le plus flexible pour vos backups !** 🚀

---

## 📞 Support

Pour toute question :
1. Consultez la documentation détaillée
2. Exécutez `./demo_contexts.sh` pour voir des exemples
3. Utilisez `--help` sur chaque script

---

**"There can be only one"** - Choisissez le contexte qui compte ! 🗡️
