# 3src OS Installation & Architecture Guide

**Document Version**: 1.0
**Created**: 2025-11-16
**Status**: 📋 Complete Architecture & Installation Analysis

---

## Table of Contents

1. [.eyecode File Format](#eyecode-file-format)
2. [System Architecture](#system-architecture)
3. [Installation Requirements](#installation-requirements)
4. [Installation Process](#installation-process)
5. [File System Structure](#file-system-structure)
6. [Session & Data Storage](#session--data-storage)
7. [Configuration](#configuration)
8. [PHP 8 Migration Considerations](#php-8-migration-considerations)
9. [Troubleshooting](#troubleshooting)

---

## .eyecode File Format

### What is .eyecode?

**ANSWER**: `.eyecode` files are **NOT compressed packages**. They are **plain PHP files** with a custom extension.

**Definition**: `settings.php:52`
```php
define('EYE_CODE_EXTENSION', '.eyecode');
```

**Verification**:
```bash
$ file system/system/lib/eyeSessions/main.eyecode
PHP script, Unicode text, UTF-8 text
```

### Why Use .eyecode Extension?

**Historical Reasons**:
1. **Branding**: Part of eyeOS/oneye identity
2. **Security**: Web servers don't automatically execute `.eyecode` files (must be explicitly included by PHP)
3. **Organization**: Clearly distinguishes framework code from user code
4. **Convention**: Prevents accidental direct execution via HTTP

### How .eyecode Files Are Loaded

**Runtime Loading**:
```php
// index.php:104
include_once(EYE_ROOT.'/'.SYSTEM_DIR.'/'.KERNEL_DIR.'/kernel'.EYE_CODE_EXTENSION);
// Expands to: ./system/kernel/kernel.eyecode
```

**Convention**:
- `.eyecode` = PHP code (included via `include_once`, `require_once`)
- `.php` = PHP code (mainly entry points like index.php, settings.php)
- No compilation or decompression needed

---

## System Architecture

### Core Components

```
3src OS Architecture
├── Entry Points
│   ├── index.php              # Main entry (loads browser/index.php)
│   ├── browser/index.php      # Desktop interface
│   ├── mobile/index.php       # Mobile interface
│   └── iphone/index.php       # iPhone-specific interface
│
├── Kernel Layer
│   ├── kernel/kernel.eyecode  # Core kernel initialization
│   ├── kernel/init.eyecode    # Desktop initialization
│   └── kernel/compat.eyecode  # PHP compatibility functions
│
├── Service Layer (system/system/services/)
│   ├── mmap/                  # Message mapping & routing
│   ├── proc/                  # Process management
│   ├── eyex/                  # XML message bus
│   └── extern/                # External file serving
│
├── Library Layer (system/system/lib/)
│   ├── eyeSessions/           # Session management
│   ├── eyeIPC/                # Inter-process communication (File storage)
│   ├── eyeWidgets/            # UI widget library
│   ├── eyeString/             # UTF-8 string handling
│   ├── eyePear/               # PEAR library collection
│   └── vendor/                # Composer dependencies (NEW)
│
├── Application Layer (system/apps/)
│   ├── eyeLogin/              # Login application
│   ├── eyeDesk/               # Desktop environment
│   ├── eyeFiles/              # File manager
│   ├── eyeMail/               # Email client
│   ├── eyeCalendar/           # Calendar application
│   ├── eyeConsole/            # Terminal/console
│   └── [50+ other apps]
│
├── Data Layer
│   ├── tmp/                   # Session files (smf_[md5])
│   ├── users/                 # User data directories
│   ├── groups/                # Group shared directories
│   └── conf/                  # Configuration files
│
└── External Layer
    ├── extern/                # Public assets (CSS, JS, images)
    ├── xml-rpc/               # XML-RPC server
    └── matrix6.php            # Terminal interface (NEW)
```

### Bootstrap Sequence

**1. HTTP Request → index.php**
```
Browser Request
    ↓
index.php (root)
    ├── Load settings.php (defines all constants)
    ├── Load UTF-8 support (eyeString)
    ├── Load kernel.eyecode (core kernel)
    ├── Set PHP ini values (error_reporting, etc.)
    ├── Load libraries (PEAR, error codes)
    ├── Load services (security, logging)
    └── Route to appropriate index:
        ├── ?api=1 → xml-rpc/server.eyecode
        ├── ?extern=file → extern file serving
        ├── Mobile UA → mobile/index.php
        ├── iPhone UA → iphone/index.php
        └── Default → browser/index.php
```

**2. browser/index.php (Desktop Interface)**
```
browser/index.php
    ├── Define INDEX_TYPE='browser'
    ├── Start output buffering
    ├── Load eyeWidgets definitions
    ├── Start session (eyeSessions)
    ├── Check widget database table
    ├── Process URL parameters:
    │   ├── username/password → auto-login
    │   ├── checknum/msg → route message to process
    │   └── msg=ping → respond with pong
    └── Load init.eyecode (launch desktop)
```

**3. init.eyecode (Desktop Initialization)**
```
kernel/init.eyecode
    ├── Check for existing session
    ├── If no eyeDesk process:
    │   └── Launch eyeLogin application
    └── If logged in:
        ├── Launch eyeDesk (desktop environment)
        ├── Load user preferences
        ├── Launch startup applications
        └── Render desktop UI
```

### Message Routing System

**XML-RPC for API Calls**:
- URL: `index.php?api=1`
- Methods exposed via `xml-rpc/server.eyecode`
- Used by browser/mobile interfaces for AJAX operations

**mmap Service (Message Mapping)**:
- Routes messages between processes
- Format: `index.php?checknum=X&msg=Y&params=Z`
- Used for widget events, app communication

---

## Installation Requirements

### Server Requirements

**PHP Version**:
- **Current (Legacy)**: PHP 5.4+ (original oneye)
- **Migration Target**: PHP 7.4+ (transitional)
- **Final Target**: PHP 8.0+ (3src OS)

**PHP Extensions Required**:
- `json` - JSON encoding/decoding
- `xml` - XML parsing
- `gd` - Image manipulation
- `mbstring` - Multi-byte string handling
- `zip` - Archive handling
- `openssl` - Encryption (for SMTP/TLS)

**PHP Extensions Optional**:
- `mysql`/`mysqli` - For eyeMail MySQL backend (SQLite default)
- `ldap` - For LDAP authentication
- `imap` - For eyeMail IMAP support
- `shmop` - Shared memory (alternative to File storage)

**Web Server**:
- Apache 2.x (recommended)
  - `mod_rewrite` (optional, for clean URLs)
  - `mod_php` or PHP-FPM
- Nginx + PHP-FPM (supported)
- IIS 7+ with PHP (supported via web.config)

**File System**:
- **Writable directories** (chmod 777 or appropriate permissions):
  - `tmp/` - Session storage
  - `system/users/` - User data
  - `system/groups/` - Group data
  - `logs/` - PHP error logs
  - `system/system/conf/ports/swap/` - IPC swap files

**No Database Required**:
- 3src OS uses a **Virtual File System (VFS)**
- Session data stored in `tmp/` as serialized PHP files
- User data stored in `system/users/[username]/`
- Optional: SQLite for eyeMail (bundled with PHP 5.x+)

### Client Requirements

**Web Browsers**:
- ✅ **Firefox** (latest) - Fully supported
- ✅ **Chrome/Chromium** (80+) - Requires cookie fix (see CHROMIUM_COOKIE_FIX.md)
- ✅ **Edge** (Chromium-based) - Requires cookie fix
- ✅ **Safari** (latest) - Supported
- ⚠️ **Internet Explorer** - Legacy support (not recommended)

**Browser Features Required**:
- JavaScript enabled
- Cookies enabled
- CSS2/CSS3 support
- AJAX/XMLHttpRequest support

**Mobile Browsers**:
- Mobile interface: Any modern mobile browser
- iPhone interface: Safari iOS, Chrome iOS

---

## Installation Process

### Method 1: Automatic Installation (Original oneye)

**Note**: The automatic installer was part of the original oneye distribution but is not included in this repository (already installed system).

**Original Process** (for reference):
1. Extract package to web directory
2. Navigate to `http://yoursite.com/installer/`
3. Follow wizard:
   - PHP settings check
   - Permission verification
   - Admin user creation
   - Configuration generation
4. Installer creates:
   - Initial user (root)
   - System configuration
   - Required directories

### Method 2: Manual Installation (3src OS Migration)

**For deploying the current migrated codebase**:

**Step 1: Upload Files**
```bash
# Clone repository
git clone https://github.com/3src/os.git
cd os

# Or download and extract archive
```

**Step 2: Set Permissions**
```bash
# Make directories writable by web server
chmod -R 777 tmp/
chmod -R 777 system/users/
chmod -R 777 system/groups/
chmod -R 777 logs/

# Or use appropriate user/group:
chown -R www-data:www-data tmp/ system/users/ system/groups/ logs/
chmod -R 755 tmp/ system/users/ system/groups/ logs/
```

**Step 3: Install Composer Dependencies** (PHP 8 Migration)
```bash
# Install PHPMailer and other dependencies
cd system/
composer install --no-dev --optimize-autoloader
cd ..
```

**Step 4: Configure Web Server**

**Apache** (.htaccess already included):
```apache
# .htaccess (already in repository)
<IfModule mod_php.c>
    php_value error_reporting 1
    php_value display_errors 0
    php_value error_log ./logs/php.txt
    # ... (see .htaccess file)
</IfModule>
```

**Nginx**:
```nginx
server {
    listen 80;
    server_name os.yourdomain.com;
    root /var/www/os;
    index index.php;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php8.0-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }

    # Deny access to .eyecode files via HTTP
    location ~ \.eyecode$ {
        deny all;
    }

    # Deny access to system directories
    location ~ ^/system/(users|groups|conf)/ {
        deny all;
    }
}
```

**Step 5: Verify Installation**
```bash
# Browse to your installation
http://yoursite.com/

# You should see login screen
# Default credentials (if from original oneye):
# Username: root
# Password: (set during original installation)
```

**Step 6: Create Root User (if needed)**

If no installer and no existing users:
```bash
# Manual user creation (advanced)
# Create root user directory structure
mkdir -p system/users/rt4/root/{files,conf,tmp,trash,swap,public}
chmod -R 777 system/users/rt4/

# Copy skeleton structure
cp -r system/system/conf/skel/* system/users/rt4/root/

# Create user info file (simplified example)
# You may need to study the original installer to create proper user files
```

**Alternative**: Start with a backup from os.pastamp.com (if available)

---

## File System Structure

### Root Directory

```
/
├── index.php              # Main entry point
├── settings.php           # System configuration
├── .htaccess             # Apache configuration
├── composer.json         # Composer dependencies (NEW)
├── matrix6.php           # Terminal interface (NEW)
├── browser/              # Desktop interface
├── mobile/               # Mobile interface
├── iphone/               # iPhone interface
├── tmp/                  # ⚠️ WRITABLE - Session files
├── logs/                 # ⚠️ WRITABLE - Error logs
├── docs/                 # Documentation
└── system/               # Core system directory
```

### System Directory

```
system/
├── vendor/               # ⚠️ Composer packages (created by composer install)
├── apps/                 # Applications
├── xml-rpc/              # XML-RPC server
├── extern/               # Public assets (CSS, JS, images)
├── users/                # ⚠️ WRITABLE - User data
├── groups/               # ⚠️ WRITABLE - Group data
├── conf/                 # System configuration
└── system/
    ├── kernel/           # Core kernel
    ├── lib/              # System libraries
    ├── services/         # System services
    ├── conf/             # Core configuration
    └── i18n/             # Internationalization
```

### User Directory Structure

```
system/users/[hash]/[username]/
├── files/                # User files (VFS)
│   ├── Documents/
│   ├── Images/
│   ├── Music/
│   ├── Videos/
│   └── [user-created folders]
├── conf/                 # User configuration
│   ├── eyeCalendar/
│   ├── eyeMail/
│   └── [app configs]
├── tmp/                  # User temporary files
├── trash/                # User trash bin
├── swap/                 # User swap space
└── public/               # Publicly shared files
```

### Session Storage (tmp/)

**Location**: `./tmp/` (defined as `EYE_ROOT/tmp`)

**File Format**:
```
tmp/smf_[md5(sessionId)]
```

**Example**:
```
tmp/smf_5f4dcc3b5aa765d61d8327deb882cf99
```

**Contents**: Serialized PHP session data
```php
// File contains:
serialize($_SESSION);

// Stored by: system/system/lib/eyeIPC/modules/File.eyecode
// Format: fwrite($fp, serialize($value));
```

---

## Session & Data Storage

### Session Management Architecture

**Flow**:
```
1. Browser Request
   ↓
2. eyeSessions('startSession')
   ├── Check for PHPSESSID cookie
   ├── If exists: Load session from eyeIPC
   └── If not: Create new session
   ↓
3. eyeIPC('getVar', [$sessionId, 'File'])
   ├── Uses System_SharedMemory_File driver
   ├── Reads: tmp/smf_[md5($sessionId)]
   └── Unserializes: $_SESSION data
   ↓
4. Process Request
   ├── Modify $_SESSION as needed
   └── Application logic
   ↓
5. register_shutdown_function('eyeSessions', 'saveSession')
   ├── Called at script end
   ├── eyeIPC('setVar', [$sessionId, $_SESSION, 'File'])
   ├── Serializes: serialize($_SESSION)
   └── Writes: tmp/smf_[md5($sessionId)]
```

### Cookie Configuration

**Current (After Chromium Fix)**:
```php
// system/system/lib/eyeSessions/main.eyecode:53
setcookie(COOKIE_ID, $sessionId, [
    'expires' => COOKIE_EXPIRE,      // 2147483647 (year 2038)
    'path' => '/',
    'domain' => '',
    'secure' => isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on',
    'httponly' => true,
    'samesite' => 'Lax'
]);
```

**Cookie Attributes**:
- **Name**: `PHPSESSID`
- **Value**: MD5 hash (32 chars) generated by `md5(uniqid(rand()))`
- **Expires**: 2038-01-19 (max 32-bit timestamp)
- **Path**: `/` (site-wide)
- **HttpOnly**: `true` (XSS protection)
- **Secure**: `true` if HTTPS (Chromium requires this)
- **SameSite**: `Lax` (Chromium compatibility)

### IPC Storage Drivers

**Available Drivers** (`system/system/lib/eyeIPC/modules/`):

1. **File** (default) - `File.eyecode`
   - Storage: `tmp/smf_[md5(name)]`
   - Format: Serialized PHP data
   - Pros: No dependencies, portable
   - Cons: File I/O overhead

2. **Shmop** - `Shmop.eyecode`
   - Storage: Shared memory (shmop extension)
   - Pros: Fast, in-memory
   - Cons: Requires `shmop` extension, limited size

3. **Systemv** - `Systemv.eyecode`
   - Storage: System V shared memory
   - Pros: Fast, in-memory
   - Cons: Requires `sysvshm` extension, limited size

4. **Apachenote** - `Apachenote.eyecode`
   - Storage: Apache notes (apache_note())
   - Pros: Integrated with Apache
   - Cons: Apache-only, limited use

**Default Selection**:
```php
// system/system/lib/eyeSessions/main.eyecode:22
define('IPC_TYPE', 'File');
```

---

## Configuration

### Main Configuration: settings.php

**Key Constants**:
```php
// Paths
define('EYE_ROOT', '.');
define('REAL_EYE_ROOT', 'system');
define('SYSTEM_DIR', 'system');
define('APP_DIR', 'apps');
define('USERS_DIR', 'users');
define('EYEOS_TMP_DIR', 'tmp');

// Extensions
define('EYE_CODE_EXTENSION', '.eyecode');

// VFS & User Management
define('VFS_MODULE', 'virtual');
define('UM_MODULE', 'oneye');
define('REAL_ROOTUSER', 'root');

// Version
define('EYEOS_VERSION', '1.11.6.0preview');
define('ONEYE_VERSION', '0.9.6preview');

// Features
define('ACL_SUPPORT', 1);
define('XML_COMPAT', 1);
define('CHECK_MOBILE', 1);
define('TIMEZONE', 'UTC');

// LDAP (optional)
define('LDAP_DN', 'uid=%0,ou=People,o=localhost');
define('LDAP_SERVER', 'localhost');
```

### System Configuration Files

**Location**: `system/system/conf/`

**Key Files**:
- `system.xml` - Main system configuration
- `skel/` - Skeleton directory for new users
- `ACL/` - Access Control List rules
- `ports/swap/` - IPC swap directory

### Application Configuration

**Per-User**:
- `system/users/[hash]/[user]/conf/[app]/`
- Example: `system/users/rt4/root/conf/eyeMail/accounts.xml`

**Shared** (Global):
- `system/apps/share/[app]/`
- Example: `system/apps/share/eyeControl/`

---

## PHP 8 Migration Considerations

### Completed Migrations

**✅ Quick Win #1: PHPMailer** (COMPLETE)
- Migrated from 5.1 to 6.12.0
- Composer managed: `composer require phpmailer/phpmailer`
- See: PHPMAILER_MIGRATION.md

**✅ Quick Win #2: var Keywords** (COMPLETE)
- Fixed 917 occurrences across 48 files
- Changed `var $property` → `public $property`
- See: VAR_KEYWORD_MIGRATION.md

**✅ Quick Win #3: XML-RPC** (COMPLETE)
- Fixed 13 `each()` calls (fatal in PHP 8.0)
- Fixed 5 PHP4 constructors
- See: XMLRPC_MIGRATION.md

**✅ Quick Win #4: Chromium Cookies** (COMPLETE)
- Added SameSite, HttpOnly, Secure attributes
- Fixed Chromium browser compatibility
- See: CHROMIUM_COOKIE_FIX.md

### Critical .htaccess Issues

**⚠️ PROBLEM**: `.htaccess` contains deprecated PHP settings (line 1-33)

**Deprecated directives** (removed in PHP 5.4-8.0):
```apache
php_value magic_quotes_gpc 0           # Removed PHP 5.4
php_value magic_quotes_runtime 0       # Removed PHP 5.4
php_value magic_quotes_sybase 0        # Removed PHP 5.4
php_value register_globals 0           # Removed PHP 5.4
php_value safe_mode 0                  # Removed PHP 5.4
php_value zend.ze1_compatibility_mode 0 # Removed PHP 5.3
```

**Fix Required**:
```apache
# Remove deprecated directives or use:
<IfModule mod_php5.c>
    # Legacy PHP 5.x settings
</IfModule>

<IfModule mod_php.c>
    # PHP 7/8 compatible settings only
    php_value error_reporting 1
    php_value display_errors 0
    php_value error_log ./logs/php.txt
    php_value file_uploads 1
    php_value allow_url_fopen 1
    # ... (remove all magic_quotes, safe_mode, etc.)
</IfModule>
```

**Impact**: Apache may fail to start or serve 500 errors if these directives are present with PHP 8.

### Remaining Critical Issues

**PHP 8.0 Fatal Errors** (must fix before deployment):
- 🔴 12+ remaining `each()` calls in eyePear libraries
- 🔴 20+ PHP4 constructors in eyePear libraries
- 🔴 8 `create_function()` calls (removed in PHP 8.0)
- 🔴 8 `ereg()` calls (removed in PHP 7.0)

**See**: PHP8_OBSOLETE_CODE_DOCUMENTATION.md for complete list

---

## Troubleshooting

### Common Issues

**Issue 1: Session Not Persisting (Chromium)**
```
Symptom: Login works, but session lost on refresh (Chrome/Edge)
Cause: Missing SameSite cookie attribute
Fix: See CHROMIUM_COOKIE_FIX.md
Status: ✅ FIXED (Quick Win #4)
```

**Issue 2: White Screen / 500 Error**
```
Symptom: Blank page or HTTP 500 error
Cause: PHP error, check logs/php.txt
Debug:
  1. Check logs/php.txt
  2. Enable display_errors in .htaccess (temporarily)
  3. Check Apache error log
  4. Verify PHP version compatibility
```

**Issue 3: Permissions Errors**
```
Symptom: "Cannot write to tmp/" or similar
Cause: Incorrect file permissions
Fix:
  chmod -R 777 tmp/
  chmod -R 777 system/users/
  chmod -R 777 logs/
```

**Issue 4: Composer Dependencies Missing**
```
Symptom: "Class 'PHPMailer\PHPMailer\PHPMailer' not found"
Cause: composer install not run
Fix:
  cd system/
  composer install
```

**Issue 5: each() Fatal Error (PHP 8.0)**
```
Symptom: "Fatal error: Call to undefined function each()"
Cause: PHP 8.0 removed each() function
Status: Partially fixed (XML-RPC done, eyePear remaining)
Fix: See XMLRPC_MIGRATION.md for patterns
```

**Issue 6: var Keyword Deprecation Warnings**
```
Symptom: "Deprecated: var keyword deprecated"
Cause: Old PHP 4 syntax
Status: ✅ FIXED (Quick Win #2)
Fix: See VAR_KEYWORD_MIGRATION.md
```

**Issue 7: .htaccess Errors (PHP 8)**
```
Symptom: Apache fails to start or 500 error
Cause: Deprecated PHP directives in .htaccess
Fix: Remove magic_quotes, safe_mode, register_globals directives
See: "Critical .htaccess Issues" above
```

### Debug Mode

**Enable Debug Mode**:
```php
// settings.php (or system/system/conf/system.xml)
define('EYEOS_DEBUG_MODE', '2');  // E_ALL
```

**Debug Levels**:
- `0` = No errors displayed
- `1` = E_ERROR only
- `2` = E_ALL (including deprecations)
- `3` = E_ALL except E_DEPRECATED and E_NOTICE

**Check Logs**:
```bash
tail -f logs/php.txt
```

### Verify Installation Checklist

- [ ] PHP version: `php -v` shows 7.4+ or 8.0+
- [ ] Composer dependencies: `system/vendor/` exists
- [ ] Permissions: `tmp/`, `system/users/`, `logs/` writable
- [ ] .htaccess: No deprecated directives for PHP 8
- [ ] PHP extensions: `php -m` shows json, xml, gd, mbstring
- [ ] Cookie attributes: Check browser DevTools → Application → Cookies
- [ ] Session persistence: Login, refresh page, still logged in
- [ ] Applications launch: eyeDesk, eyeFiles, eyeMail work
- [ ] No PHP errors: Check `logs/php.txt`

---

## Summary: .eyecode Files ARE NOT Compressed

### Key Points

1. **`.eyecode` = Plain PHP files** with custom extension
   - Not compressed, not encrypted, not compiled
   - Just renamed `.php` files for organizational purposes

2. **No decompression needed** - Files are `include()`'d directly by PHP

3. **Verification**:
   ```bash
   file system/system/lib/eyeSessions/main.eyecode
   # Output: PHP script, Unicode text, UTF-8 text

   head -1 system/system/lib/eyeSessions/main.eyecode
   # Output: <?php
   ```

4. **Purpose of custom extension**:
   - Security: Not auto-executed by web server
   - Branding: Part of eyeOS/oneye identity
   - Organization: Clear distinction from user code

### Installation Complexity Assessment

**Complexity Level**: 🟡 **MEDIUM**

**Simple Aspects**:
- ✅ No database setup required (file-based VFS)
- ✅ No compilation/build process (plain PHP)
- ✅ Minimal dependencies (Composer installs automatically)
- ✅ Original installer handled most setup (if available)

**Complex Aspects**:
- ⚠️ File permissions must be correct (777 for data directories)
- ⚠️ PHP 8 migration incomplete (some fatal errors remain)
- ⚠️ .htaccess contains deprecated directives
- ⚠️ No SQL schema - but also means custom VFS logic to understand
- ⚠️ Multiple interface entry points (browser, mobile, iPhone, XML-RPC)

**Recommended Approach**:
1. Start with existing installation (os.pastamp.com)
2. Complete PHP 8 migration (fix remaining issues)
3. Test thoroughly before fresh deployment
4. Use existing user directory as template for new installs

---

**Document Status**: ✅ Complete Analysis
**Next Steps**: Complete remaining PHP 8 Quick Wins (eyePear library fixes)
**References**:
- PHP8_OBSOLETE_CODE_DOCUMENTATION.md
- CHROMIUM_COOKIE_FIX.md
- VAR_KEYWORD_MIGRATION.md
- XMLRPC_MIGRATION.md
