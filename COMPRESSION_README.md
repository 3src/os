# Compression avec Taille Fixe - Proof of Concept

## Description

Scripts robustes pour compresser des fichiers/répertoires en archives de taille fixe et les décompresser en utilisant des **for loops**.

## Fichiers

- `compress_fixed_size.sh` - Script de compression avec découpage en taille fixe
- `decompress_archives.sh` - Script de décompression utilisant un for loop
- `test_compression.sh` - Script de test et démonstration

## Utilisation

### Compression

```bash
./compress_fixed_size.sh <source> <output_prefix> <size_in_MB>
```

**Exemples:**
```bash
# Compresser un répertoire en fichiers de 10 MB
./compress_fixed_size.sh /path/to/dir myarchive 10

# Compresser un fichier en fichiers de 5 MB
./compress_fixed_size.sh /path/to/file.txt backup 5

# Compresser le répertoire system en fichiers de 50 MB
./compress_fixed_size.sh system system_backup 50
```

### Décompression

```bash
./decompress_archives.sh <archive_prefix> [output_dir]
```

**Exemples:**
```bash
# Décompresser dans le répertoire courant
./decompress_archives.sh myarchive

# Décompresser dans un répertoire spécifique
./decompress_archives.sh myarchive /path/to/extract
```

### Test de Démonstration

```bash
./test_compression.sh
```

## Fonctionnalités

### compress_fixed_size.sh
- ✓ Accepte une source (fichier ou répertoire)
- ✓ Crée des archives de taille fixe (en MB)
- ✓ Numérote automatiquement les parties (part_0000, part_0001, etc.)
- ✓ Génère un fichier de métadonnées
- ✓ Affiche des informations détaillées sur le processus
- ✓ Validation robuste des arguments

### decompress_archives.sh
- ✓ **Utilise un FOR LOOP** pour itérer sur les archives numérotées
- ✓ Assemble automatiquement toutes les parties
- ✓ Extrait dans le répertoire spécifié
- ✓ Lit et affiche les métadonnées
- ✓ Nettoyage automatique des fichiers temporaires
- ✓ Validation de l'intégrité

## Exemple de Sortie

### Compression
```
===================================================
Compression avec taille fixe - Proof of Concept
===================================================
Source: test_data
Préfixe de sortie: test_archive
Taille par fichier: 1 MB
===================================================
Étape 1: Création de l'archive tar...
Étape 2: Découpage terminé avec succès

Archives créées:
-rw-r--r-- 1 root root 323 Nov 22 21:30 test_archive_part_0000

===================================================
Compression réussie!
Nombre de parties créées: 1
===================================================
```

### Décompression avec FOR LOOP
```
===================================================
Décompression avec FOR LOOP - Proof of Concept
===================================================
Étape 1: Assemblage des parties avec FOR LOOP...

  Ajout de la partie 1: test_archive_part_0000 (512)

Total de parties assemblées: 1
===================================================
Décompression réussie!
===================================================
```

## Caractéristiques Techniques

- **Sans fonctions** - Code linéaire et simple
- **Robuste** - Validation complète des arguments et erreurs
- **For loops** - Démonstration claire de l'utilisation des boucles
- **Métadonnées** - Sauvegarde des informations de compression
- **Nettoyage** - Suppression automatique des fichiers temporaires
- **Portable** - Compatible avec tous les systèmes Linux/Unix

## Nettoyage

Pour supprimer les fichiers de test:
```bash
rm -rf test_data extracted_data test_archive_*
```

## Notes

Les scripts utilisent:
- `tar` pour l'archivage
- `gzip` pour la compression
- `split` pour le découpage en taille fixe
- `cat` pour l'assemblage
- **for loops** pour itérer sur les archives numérotées
