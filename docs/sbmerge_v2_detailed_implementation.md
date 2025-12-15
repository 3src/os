# Plan d'Implémentation Détaillé - sbmerge_v2

## Table des Matières

1. [Architecture Globale](#architecture-globale)
2. [Structures de Données](#structures-de-données)
3. [Pass 1: Analyse Détaillée](#pass-1-analyse-détaillée)
4. [Pass 2: Compression Détaillée](#pass-2-compression-détaillée)
5. [Modules et Composants](#modules-et-composants)
6. [Algorithmes](#algorithmes)
7. [Gestion des Erreurs](#gestion-des-erreurs)
8. [Tests Détaillés](#tests-détaillés)
9. [Optimisations](#optimisations)
10. [Déploiement](#déploiement)

---

## 1. Architecture Globale

### 1.1 Vue d'Ensemble du Système

```
┌─────────────────────────────────────────────────────────────┐
│                      sbmerge_v2 System                       │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────┐        ┌──────────────┐                   │
│  │   smcompress │───────▶│ Pass 1 Core  │                   │
│  │   .ss (CLI)  │        │  (Analyzer)  │                   │
│  └──────────────┘        └───────┬──────┘                   │
│         │                        │                           │
│         │                        ▼                           │
│         │              ┌──────────────────┐                  │
│         │              │ Manifest Builder │                  │
│         │              └────────┬─────────┘                  │
│         │                       │                            │
│         │                       ▼                            │
│         │              sbmerge_manifest.json                 │
│         │                       │                            │
│         │                       │                            │
│         └──────────────┐        │                            │
│                        │        │                            │
│                        ▼        ▼                            │
│                  ┌──────────────────┐                        │
│                  │   Pass 2 Core    │                        │
│                  │  (Compressor)    │                        │
│                  └────────┬─────────┘                        │
│                           │                                  │
│              ┌────────────┼────────────┐                     │
│              │            │            │                     │
│         ┌────▼───┐   ┌────▼───┐  ┌────▼────┐                │
│         │  PHP   │   │   JS   │  │ eyecode │                │
│         │Minifier│   │Minifier│  │ Minifier│                │
│         └────┬───┘   └────┬───┘  └────┬────┘                │
│              │            │            │                     │
│              └────────────┼────────────┘                     │
│                           │                                  │
│                           ▼                                  │
│                  build/compressed/                           │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

### 1.2 Flux de Données

```
Input Files → Scanner → Analyzer → Manifest → Compressor → Output Files
     │           │         │          │           │              │
     │           │         │          │           │              │
  *.php      File Tree  Metadata   JSON File  Minification   *.min.php
  *.js       Builder    Collector              Transform      *.min.js
  *.eyecode                                    Source Maps    *.map
```

### 1.3 Architecture en Couches

```
┌─────────────────────────────────────┐
│      Couche Interface (CLI)         │  ← smcompress.ss
├─────────────────────────────────────┤
│      Couche Orchestration           │  ← Pass Manager
├─────────────────────────────────────┤
│      Couche Métier                  │  ← Analyzer, Compressor
├─────────────────────────────────────┤
│      Couche Traitement              │  ← Minifiers, Parsers
├─────────────────────────────────────┤
│      Couche Utilitaires             │  ← File I/O, Logger
└─────────────────────────────────────┘
```

---

## 2. Structures de Données

### 2.1 Manifest JSON Schema

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "properties": {
    "version": {
      "type": "string",
      "description": "Version du manifest (semantic versioning)"
    },
    "timestamp": {
      "type": "string",
      "format": "date-time",
      "description": "Date et heure de génération"
    },
    "config": {
      "type": "object",
      "properties": {
        "project_root": {"type": "string"},
        "output_dir": {"type": "string"},
        "exclude_patterns": {
          "type": "array",
          "items": {"type": "string"}
        },
        "compression_level": {
          "type": "integer",
          "minimum": 0,
          "maximum": 9
        }
      }
    },
    "stats": {
      "type": "object",
      "properties": {
        "total_files": {"type": "integer"},
        "total_size_bytes": {"type": "integer"},
        "estimated_compressed_size": {"type": "integer"},
        "estimated_savings_percent": {"type": "number"}
      }
    },
    "files": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "path": {"type": "string"},
          "type": {
            "type": "string",
            "enum": ["php", "js", "eyecode"]
          },
          "size": {"type": "integer"},
          "hash": {"type": "string"},
          "modified_time": {"type": "string"},
          "dependencies": {
            "type": "array",
            "items": {"type": "string"}
          },
          "includes": {
            "type": "array",
            "items": {"type": "string"}
          },
          "complexity": {
            "type": "object",
            "properties": {
              "lines": {"type": "integer"},
              "functions": {"type": "integer"},
              "classes": {"type": "integer"}
            }
          },
          "compression_metadata": {
            "type": "object",
            "properties": {
              "can_remove_comments": {"type": "boolean"},
              "can_remove_whitespace": {"type": "boolean"},
              "can_minify_variables": {"type": "boolean"},
              "mergeable_with": {
                "type": "array",
                "items": {"type": "string"}
              }
            }
          }
        },
        "required": ["path", "type", "size", "hash"]
      }
    },
    "merge_groups": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "group_id": {"type": "string"},
          "output_file": {"type": "string"},
          "source_files": {
            "type": "array",
            "items": {"type": "string"}
          },
          "merge_strategy": {
            "type": "string",
            "enum": ["concat", "smart_merge", "module_wrap"]
          }
        }
      }
    }
  },
  "required": ["version", "timestamp", "config", "files"]
}
```

### 2.2 Exemple de Manifest

```json
{
  "version": "2.0.0",
  "timestamp": "2025-11-23T10:30:00Z",
  "config": {
    "project_root": "/home/user/os",
    "output_dir": "build/compressed",
    "exclude_patterns": [
      "system/extern/**",
      "**/*.min.js",
      "**/*.min.php"
    ],
    "compression_level": 7
  },
  "stats": {
    "total_files": 1247,
    "total_size_bytes": 15728640,
    "estimated_compressed_size": 7864320,
    "estimated_savings_percent": 50.0
  },
  "files": [
    {
      "path": "system/system/kernel/kernel.eyecode",
      "type": "eyecode",
      "size": 52480,
      "hash": "sha256:abc123...",
      "modified_time": "2025-11-20T15:22:10Z",
      "dependencies": [
        "system/system/lib/eyeFiles/main.eyecode",
        "system/system/lib/eyeMessages/main.eyecode"
      ],
      "includes": [
        "system/system/conf/config.eyecode"
      ],
      "complexity": {
        "lines": 1542,
        "functions": 87,
        "classes": 12
      },
      "compression_metadata": {
        "can_remove_comments": true,
        "can_remove_whitespace": true,
        "can_minify_variables": false,
        "mergeable_with": []
      }
    }
  ],
  "merge_groups": [
    {
      "group_id": "kernel_libs",
      "output_file": "build/compressed/system/kernel_bundle.min.eyecode",
      "source_files": [
        "system/system/kernel/kernel.eyecode",
        "system/system/kernel/helpers.eyecode"
      ],
      "merge_strategy": "smart_merge"
    }
  ]
}
```

### 2.3 Configuration File (.sbmergerc)

```json
{
  "pass1": {
    "scan_directories": [
      "system/system",
      "system/apps"
    ],
    "file_patterns": {
      "include": ["*.php", "*.eyecode", "*.js"],
      "exclude": ["*.min.js", "*.min.php", "*.min.eyecode"]
    },
    "analysis": {
      "detect_dependencies": true,
      "calculate_complexity": true,
      "hash_algorithm": "sha256"
    }
  },
  "pass2": {
    "compression": {
      "php": {
        "remove_comments": true,
        "remove_whitespace": true,
        "preserve_line_breaks": false,
        "minify_variables": false
      },
      "js": {
        "use_closure_compiler": true,
        "compilation_level": "SIMPLE_OPTIMIZATIONS",
        "generate_source_maps": true
      },
      "eyecode": {
        "remove_comments": true,
        "remove_whitespace": true,
        "preserve_php_tags": true
      }
    },
    "output": {
      "create_backups": true,
      "backup_dir": "build/backups",
      "preserve_directory_structure": true
    }
  },
  "logging": {
    "level": "info",
    "file": "sbmerge.log",
    "max_size_mb": 10
  }
}
```

---

## 3. Pass 1: Analyse Détaillée

### 3.1 Algorithme de Scan

```python
# Pseudocode pour le scanner de fichiers

def scan_files(root_directory, config):
    """
    Scanner récursif avec filtres et exclusions
    """
    file_list = []
    exclude_patterns = load_exclude_patterns(config)

    for dirpath, dirnames, filenames in walk(root_directory):
        # Filtrer les répertoires exclus
        dirnames[:] = [d for d in dirnames
                      if not matches_exclude(d, exclude_patterns)]

        for filename in filenames:
            full_path = join(dirpath, filename)

            # Vérifier les patterns d'inclusion/exclusion
            if should_process_file(full_path, config):
                file_info = extract_file_metadata(full_path)
                file_list.append(file_info)

    return file_list

def should_process_file(filepath, config):
    """
    Détermine si un fichier doit être traité
    """
    # Vérifier l'extension
    extension = get_extension(filepath)
    if extension not in config['file_patterns']['include']:
        return False

    # Vérifier si déjà minifié
    if is_already_minified(filepath):
        return False

    # Vérifier les exclusions
    if matches_exclude_patterns(filepath, config['exclude_patterns']):
        return False

    return True
```

### 3.2 Extraction de Métadonnées

```python
def extract_file_metadata(filepath):
    """
    Extrait toutes les métadonnées d'un fichier
    """
    metadata = {
        'path': filepath,
        'type': detect_file_type(filepath),
        'size': get_file_size(filepath),
        'hash': calculate_hash(filepath, 'sha256'),
        'modified_time': get_modified_time(filepath),
        'dependencies': [],
        'includes': [],
        'complexity': {},
        'compression_metadata': {}
    }

    # Analyser le contenu
    content = read_file(filepath)

    # Détecter les dépendances
    metadata['dependencies'] = extract_dependencies(content, metadata['type'])

    # Détecter les includes/requires
    metadata['includes'] = extract_includes(content, metadata['type'])

    # Calculer la complexité
    metadata['complexity'] = calculate_complexity(content, metadata['type'])

    # Métadonnées de compression
    metadata['compression_metadata'] = analyze_compression_potential(
        content,
        metadata['type']
    )

    return metadata
```

### 3.3 Détection de Dépendances

```python
def extract_dependencies(content, file_type):
    """
    Extrait les dépendances selon le type de fichier
    """
    dependencies = []

    if file_type in ['php', 'eyecode']:
        # Détecter include, require, include_once, require_once
        patterns = [
            r'require_once\s*\(?[\'"]([^\'"]+)[\'"]',
            r'require\s*\(?[\'"]([^\'"]+)[\'"]',
            r'include_once\s*\(?[\'"]([^\'"]+)[\'"]',
            r'include\s*\(?[\'"]([^\'"]+)[\'"]',
        ]

        for pattern in patterns:
            matches = re.findall(pattern, content)
            dependencies.extend(matches)

    elif file_type == 'js':
        # Détecter import, require (CommonJS, ES6)
        patterns = [
            r'import\s+.*\s+from\s+[\'"]([^\'"]+)[\'"]',
            r'require\s*\([\'"]([^\'"]+)[\'"]\)',
        ]

        for pattern in patterns:
            matches = re.findall(pattern, content)
            dependencies.extend(matches)

    return list(set(dependencies))  # Dédupliquer
```

### 3.4 Calcul de Complexité

```python
def calculate_complexity(content, file_type):
    """
    Calcule les métriques de complexité du code
    """
    complexity = {
        'lines': 0,
        'lines_of_code': 0,
        'comment_lines': 0,
        'blank_lines': 0,
        'functions': 0,
        'classes': 0,
        'cyclomatic_complexity': 0
    }

    lines = content.split('\n')
    complexity['lines'] = len(lines)

    if file_type in ['php', 'eyecode']:
        # Compter les fonctions PHP
        complexity['functions'] = len(re.findall(
            r'function\s+\w+\s*\(',
            content
        ))

        # Compter les classes PHP
        complexity['classes'] = len(re.findall(
            r'class\s+\w+',
            content
        ))

    elif file_type == 'js':
        # Compter les fonctions JS
        complexity['functions'] = len(re.findall(
            r'function\s+\w*\s*\(',
            content
        )) + len(re.findall(
            r'\w+\s*=\s*function\s*\(',
            content
        )) + len(re.findall(
            r'\(\s*\)\s*=>',
            content
        ))

        # Compter les classes ES6
        complexity['classes'] = len(re.findall(
            r'class\s+\w+',
            content
        ))

    # Calculer la complexité cyclomatique (approx)
    decision_points = len(re.findall(
        r'\b(if|else|for|while|switch|case|\?|&&|\|\|)\b',
        content
    ))
    complexity['cyclomatic_complexity'] = decision_points + 1

    return complexity
```

### 3.5 Analyse du Potentiel de Compression

```python
def analyze_compression_potential(content, file_type):
    """
    Analyse combien de compression est possible
    """
    metadata = {
        'can_remove_comments': True,
        'can_remove_whitespace': True,
        'can_minify_variables': False,
        'mergeable_with': [],
        'estimated_compression_ratio': 0.0
    }

    # Calculer les espaces blancs
    whitespace_count = len(re.findall(r'\s+', content))
    whitespace_bytes = sum(len(m.group()) for m in re.finditer(r'\s+', content))

    # Calculer les commentaires
    comment_bytes = 0
    if file_type in ['php', 'eyecode']:
        # Commentaires PHP: //, /* */, #
        comments = re.findall(r'//[^\n]*|/\*.*?\*/|#[^\n]*', content, re.DOTALL)
        comment_bytes = sum(len(c) for c in comments)
    elif file_type == 'js':
        # Commentaires JS: //, /* */
        comments = re.findall(r'//[^\n]*|/\*.*?\*/', content, re.DOTALL)
        comment_bytes = sum(len(c) for c in comments)

    total_bytes = len(content.encode('utf-8'))
    removable_bytes = whitespace_bytes + comment_bytes

    metadata['estimated_compression_ratio'] = (
        (total_bytes - removable_bytes) / total_bytes
        if total_bytes > 0 else 1.0
    )

    # Vérifier si on peut minifier les variables (prudent pour PHP/eyecode)
    metadata['can_minify_variables'] = (file_type == 'js')

    return metadata
```

### 3.6 Générateur de Manifest

```python
def generate_manifest(file_list, config):
    """
    Génère le fichier manifest JSON
    """
    manifest = {
        'version': '2.0.0',
        'timestamp': datetime.now().isoformat(),
        'config': {
            'project_root': config['project_root'],
            'output_dir': config['output_dir'],
            'exclude_patterns': config['exclude_patterns'],
            'compression_level': config.get('compression_level', 7)
        },
        'stats': calculate_global_stats(file_list),
        'files': file_list,
        'merge_groups': identify_merge_groups(file_list)
    }

    # Écrire le manifest
    with open('sbmerge_manifest.json', 'w') as f:
        json.dump(manifest, f, indent=2)

    return manifest

def calculate_global_stats(file_list):
    """
    Calcule les statistiques globales
    """
    total_size = sum(f['size'] for f in file_list)
    estimated_compressed = sum(
        f['size'] * f['compression_metadata']['estimated_compression_ratio']
        for f in file_list
    )

    return {
        'total_files': len(file_list),
        'total_size_bytes': total_size,
        'estimated_compressed_size': int(estimated_compressed),
        'estimated_savings_percent': (
            (total_size - estimated_compressed) / total_size * 100
            if total_size > 0 else 0
        )
    }
```

---

## 4. Pass 2: Compression Détaillée

### 4.1 Orchestrateur de Compression

```python
def compress_all(manifest):
    """
    Orchestre la compression de tous les fichiers
    """
    output_dir = manifest['config']['output_dir']
    ensure_directory_exists(output_dir)

    # Créer des backups
    if config['pass2']['output']['create_backups']:
        create_backups(manifest['files'])

    results = []

    # Traiter chaque fichier
    for file_info in manifest['files']:
        try:
            result = compress_file(file_info, manifest['config'])
            results.append(result)
            log_compression_result(result)
        except Exception as e:
            log_error(f"Erreur compression {file_info['path']}: {e}")
            results.append({
                'file': file_info['path'],
                'status': 'failed',
                'error': str(e)
            })

    # Traiter les groupes de fusion
    for merge_group in manifest.get('merge_groups', []):
        try:
            result = merge_files(merge_group, manifest['config'])
            results.append(result)
        except Exception as e:
            log_error(f"Erreur fusion groupe {merge_group['group_id']}: {e}")

    # Générer le rapport final
    generate_compression_report(results, manifest)

    return results
```

### 4.2 Compresseur PHP

```python
def compress_php(filepath, config):
    """
    Compresse un fichier PHP
    """
    content = read_file(filepath)
    original_size = len(content.encode('utf-8'))

    # Étape 1: Supprimer les commentaires
    if config['pass2']['compression']['php']['remove_comments']:
        content = remove_php_comments(content)

    # Étape 2: Supprimer les espaces blancs
    if config['pass2']['compression']['php']['remove_whitespace']:
        content = remove_php_whitespace(content)

    # Étape 3: Optimisations supplémentaires
    content = optimize_php_code(content)

    compressed_size = len(content.encode('utf-8'))

    # Générer le fichier de sortie
    output_path = generate_output_path(filepath, config)
    write_file(output_path, content)

    return {
        'file': filepath,
        'output': output_path,
        'original_size': original_size,
        'compressed_size': compressed_size,
        'compression_ratio': compressed_size / original_size,
        'savings_percent': (original_size - compressed_size) / original_size * 100
    }

def remove_php_comments(content):
    """
    Supprime les commentaires PHP tout en préservant le code
    """
    # Supprimer les commentaires multilignes /* */
    content = re.sub(r'/\*.*?\*/', '', content, flags=re.DOTALL)

    # Supprimer les commentaires de ligne //
    # Attention: ne pas supprimer dans les strings
    lines = content.split('\n')
    processed_lines = []

    in_string = False
    string_char = None

    for line in lines:
        new_line = []
        i = 0
        while i < len(line):
            char = line[i]

            # Gérer les strings
            if char in ['"', "'"] and (i == 0 or line[i-1] != '\\'):
                if not in_string:
                    in_string = True
                    string_char = char
                elif char == string_char:
                    in_string = False
                    string_char = None

            # Détecter le commentaire //
            if not in_string and char == '/' and i+1 < len(line) and line[i+1] == '/':
                break  # Ignorer le reste de la ligne

            new_line.append(char)
            i += 1

        processed_lines.append(''.join(new_line))

    return '\n'.join(processed_lines)

def remove_php_whitespace(content):
    """
    Supprime les espaces blancs inutiles
    """
    # Supprimer les espaces multiples
    content = re.sub(r'[ \t]+', ' ', content)

    # Supprimer les lignes vides
    content = re.sub(r'\n\s*\n', '\n', content)

    # Supprimer les espaces autour des opérateurs (prudemment)
    operators = [r'\+', r'-', r'\*', r'/', r'=', r'==', r'===',
                 r'!=', r'!==', r'<', r'>', r'<=', r'>=']

    for op in operators:
        content = re.sub(rf'\s*{op}\s*', op.replace('\\', ''), content)

    return content

def optimize_php_code(content):
    """
    Optimisations supplémentaires du code PHP
    """
    # Remplacer les tags PHP longs par courts (si configuré)
    # content = content.replace('<?php', '<?')

    # Supprimer les ?> de fin de fichier PHP-only
    if content.strip().endswith('?>'):
        content = content.rsplit('?>', 1)[0].rstrip()

    return content
```

### 4.3 Compresseur JavaScript

```python
def compress_js(filepath, config):
    """
    Compresse un fichier JavaScript en utilisant Closure Compiler
    """
    original_size = get_file_size(filepath)

    # Utiliser Closure Compiler si disponible
    if config['pass2']['compression']['js']['use_closure_compiler']:
        output_path = generate_output_path(filepath, config)

        # Construire la commande Closure Compiler
        closure_jar = 'docs/closure-compiler/compiler.jar'
        compilation_level = config['pass2']['compression']['js']['compilation_level']

        cmd = [
            'java', '-jar', closure_jar,
            '--js', filepath,
            '--js_output_file', output_path,
            '--compilation_level', compilation_level
        ]

        # Générer source maps si demandé
        if config['pass2']['compression']['js']['generate_source_maps']:
            map_file = output_path + '.map'
            cmd.extend([
                '--create_source_map', map_file,
                '--source_map_format', 'V3'
            ])

        # Exécuter
        subprocess.run(cmd, check=True)

        compressed_size = get_file_size(output_path)

    else:
        # Compression basique sans Closure Compiler
        content = read_file(filepath)
        content = remove_js_comments(content)
        content = remove_js_whitespace(content)

        output_path = generate_output_path(filepath, config)
        write_file(output_path, content)
        compressed_size = len(content.encode('utf-8'))

    return {
        'file': filepath,
        'output': output_path,
        'original_size': original_size,
        'compressed_size': compressed_size,
        'compression_ratio': compressed_size / original_size,
        'savings_percent': (original_size - compressed_size) / original_size * 100
    }

def remove_js_comments(content):
    """
    Supprime les commentaires JavaScript
    """
    # Supprimer /* */
    content = re.sub(r'/\*.*?\*/', '', content, flags=re.DOTALL)

    # Supprimer //
    lines = content.split('\n')
    processed_lines = []

    for line in lines:
        # Chercher // hors des strings
        in_string = False
        string_char = None
        new_line = []

        for i, char in enumerate(line):
            if char in ['"', "'", '`'] and (i == 0 or line[i-1] != '\\'):
                if not in_string:
                    in_string = True
                    string_char = char
                elif char == string_char:
                    in_string = False

            if not in_string and char == '/' and i+1 < len(line) and line[i+1] == '/':
                break

            new_line.append(char)

        processed_lines.append(''.join(new_line))

    return '\n'.join(processed_lines)

def remove_js_whitespace(content):
    """
    Supprime les espaces blancs JavaScript
    """
    # Supprimer espaces multiples
    content = re.sub(r'[ \t]+', ' ', content)

    # Supprimer lignes vides
    content = re.sub(r'\n\s*\n', '\n', content)

    # Supprimer espaces autour de {, }, [, ], (, ), ;, :, ,
    chars = [r'\{', r'\}', r'\[', r'\]', r'\(', r'\)', r';', r':', r',']
    for char in chars:
        content = re.sub(rf'\s*{char}\s*', char.replace('\\', ''), content)

    return content
```

### 4.4 Compresseur eyecode

```python
def compress_eyecode(filepath, config):
    """
    Compresse un fichier .eyecode (hybride PHP)
    """
    content = read_file(filepath)
    original_size = len(content.encode('utf-8'))

    # Les fichiers eyecode sont essentiellement du PHP
    # Appliquer les mêmes règles que PHP

    if config['pass2']['compression']['eyecode']['remove_comments']:
        content = remove_php_comments(content)

    if config['pass2']['compression']['eyecode']['remove_whitespace']:
        content = remove_php_whitespace(content)

    # Préserver les tags PHP si configuré
    if config['pass2']['compression']['eyecode']['preserve_php_tags']:
        # S'assurer que les tags <?php sont présents
        if not content.strip().startswith('<?'):
            content = '<?php\n' + content

    compressed_size = len(content.encode('utf-8'))
    output_path = generate_output_path(filepath, config)
    write_file(output_path, content)

    return {
        'file': filepath,
        'output': output_path,
        'original_size': original_size,
        'compressed_size': compressed_size,
        'compression_ratio': compressed_size / original_size,
        'savings_percent': (original_size - compressed_size) / original_size * 100
    }
```

### 4.5 Fusion de Fichiers

```python
def merge_files(merge_group, config):
    """
    Fusionne plusieurs fichiers en un seul
    """
    group_id = merge_group['group_id']
    output_file = merge_group['output_file']
    source_files = merge_group['source_files']
    strategy = merge_group['merge_strategy']

    log_info(f"Fusion groupe {group_id}: {len(source_files)} fichiers")

    merged_content = []
    total_original_size = 0

    for source_file in source_files:
        content = read_file(source_file)
        total_original_size += len(content.encode('utf-8'))

        if strategy == 'concat':
            # Simple concaténation
            merged_content.append(content)

        elif strategy == 'smart_merge':
            # Fusion intelligente (supprimer tags PHP dupliqués, etc.)
            content = prepare_for_smart_merge(content)
            merged_content.append(content)

        elif strategy == 'module_wrap':
            # Wrapper chaque fichier comme un module
            module_name = get_module_name(source_file)
            wrapped = wrap_as_module(content, module_name)
            merged_content.append(wrapped)

    # Joindre tout le contenu
    final_content = '\n'.join(merged_content)

    # Compresser le résultat fusionné
    if output_file.endswith('.min.php') or output_file.endswith('.min.eyecode'):
        final_content = remove_php_comments(final_content)
        final_content = remove_php_whitespace(final_content)
    elif output_file.endswith('.min.js'):
        final_content = remove_js_comments(final_content)
        final_content = remove_js_whitespace(final_content)

    # Écrire le fichier fusionné
    ensure_directory_exists(os.path.dirname(output_file))
    write_file(output_file, final_content)

    compressed_size = len(final_content.encode('utf-8'))

    return {
        'group': group_id,
        'output': output_file,
        'source_count': len(source_files),
        'original_size': total_original_size,
        'merged_size': compressed_size,
        'compression_ratio': compressed_size / total_original_size,
        'savings_percent': (total_original_size - compressed_size) / total_original_size * 100
    }

def prepare_for_smart_merge(content):
    """
    Prépare un fichier pour une fusion intelligente
    """
    # Supprimer le tag PHP d'ouverture (sauf le premier)
    content = content.strip()
    if content.startswith('<?php'):
        content = content[5:].lstrip()
    elif content.startswith('<?'):
        content = content[2:].lstrip()

    # Supprimer le tag de fermeture
    if content.endswith('?>'):
        content = content[:-2].rstrip()

    return content

def wrap_as_module(content, module_name):
    """
    Encapsule le contenu comme un module
    """
    return f"""
// Module: {module_name}
(function() {{
    {content}
}})();
"""
```

### 4.6 Génération de Source Maps

```python
def generate_source_map(original_file, compressed_file):
    """
    Génère une source map pour le debugging
    """
    source_map = {
        'version': 3,
        'file': os.path.basename(compressed_file),
        'sourceRoot': '',
        'sources': [original_file],
        'names': [],
        'mappings': generate_mappings(original_file, compressed_file)
    }

    map_file = compressed_file + '.map'
    with open(map_file, 'w') as f:
        json.dump(source_map, f)

    # Ajouter la référence dans le fichier compressé
    with open(compressed_file, 'a') as f:
        f.write(f'\n//# sourceMappingURL={os.path.basename(map_file)}')

    return map_file

def generate_mappings(original_file, compressed_file):
    """
    Génère les mappings ligne par ligne (simplifié)
    """
    # Version simplifiée: mapper ligne à ligne
    # Une vraie source map serait plus complexe
    original_lines = read_file(original_file).split('\n')
    compressed_lines = read_file(compressed_file).split('\n')

    mappings = []
    # Format VLQ pour source maps
    # Pour simplifier, on retourne une chaîne vide
    # Une vraie implémentation utiliserait la bibliothèque source-map
    return ''
```

---

## 5. Modules et Composants

### 5.1 Structure des Modules

```
sbmerge_v2/
├── smcompress.ss              # Script principal CLI
├── lib/
│   ├── analyzer.py            # Module d'analyse (Pass 1)
│   ├── compressor.py          # Module de compression (Pass 2)
│   ├── scanner.py             # Scanner de fichiers
│   ├── manifest.py            # Gestion du manifest
│   ├── minifiers/
│   │   ├── php_minifier.py    # Minifier PHP
│   │   ├── js_minifier.py     # Minifier JS
│   │   └── eyecode_minifier.py # Minifier eyecode
│   ├── utils/
│   │   ├── file_io.py         # I/O fichiers
│   │   ├── logger.py          # Système de logging
│   │   ├── hash_utils.py      # Calcul de hash
│   │   └── path_utils.py      # Utilitaires de chemin
│   └── config.py              # Gestion de configuration
├── tests/
│   ├── test_analyzer.py
│   ├── test_compressor.py
│   ├── test_minifiers.py
│   └── fixtures/              # Fichiers de test
└── docs/
    ├── sbmerge_v2_integration_plan.md
    └── sbmerge_v2_detailed_implementation.md
```

### 5.2 Module Scanner (scanner.py)

```python
#!/usr/bin/env python3
"""
Module de scan de fichiers pour sbmerge_v2
"""

import os
import re
from pathlib import Path
from typing import List, Dict, Set
from .utils.path_utils import normalize_path, matches_pattern

class FileScanner:
    """Scanner de fichiers avec support des patterns d'exclusion"""

    def __init__(self, config: Dict):
        self.config = config
        self.exclude_patterns = config.get('exclude_patterns', [])
        self.include_patterns = config.get('file_patterns', {}).get('include', [])
        self.exclude_files = config.get('file_patterns', {}).get('exclude', [])

    def scan(self, root_dir: str) -> List[str]:
        """
        Scanne récursivement un répertoire

        Args:
            root_dir: Répertoire racine à scanner

        Returns:
            Liste des chemins de fichiers trouvés
        """
        found_files = []
        root_path = Path(root_dir).resolve()

        for dirpath, dirnames, filenames in os.walk(root_path):
            # Filtrer les répertoires exclus
            dirnames[:] = [
                d for d in dirnames
                if not self._should_exclude_dir(os.path.join(dirpath, d))
            ]

            # Traiter les fichiers
            for filename in filenames:
                filepath = os.path.join(dirpath, filename)

                if self._should_include_file(filepath):
                    found_files.append(filepath)

        return found_files

    def _should_exclude_dir(self, dirpath: str) -> bool:
        """Vérifie si un répertoire doit être exclu"""
        dir_name = os.path.basename(dirpath)

        # Toujours exclure .git
        if dir_name == '.git':
            return True

        # Vérifier les patterns d'exclusion
        for pattern in self.exclude_patterns:
            if matches_pattern(dirpath, pattern):
                return True

        return False

    def _should_include_file(self, filepath: str) -> bool:
        """Vérifie si un fichier doit être inclus"""
        filename = os.path.basename(filepath)

        # Vérifier si déjà minifié
        if any(filename.endswith(ext) for ext in ['.min.js', '.min.php', '.min.eyecode']):
            return False

        # Vérifier les patterns d'exclusion de fichiers
        for pattern in self.exclude_files:
            if matches_pattern(filename, pattern):
                return False

        # Vérifier les patterns d'inclusion
        for pattern in self.include_patterns:
            if matches_pattern(filename, pattern):
                return True

        return False
```

### 5.3 Module Analyzer (analyzer.py)

```python
#!/usr/bin/env python3
"""
Module d'analyse de fichiers pour sbmerge_v2
"""

import os
import hashlib
import re
from datetime import datetime
from typing import Dict, List
from .utils.file_io import read_file

class FileAnalyzer:
    """Analyseur de fichiers source"""

    def __init__(self, config: Dict):
        self.config = config

    def analyze_file(self, filepath: str) -> Dict:
        """
        Analyse complète d'un fichier

        Args:
            filepath: Chemin du fichier à analyser

        Returns:
            Dictionnaire de métadonnées
        """
        file_type = self._detect_file_type(filepath)
        content = read_file(filepath)

        metadata = {
            'path': filepath,
            'type': file_type,
            'size': os.path.getsize(filepath),
            'hash': self._calculate_hash(filepath),
            'modified_time': datetime.fromtimestamp(
                os.path.getmtime(filepath)
            ).isoformat(),
            'dependencies': self._extract_dependencies(content, file_type),
            'includes': self._extract_includes(content, file_type),
            'complexity': self._calculate_complexity(content, file_type),
            'compression_metadata': self._analyze_compression_potential(
                content, file_type
            )
        }

        return metadata

    def _detect_file_type(self, filepath: str) -> str:
        """Détecte le type de fichier"""
        ext = os.path.splitext(filepath)[1].lower()

        if ext == '.php':
            return 'php'
        elif ext == '.js':
            return 'js'
        elif ext == '.eyecode':
            return 'eyecode'
        else:
            return 'unknown'

    def _calculate_hash(self, filepath: str, algorithm: str = 'sha256') -> str:
        """Calcule le hash d'un fichier"""
        hasher = hashlib.new(algorithm)

        with open(filepath, 'rb') as f:
            for chunk in iter(lambda: f.read(4096), b''):
                hasher.update(chunk)

        return f"{algorithm}:{hasher.hexdigest()}"

    def _extract_dependencies(self, content: str, file_type: str) -> List[str]:
        """Extrait les dépendances du fichier"""
        dependencies = []

        if file_type in ['php', 'eyecode']:
            patterns = [
                r'require_once\s*\(?[\'"]([^\'"]+)[\'"]',
                r'require\s*\(?[\'"]([^\'"]+)[\'"]',
                r'include_once\s*\(?[\'"]([^\'"]+)[\'"]',
                r'include\s*\(?[\'"]([^\'"]+)[\'"]',
            ]
        elif file_type == 'js':
            patterns = [
                r'import\s+.*\s+from\s+[\'"]([^\'"]+)[\'"]',
                r'require\s*\([\'"]([^\'"]+)[\'"]\)',
            ]
        else:
            return []

        for pattern in patterns:
            matches = re.findall(pattern, content)
            dependencies.extend(matches)

        return list(set(dependencies))

    def _extract_includes(self, content: str, file_type: str) -> List[str]:
        """Extrait les includes/imports"""
        # Similaire à _extract_dependencies mais peut inclure d'autres patterns
        return self._extract_dependencies(content, file_type)

    def _calculate_complexity(self, content: str, file_type: str) -> Dict:
        """Calcule les métriques de complexité"""
        lines = content.split('\n')

        complexity = {
            'lines': len(lines),
            'lines_of_code': 0,
            'comment_lines': 0,
            'blank_lines': 0,
            'functions': 0,
            'classes': 0,
            'cyclomatic_complexity': 0
        }

        # Compter les lignes de code, commentaires, vides
        for line in lines:
            stripped = line.strip()
            if not stripped:
                complexity['blank_lines'] += 1
            elif stripped.startswith('//') or stripped.startswith('#'):
                complexity['comment_lines'] += 1
            else:
                complexity['lines_of_code'] += 1

        # Compter fonctions et classes
        if file_type in ['php', 'eyecode']:
            complexity['functions'] = len(re.findall(
                r'function\s+\w+\s*\(', content
            ))
            complexity['classes'] = len(re.findall(
                r'class\s+\w+', content
            ))
        elif file_type == 'js':
            complexity['functions'] = len(re.findall(
                r'function\s+\w*\s*\(', content
            ))
            complexity['classes'] = len(re.findall(
                r'class\s+\w+', content
            ))

        # Complexité cyclomatique (approximation)
        decision_points = len(re.findall(
            r'\b(if|else|for|while|switch|case|\?|&&|\|\|)\b',
            content
        ))
        complexity['cyclomatic_complexity'] = decision_points + 1

        return complexity

    def _analyze_compression_potential(self, content: str, file_type: str) -> Dict:
        """Analyse le potentiel de compression"""
        total_bytes = len(content.encode('utf-8'))

        # Calculer les espaces blancs
        whitespace = re.findall(r'\s+', content)
        whitespace_bytes = sum(len(w.encode('utf-8')) for w in whitespace)

        # Calculer les commentaires
        comment_bytes = 0
        if file_type in ['php', 'eyecode']:
            comments = re.findall(
                r'//[^\n]*|/\*.*?\*/|#[^\n]*',
                content,
                re.DOTALL
            )
            comment_bytes = sum(len(c.encode('utf-8')) for c in comments)
        elif file_type == 'js':
            comments = re.findall(
                r'//[^\n]*|/\*.*?\*/',
                content,
                re.DOTALL
            )
            comment_bytes = sum(len(c.encode('utf-8')) for c in comments)

        removable_bytes = whitespace_bytes + comment_bytes
        estimated_size = total_bytes - removable_bytes

        return {
            'can_remove_comments': True,
            'can_remove_whitespace': True,
            'can_minify_variables': (file_type == 'js'),
            'mergeable_with': [],
            'estimated_compression_ratio': (
                estimated_size / total_bytes if total_bytes > 0 else 1.0
            ),
            'estimated_savings_bytes': removable_bytes
        }
```

---

## 6. Algorithmes

### 6.1 Algorithme de Détection de Groupes de Fusion

```python
def identify_merge_groups(file_list: List[Dict]) -> List[Dict]:
    """
    Identifie les groupes de fichiers qui peuvent être fusionnés

    Critères de fusion:
    - Même type de fichier
    - Même répertoire parent ou répertoires voisins
    - Dépendances compatibles
    - Utilisés ensemble fréquemment
    """
    merge_groups = []

    # Grouper par type
    by_type = {}
    for file_info in file_list:
        file_type = file_info['type']
        if file_type not in by_type:
            by_type[file_type] = []
        by_type[file_type].append(file_info)

    # Pour chaque type, identifier les groupes
    for file_type, files in by_type.items():
        # Grouper par répertoire
        by_dir = {}
        for file_info in files:
            dir_path = os.path.dirname(file_info['path'])
            if dir_path not in by_dir:
                by_dir[dir_path] = []
            by_dir[dir_path].append(file_info)

        # Créer des groupes pour les répertoires avec plusieurs fichiers
        for dir_path, dir_files in by_dir.items():
            if len(dir_files) >= 2:  # Au moins 2 fichiers pour fusionner
                # Vérifier les dépendances
                if can_merge_safely(dir_files):
                    group_id = f"{file_type}_{os.path.basename(dir_path)}"
                    output_file = generate_merge_output_path(
                        dir_path, file_type, group_id
                    )

                    merge_groups.append({
                        'group_id': group_id,
                        'output_file': output_file,
                        'source_files': [f['path'] for f in dir_files],
                        'merge_strategy': determine_merge_strategy(
                            dir_files, file_type
                        )
                    })

    return merge_groups

def can_merge_safely(files: List[Dict]) -> bool:
    """
    Vérifie si des fichiers peuvent être fusionnés sans casser les dépendances
    """
    # Vérifier les dépendances circulaires
    file_paths = {f['path'] for f in files}

    for file_info in files:
        for dep in file_info['dependencies']:
            # Si une dépendance est en dehors du groupe, prudence
            if not any(dep in path for path in file_paths):
                # Dépendance externe - peut toujours fusionner
                # mais il faut s'assurer que l'ordre est correct
                pass

    # Pour l'instant, autoriser la fusion
    # Une analyse plus poussée vérifierait l'ordre d'exécution
    return True

def determine_merge_strategy(files: List[Dict], file_type: str) -> str:
    """
    Détermine la meilleure stratégie de fusion
    """
    if file_type == 'js':
        # Pour JS, utiliser module_wrap pour éviter les conflits
        return 'module_wrap'
    elif file_type in ['php', 'eyecode']:
        # Pour PHP, smart_merge pour gérer les tags
        return 'smart_merge'
    else:
        # Par défaut, simple concaténation
        return 'concat'
```

### 6.2 Algorithme de Compression Incrémentale

```python
def incremental_compress(manifest: Dict, previous_manifest: Dict = None) -> List[Dict]:
    """
    Compression incrémentale: ne recompresser que les fichiers modifiés

    Args:
        manifest: Manifest actuel
        previous_manifest: Manifest précédent (si disponible)

    Returns:
        Liste des fichiers à recompresser
    """
    if not previous_manifest:
        # Première compression: tout compresser
        return manifest['files']

    files_to_compress = []

    # Créer un index des fichiers précédents par path
    prev_files = {
        f['path']: f
        for f in previous_manifest.get('files', [])
    }

    for file_info in manifest['files']:
        filepath = file_info['path']

        # Nouveau fichier
        if filepath not in prev_files:
            files_to_compress.append(file_info)
            continue

        prev_file = prev_files[filepath]

        # Vérifier si le fichier a changé (via hash)
        if file_info['hash'] != prev_file['hash']:
            files_to_compress.append(file_info)
            continue

        # Fichier inchangé: vérifier si la sortie existe
        output_path = generate_output_path(filepath, manifest['config'])
        if not os.path.exists(output_path):
            files_to_compress.append(file_info)

    return files_to_compress
```

### 6.3 Algorithme de Rollback

```python
def rollback_compression(backup_dir: str, target_dir: str):
    """
    Restaure les fichiers originaux depuis les backups

    Args:
        backup_dir: Répertoire contenant les backups
        target_dir: Répertoire cible où restaurer
    """
    if not os.path.exists(backup_dir):
        raise ValueError(f"Backup directory not found: {backup_dir}")

    # Lister tous les backups
    for root, dirs, files in os.walk(backup_dir):
        for filename in files:
            backup_path = os.path.join(root, filename)

            # Calculer le chemin de destination
            rel_path = os.path.relpath(backup_path, backup_dir)
            dest_path = os.path.join(target_dir, rel_path)

            # Créer les répertoires si nécessaire
            os.makedirs(os.path.dirname(dest_path), exist_ok=True)

            # Restaurer le fichier
            shutil.copy2(backup_path, dest_path)
            log_info(f"Restored: {dest_path}")

    log_info(f"Rollback complete: {len(files)} files restored")
```

---

## 7. Gestion des Erreurs

### 7.1 Hiérarchie d'Exceptions

```python
class SbmergeError(Exception):
    """Exception de base pour sbmerge_v2"""
    pass

class ScanError(SbmergeError):
    """Erreur lors du scan de fichiers"""
    pass

class AnalysisError(SbmergeError):
    """Erreur lors de l'analyse"""
    pass

class CompressionError(SbmergeError):
    """Erreur lors de la compression"""
    pass

class ManifestError(SbmergeError):
    """Erreur liée au manifest"""
    pass

class ConfigError(SbmergeError):
    """Erreur de configuration"""
    pass
```

### 7.2 Gestion des Erreurs avec Contexte

```python
class ErrorHandler:
    """Gestionnaire d'erreurs centralisé"""

    def __init__(self, logger):
        self.logger = logger
        self.errors = []
        self.warnings = []

    def handle_error(self, error: Exception, context: Dict, fatal: bool = False):
        """
        Gère une erreur avec contexte

        Args:
            error: L'exception
            context: Contexte (fichier, opération, etc.)
            fatal: Si True, arrête l'exécution
        """
        error_info = {
            'type': type(error).__name__,
            'message': str(error),
            'context': context,
            'timestamp': datetime.now().isoformat(),
            'fatal': fatal
        }

        self.errors.append(error_info)

        # Logger
        log_message = (
            f"Error in {context.get('operation', 'unknown')}: "
            f"{error_info['message']}"
        )

        if context.get('file'):
            log_message += f" (file: {context['file']})"

        if fatal:
            self.logger.error(log_message)
            raise error
        else:
            self.logger.warning(log_message)

    def add_warning(self, message: str, context: Dict):
        """Ajoute un avertissement"""
        warning_info = {
            'message': message,
            'context': context,
            'timestamp': datetime.now().isoformat()
        }

        self.warnings.append(warning_info)
        self.logger.warning(f"Warning: {message}")

    def get_error_report(self) -> Dict:
        """Génère un rapport d'erreurs"""
        return {
            'total_errors': len(self.errors),
            'total_warnings': len(self.warnings),
            'fatal_errors': len([e for e in self.errors if e['fatal']]),
            'errors': self.errors,
            'warnings': self.warnings
        }
```

### 7.3 Validation et Sanitization

```python
def validate_config(config: Dict) -> bool:
    """
    Valide la configuration

    Raises:
        ConfigError: Si la configuration est invalide
    """
    required_keys = ['project_root', 'output_dir']

    for key in required_keys:
        if key not in config:
            raise ConfigError(f"Missing required config key: {key}")

    # Vérifier que project_root existe
    if not os.path.exists(config['project_root']):
        raise ConfigError(f"Project root does not exist: {config['project_root']}")

    # Vérifier les permissions
    if not os.access(config['project_root'], os.R_OK):
        raise ConfigError(f"No read permission: {config['project_root']}")

    # Valider compression_level
    if 'compression_level' in config:
        level = config['compression_level']
        if not isinstance(level, int) or level < 0 or level > 9:
            raise ConfigError(f"Invalid compression_level: {level} (must be 0-9)")

    return True

def sanitize_path(path: str) -> str:
    """
    Nettoie et valide un chemin de fichier

    Raises:
        ValueError: Si le chemin contient des caractères dangereux
    """
    # Normaliser le chemin
    path = os.path.normpath(path)

    # Vérifier les tentatives de traversée
    if '..' in path:
        raise ValueError(f"Path traversal detected: {path}")

    # Vérifier les caractères dangereux
    dangerous_chars = ['|', '&', ';', '$', '`']
    for char in dangerous_chars:
        if char in path:
            raise ValueError(f"Dangerous character in path: {char}")

    return path
```

---

## 8. Tests Détaillés

### 8.1 Tests Unitaires

```python
# tests/test_analyzer.py

import unittest
from lib.analyzer import FileAnalyzer

class TestFileAnalyzer(unittest.TestCase):

    def setUp(self):
        self.config = {
            'hash_algorithm': 'sha256'
        }
        self.analyzer = FileAnalyzer(self.config)

    def test_detect_file_type(self):
        """Test de détection de type de fichier"""
        self.assertEqual(
            self.analyzer._detect_file_type('test.php'),
            'php'
        )
        self.assertEqual(
            self.analyzer._detect_file_type('test.js'),
            'js'
        )
        self.assertEqual(
            self.analyzer._detect_file_type('test.eyecode'),
            'eyecode'
        )

    def test_extract_php_dependencies(self):
        """Test d'extraction de dépendances PHP"""
        content = """<?php
        require_once 'lib/file1.php';
        include 'lib/file2.php';
        ?>"""

        deps = self.analyzer._extract_dependencies(content, 'php')

        self.assertIn('lib/file1.php', deps)
        self.assertIn('lib/file2.php', deps)

    def test_extract_js_dependencies(self):
        """Test d'extraction de dépendances JS"""
        content = """
        import { foo } from './module1.js';
        const bar = require('./module2.js');
        """

        deps = self.analyzer._extract_dependencies(content, 'js')

        self.assertIn('./module1.js', deps)
        self.assertIn('./module2.js', deps)

    def test_calculate_complexity(self):
        """Test de calcul de complexité"""
        content = """<?php
        function test1() {
            if ($x > 0) {
                return true;
            }
            return false;
        }

        function test2() {
            for ($i = 0; $i < 10; $i++) {
                echo $i;
            }
        }
        ?>"""

        complexity = self.analyzer._calculate_complexity(content, 'php')

        self.assertEqual(complexity['functions'], 2)
        self.assertGreater(complexity['cyclomatic_complexity'], 1)
```

### 8.2 Tests d'Intégration

```python
# tests/test_integration.py

import unittest
import os
import tempfile
from lib.analyzer import FileAnalyzer
from lib.compressor import FileCompressor
from lib.manifest import ManifestBuilder

class TestFullPipeline(unittest.TestCase):

    def setUp(self):
        """Créer un environnement de test temporaire"""
        self.test_dir = tempfile.mkdtemp()

        # Créer des fichiers de test
        self.create_test_files()

        self.config = {
            'project_root': self.test_dir,
            'output_dir': os.path.join(self.test_dir, 'build'),
            'exclude_patterns': []
        }

    def create_test_files(self):
        """Créer des fichiers PHP/JS de test"""
        # Fichier PHP
        php_file = os.path.join(self.test_dir, 'test.php')
        with open(php_file, 'w') as f:
            f.write("""<?php
            // Ceci est un commentaire
            function hello() {
                echo "Hello World";
            }
            ?>""")

        # Fichier JS
        js_file = os.path.join(self.test_dir, 'test.js')
        with open(js_file, 'w') as f:
            f.write("""
            // Commentaire JS
            function greet(name) {
                console.log('Hello ' + name);
            }
            """)

    def test_full_compression_pipeline(self):
        """Test du pipeline complet Pass 1 + Pass 2"""
        # Pass 1: Analyser
        analyzer = FileAnalyzer(self.config)
        scanner = FileScanner(self.config)

        files = scanner.scan(self.test_dir)
        analyzed = [analyzer.analyze_file(f) for f in files]

        # Créer le manifest
        manifest_builder = ManifestBuilder(self.config)
        manifest = manifest_builder.build(analyzed)

        self.assertGreater(len(manifest['files']), 0)

        # Pass 2: Compresser
        compressor = FileCompressor(self.config)
        results = compressor.compress_all(manifest)

        # Vérifier que les fichiers compressés existent
        for result in results:
            if result['status'] == 'success':
                self.assertTrue(os.path.exists(result['output']))

                # Vérifier que la taille a diminué
                self.assertLess(
                    result['compressed_size'],
                    result['original_size']
                )

    def tearDown(self):
        """Nettoyer l'environnement de test"""
        import shutil
        shutil.rmtree(self.test_dir)
```

### 8.3 Tests de Performance

```python
# tests/test_performance.py

import unittest
import time
from lib.compressor import compress_php

class TestPerformance(unittest.TestCase):

    def test_compression_speed(self):
        """Test de vitesse de compression"""
        # Générer un gros fichier PHP
        large_content = "<?php\n"
        for i in range(10000):
            large_content += f"// Line {i}\n"
            large_content += f"function func{i}() {{ return {i}; }}\n"
        large_content += "?>"

        # Mesurer le temps
        start = time.time()
        compressed = compress_php_content(large_content)
        duration = time.time() - start

        # Devrait compresser en moins de 1 seconde
        self.assertLess(duration, 1.0)

        # Vérifier la réduction de taille
        ratio = len(compressed) / len(large_content)
        self.assertLess(ratio, 0.7)  # Au moins 30% de réduction
```

---

## 9. Optimisations

### 9.1 Parallélisation

```python
from concurrent.futures import ThreadPoolExecutor, ProcessPoolExecutor
from multiprocessing import cpu_count

def parallel_compress(file_list: List[Dict], config: Dict) -> List[Dict]:
    """
    Compression parallèle utilisant plusieurs processus
    """
    max_workers = min(cpu_count(), len(file_list))
    results = []

    with ProcessPoolExecutor(max_workers=max_workers) as executor:
        # Soumettre toutes les tâches
        futures = {
            executor.submit(compress_file, file_info, config): file_info
            for file_info in file_list
        }

        # Collecter les résultats
        for future in concurrent.futures.as_completed(futures):
            file_info = futures[future]
            try:
                result = future.result()
                results.append(result)
            except Exception as e:
                logger.error(f"Error compressing {file_info['path']}: {e}")
                results.append({
                    'file': file_info['path'],
                    'status': 'failed',
                    'error': str(e)
                })

    return results
```

### 9.2 Cache de Résultats

```python
import pickle
from functools import lru_cache

class CompressionCache:
    """Cache des résultats de compression"""

    def __init__(self, cache_file: str = '.sbmerge_cache.pkl'):
        self.cache_file = cache_file
        self.cache = self._load_cache()

    def _load_cache(self) -> Dict:
        """Charge le cache depuis le disque"""
        if os.path.exists(self.cache_file):
            try:
                with open(self.cache_file, 'rb') as f:
                    return pickle.load(f)
            except Exception:
                return {}
        return {}

    def _save_cache(self):
        """Sauvegarde le cache sur le disque"""
        with open(self.cache_file, 'wb') as f:
            pickle.dump(self.cache, f)

    def get(self, file_hash: str) -> Optional[Dict]:
        """Récupère un résultat depuis le cache"""
        return self.cache.get(file_hash)

    def set(self, file_hash: str, result: Dict):
        """Stocke un résultat dans le cache"""
        self.cache[file_hash] = result
        self._save_cache()

    def invalidate(self, file_hash: str):
        """Invalide une entrée du cache"""
        if file_hash in self.cache:
            del self.cache[file_hash]
            self._save_cache()

def compress_with_cache(file_info: Dict, config: Dict, cache: CompressionCache) -> Dict:
    """
    Compresse un fichier en utilisant le cache
    """
    file_hash = file_info['hash']

    # Vérifier le cache
    cached_result = cache.get(file_hash)
    if cached_result:
        # Vérifier que le fichier de sortie existe toujours
        if os.path.exists(cached_result['output']):
            logger.info(f"Using cached result for {file_info['path']}")
            return cached_result

    # Compresser
    result = compress_file(file_info, config)

    # Mettre en cache
    cache.set(file_hash, result)

    return result
```

### 9.3 Optimisation Mémoire

```python
def compress_large_file(filepath: str, config: Dict, chunk_size: int = 8192) -> Dict:
    """
    Compression par chunks pour les gros fichiers
    """
    output_path = generate_output_path(filepath, config)

    original_size = 0
    compressed_size = 0

    with open(filepath, 'r', encoding='utf-8') as infile:
        with open(output_path, 'w', encoding='utf-8') as outfile:
            while True:
                chunk = infile.read(chunk_size)
                if not chunk:
                    break

                original_size += len(chunk.encode('utf-8'))

                # Compresser le chunk
                compressed_chunk = compress_chunk(chunk, config)
                outfile.write(compressed_chunk)

                compressed_size += len(compressed_chunk.encode('utf-8'))

    return {
        'file': filepath,
        'output': output_path,
        'original_size': original_size,
        'compressed_size': compressed_size,
        'compression_ratio': compressed_size / original_size if original_size > 0 else 1.0
    }
```

---

## 10. Déploiement

### 10.1 Script d'Installation

```bash
#!/bin/bash
# install_sbmerge.sh

echo "=== Installation de sbmerge_v2 ==="

# Vérifier Python
if ! command -v python3 &> /dev/null; then
    echo "Erreur: Python 3 requis"
    exit 1
fi

# Vérifier Java (pour Closure Compiler)
if ! command -v java &> /dev/null; then
    echo "Avertissement: Java non trouvé. Closure Compiler ne sera pas disponible."
fi

# Créer les répertoires
mkdir -p build/compressed
mkdir -p build/backups
mkdir -p logs

# Installer les dépendances Python
pip3 install -r requirements.txt

# Rendre le script principal exécutable
chmod +x smcompress.ss

# Créer la configuration par défaut
if [ ! -f .sbmergerc ]; then
    echo "Création de .sbmergerc..."
    cat > .sbmergerc <<'EOF'
{
  "pass1": {
    "scan_directories": ["system/system", "system/apps"],
    "file_patterns": {
      "include": ["*.php", "*.eyecode", "*.js"],
      "exclude": ["*.min.js", "*.min.php"]
    }
  },
  "pass2": {
    "compression": {
      "php": {
        "remove_comments": true,
        "remove_whitespace": true
      },
      "js": {
        "use_closure_compiler": false
      }
    }
  }
}
EOF
fi

echo "Installation terminée!"
echo "Utilisez: ./smcompress.ss --help"
```

### 10.2 Workflow CI/CD

```yaml
# .github/workflows/sbmerge.yml

name: sbmerge Compression

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  compress:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v2

    - name: Set up Python
      uses: actions/setup-python@v2
      with:
        python-version: '3.9'

    - name: Install dependencies
      run: |
        pip install -r requirements.txt

    - name: Run sbmerge Pass 1
      run: |
        ./smcompress.ss --analyze

    - name: Run sbmerge Pass 2
      run: |
        ./smcompress.ss --compress

    - name: Upload compressed files
      uses: actions/upload-artifact@v2
      with:
        name: compressed-files
        path: build/compressed/

    - name: Generate report
      run: |
        python3 -c "import json; manifest = json.load(open('sbmerge_manifest.json')); print(f\"Total savings: {manifest['stats']['estimated_savings_percent']:.2f}%\")"
```

### 10.3 Documentation de Déploiement

```markdown
# Guide de Déploiement sbmerge_v2

## Prérequis

- Python 3.7+
- Java 8+ (optionnel, pour Closure Compiler)
- Bash
- Accès en lecture/écriture au projet oneye

## Installation

1. Cloner le repository ou extraire l'archive sbmerge_v2

2. Exécuter le script d'installation:
   ```bash
   ./install_sbmerge.sh
   ```

3. Vérifier l'installation:
   ```bash
   ./smcompress.ss --help
   ```

## Configuration

Éditer `.sbmergerc` pour personnaliser:
- Répertoires à scanner
- Patterns de fichiers
- Options de compression

## Utilisation en Production

### Première Compression

```bash
# Sauvegarde recommandée
git commit -am "Backup before sbmerge"

# Analyser
./smcompress.ss --analyze

# Vérifier le manifest
cat sbmerge_manifest.json

# Compresser
./smcompress.ss --compress

# Vérifier les résultats
ls -lh build/compressed/
```

### Compression Incrémentale

```bash
# Après modifications de fichiers
./smcompress.ss --full
```

### Rollback

```bash
# En cas de problème
./smcompress.ss --rollback
```

## Monitoring

Surveiller les logs:
```bash
tail -f logs/sbmerge.log
```

## Performance

Pour de meilleures performances:
- Utiliser `--parallel` pour activer le traitement parallèle
- Ajuster `chunk_size` dans la config pour les gros fichiers
- Activer le cache avec `--use-cache`
```

---

## 11. Annexes

### 11.1 Format du Fichier de Log

```
2025-11-23 10:30:15 [INFO] Starting sbmerge_v2 Pass 1
2025-11-23 10:30:16 [INFO] Scanning directory: /home/user/os/system
2025-11-23 10:30:17 [INFO] Found 1247 files to analyze
2025-11-23 10:30:18 [INFO] Analyzing file: system/kernel/kernel.eyecode
2025-11-23 10:30:18 [DEBUG] Detected 5 dependencies in kernel.eyecode
2025-11-23 10:30:19 [INFO] Generating manifest...
2025-11-23 10:30:20 [INFO] Pass 1 complete: sbmerge_manifest.json created
2025-11-23 10:30:20 [INFO] Estimated savings: 42.5%

2025-11-23 10:30:25 [INFO] Starting sbmerge_v2 Pass 2
2025-11-23 10:30:26 [INFO] Loading manifest: sbmerge_manifest.json
2025-11-23 10:30:27 [INFO] Creating backups in: build/backups
2025-11-23 10:30:30 [INFO] Compressing: system/kernel/kernel.eyecode
2025-11-23 10:30:31 [INFO] Saved 45.2% (23KB → 12.6KB)
2025-11-23 10:30:32 [WARNING] Large cyclomatic complexity in file: system/apps/complex.php
2025-11-23 10:35:00 [INFO] Pass 2 complete: 1247 files compressed
2025-11-23 10:35:01 [INFO] Total savings: 6.8MB (43.2%)
```

### 11.2 Checklist de Validation

- [ ] Pass 1 s'exécute sans erreur
- [ ] Manifest JSON généré et valide
- [ ] Toutes les dépendances détectées correctement
- [ ] Pass 2 s'exécute sans erreur
- [ ] Fichiers compressés générés
- [ ] Réduction de taille conforme aux estimations
- [ ] Fichiers originaux backupés
- [ ] Source maps générés (si applicable)
- [ ] oneye démarre avec les fichiers compressés
- [ ] Toutes les applications fonctionnent
- [ ] Pas de dégradation de performance
- [ ] Logs complets et sans erreur fatale

---

**Version** : 2.0.0
**Date** : 2025-11-23
**Auteur** : Claude Code
**Status** : Implémentation Détaillée Complète
