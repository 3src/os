# PHP 8 Obsolete Code Documentation

This document catalogs all PHP code in the codebase that is obsolete from a PHP 8 perspective. These patterns were either deprecated in PHP 7.x and removed in PHP 8.0, or are no longer recommended best practices.

## Executive Summary

**Total Issues Found:** 100+ occurrences across multiple categories

**Severity Levels:**
- 🔴 **Critical**: Code that will cause fatal errors in PHP 8.0+ (must fix)
- 🟡 **Warning**: Deprecated patterns that still work but should be updated
- 🔵 **Info**: Legacy patterns that work but are not best practice

---

## 1. 🔴 create_function() - REMOVED IN PHP 8.0

**Status:** Fatal error in PHP 8.0+
**Replacement:** Anonymous functions (closures) or arrow functions

### Files Affected (8 occurrences)

| File | Line | Context |
|------|------|---------|
| `system/system/lib/eyePear/PEAR/Downloader.php` | 171 | `$strtolower = create_function('$a','return strtolower($a);');` |
| `system/system/lib/eyePear/PEAR/ErrorStack.php` | 868 | `$ret['function'] = 'create_function() code';` (comment only) |
| `system/system/lib/eyePear/PEAR/Autoloader.php` | 97 | `array_walk($method, create_function('$a,&$b', '$b = strtolower($b);'));` |
| `system/system/lib/eyePear/PEAR/Registry.php` | 2074 | `$notempty = create_function('$a','return !empty($a);');` |
| `system/system/lib/eyePear/System/Command.php` | 413 | `$function = create_function('', $line);` |
| `system/system/lib/eyePear/PEAR/PackageFile/v2.php` | 418 | `array_walk($my, create_function('&$i, $k', '$i = $i["handle"];'));` |
| `system/system/lib/eyePear/PEAR/PackageFile/v2.php` | 423 | `array_walk($yours, create_function('&$i, $k', '$i = $i["handle"];'));` |
| `system/system/lib/eyePear/PEAR/Command/Registry.php` | 589 | `array_map(create_function('$a', ...` |
| `system/xml-rpc/xmlrpc_wrappers.inc` | Multiple | Uses in XML-RPC wrapper |

**Migration Example:**
```php
// OLD - PHP 8 Fatal Error
$func = create_function('$a', 'return strtolower($a);');

// NEW - Use anonymous function
$func = function($a) { return strtolower($a); };

// NEWER - Use arrow function (PHP 7.4+)
$func = fn($a) => strtolower($a);
```

---

## 2. 🔴 each() - REMOVED IN PHP 8.0

**Status:** Fatal error in PHP 8.0+
**Replacement:** `foreach`, `current()` + `next()`, or `array_key_first()`/`array_key_last()`

### Files Affected (20+ occurrences)

| File | Line | Context |
|------|------|---------|
| `system/system/lib/eyePear/PEAR.php` | 750 | `while (list($k, $objref) = each($_PEAR_destructor_object_list))` |
| `system/apps/eyeMail/class.phpmailer.php` | 1645 | `while( list(, $line) = each($lines) )` |
| `system/apps/eyeMail/class.smtp.php` | 388 | `while(list(,$line) = @each($lines))` |
| `system/apps/eyeMail/class.smtp.php` | 417 | `while(list(,$line_out) = @each($lines_out))` |
| `system/apps/eyeNav/plugins/eyeNavProxy/index.php` | 639 | `else if (list(...) = each($GLOBALS['_auth_creds']))` |
| `system/system/lib/eyePear/PEAR/Autoloader.php` | 174 | `while (list($method, $obj) = each($this->_method_map))` |
| `system/system/lib/eyePear/PEAR/Command/Common.php` | 147 | `while (list($option, $info) = each($this->commands[$command]['options']))` |
| `system/system/lib/eyePear/PEAR/PackageFile/Generator/v1.php` | 745 | `list($key, $blah) = each ($deps['php']);` |
| `system/xml-rpc/xmlrpc.inc` | Multiple | Multiple uses in XML-RPC library |

**Note:** Also found in JavaScript files (tiny_mce), which are not PHP concerns.

**Migration Example:**
```php
// OLD - PHP 8 Fatal Error
while (list($key, $value) = each($array)) {
    echo "$key => $value\n";
}

// NEW - Use foreach
foreach ($array as $key => $value) {
    echo "$key => $value\n";
}
```

---

## 3. 🔴 ereg(), eregi(), ereg_replace() - REMOVED IN PHP 7.0

**Status:** Fatal error in PHP 7.0+
**Replacement:** PCRE functions (`preg_match()`, `preg_match_all()`, `preg_replace()`)

### Files Affected (8 occurrences)

| File | Line | Function |
|------|------|----------|
| `system/system/lib/eyePear/File/Archive.php` | 969 | Reference in comment |
| `system/system/lib/eyePear/File/Archive/Predicate/Ereg.php` | 55 | `return (bool)ereg($this->ereg, $source->getFilename());` |
| `system/system/lib/eyePear/File/Archive/Predicate/Eregi.php` | 57 | `return (bool)eregi($this->ereg, $source->getFilename());` |
| `system/system/lib/eyeFileArchive/lib/Archive.eyecode` | Multiple | ereg usage |
| `system/system/lib/eyeFileArchive/lib/Archive/Predicate/Ereg.eyecode` | Multiple | ereg usage |
| `system/system/lib/eyeFileArchive/lib/Archive/Predicate/Eregi.eyecode` | Multiple | eregi usage |
| `system/system/lib/eyeZip/main.eyecode` | Multiple | ereg usage |
| `system/system/lib/eyeSmtp/smtp.eyecode` | Multiple | ereg usage |

**Migration Example:**
```php
// OLD - Fatal error in PHP 7.0+
if (ereg("^[a-zA-Z]+$", $string)) { }
if (eregi("^hello", $string)) { }

// NEW - Use PCRE
if (preg_match("/^[a-zA-Z]+$/", $string)) { }
if (preg_match("/^hello/i", $string)) { }  // 'i' flag for case-insensitive
```

---

## 4. 🔴 get_magic_quotes_gpc() - REMOVED IN PHP 8.0

**Status:** Fatal error in PHP 8.0+
**Reason:** Magic quotes were removed in PHP 5.4, checking functions removed in PHP 8.0

### Files Affected (9 occurrences)

| File | Line | Context |
|------|------|---------|
| `index.php` | 31-32 | `if ((function_exists('get_magic_quotes_gpc')) \|\| ini_get('magic_quotes_sybase'))` |
| `system/apps/eyeNav/plugins/eyeNavProxy/index.php` | 102 | `'stripslashes' => get_magic_quotes_gpc()` |
| `system/system/lib/eyeZip/main.eyecode` | Multiple | Magic quotes checks |
| `system/system/lib/eyePear/PEAR/Registry.php` | Multiple | Magic quotes checks |
| `system/system/lib/eyePear/PEAR/DependencyDB.php` | Multiple | Magic quotes checks |
| `system/system/lib/eyePear/PEAR/Config.php` | Multiple | Magic quotes checks |
| `system/system/lib/eyePear/HTTP/Request2.php` | Multiple | Magic quotes checks |
| `system/system/lib/eyePear/File/Archive/Reader/File.php` | Multiple | Magic quotes checks |
| `system/apps/eyeMail/class.phpmailer.php` | Multiple | Magic quotes checks |

**Migration:** Simply remove all magic quotes handling code - it's no longer needed.

---

## 5. 🔴 set_magic_quotes_runtime() - REMOVED IN PHP 8.0

**Status:** Fatal error in PHP 8.0+
**Reason:** Magic quotes runtime was removed in PHP 5.4, function removed in PHP 8.0

### Files Affected (20 occurrences)

| File | Occurrences |
|------|-------------|
| `index.php` | 2 |
| `system/apps/eyeMail/class.phpmailer.php` | 2 |
| `system/system/lib/eyePear/HTTP/Request2.php` | 2 |
| `system/system/lib/eyePear/File/Archive/Reader/File.php` | 2 |
| `system/system/lib/eyePear/PEAR/DependencyDB.php` | 4 |
| `system/system/lib/eyePear/PEAR/Registry.php` | 6 |
| `system/system/lib/eyePear/PEAR/Config.php` | 2 |

**Typical Pattern:**
```php
// OLD - Fatal error in PHP 8.0+
$rt = ini_get('magic_quotes_runtime');
set_magic_quotes_runtime(0);
// ... do work ...
set_magic_quotes_runtime($rt);

// NEW - Simply remove, no longer needed
// ... do work ...
```

---

## 6. 🔴 PHP4-Style Constructors - DEPRECATED PHP 7.0, REMOVED PHP 8.0

**Status:** Fatal error in PHP 8.0+
**Issue:** Constructor methods with same name as class (PHP4 style)

### Files Affected (20+ classes)

| File | Class | Constructor |
|------|-------|-------------|
| `system/system/lib/eyePear/PEAR/Builder.php` | 66 | `function PEAR_Builder(&$ui)` |
| `system/system/lib/eyePear/PEAR/Config.php` | 595 | `function PEAR_Config(...)` |
| `system/system/lib/eyePear/PEAR/RunTest.php` | 87 | `function PEAR_RunTest(...)` |
| `system/system/lib/eyePear/PEAR/Downloader.php` | 148 | `function PEAR_Downloader(&$ui, ...)` |
| `system/system/lib/eyePear/PEAR/REST.php` | 40 | `function PEAR_REST(&$config, ...)` |
| `system/system/lib/eyePear/PEAR/ErrorStack.php` | 233 | `function PEAR_ErrorStack(...)` |
| `system/system/lib/eyePear/PEAR/Installer.php` | 119 | `function PEAR_Installer(&$ui)` |
| `system/system/lib/eyePear/PEAR/ChannelFile.php` | 197 | `function PEAR_ChannelFile()` |
| `system/system/lib/eyePear/PEAR/REST/10.php` | 40 | `function PEAR_REST_10(...)` |
| `system/system/lib/eyePear/PEAR/Downloader/Package.php` | 133 | `function PEAR_Downloader_Package(...)` |
| `system/system/lib/eyePear/PEAR/Task/Unixeol/rw.php` | 33 | `function PEAR_Task_Unixeol_rw(...)` |
| `system/system/lib/eyePear/PEAR/Frontend/CLI.php` | 50 | `function PEAR_Frontend_CLI()` |
| `system/system/lib/eyePear/PEAR/Task/Windowseol/rw.php` | 33 | `function PEAR_Task_Windowseol_rw(...)` |
| `system/system/lib/eyePear/PEAR/REST/11.php` | 41 | `function PEAR_REST_11(...)` |
| `system/system/lib/eyePear/PEAR/Common.php` | 168 | `function PEAR_Common()` |
| `system/system/lib/eyePear/PEAR/Registry.php` | 134 | `function PEAR_Registry(...)` |
| `system/system/lib/eyePear/PEAR/Task/Replace/rw.php` | 33 | `function PEAR_Task_Replace_rw(...)` |
| `system/system/lib/eyePear/PEAR/PackageFile.php` | 70 | `function PEAR_PackageFile(...)` |
| `system/system/lib/eyePear/PEAR/PackageFile/v1.php` | 349 | `function PEAR_PackageFile_v1()` |
| `system/system/lib/eyePear/PEAR/Task/Common.php` | 92 | `function PEAR_Task_Common(...)` |

**Migration Example:**
```php
// OLD - Fatal error in PHP 8.0+
class PEAR_Config {
    function PEAR_Config($param) {
        $this->config = $param;
    }
}

// NEW - Use __construct
class PEAR_Config {
    function __construct($param) {
        $this->config = $param;
    }
}
```

---

## 7. 🟡 var Keyword for Properties - DEPRECATED

**Status:** Works but deprecated since PHP 5.0
**Replacement:** Use visibility keywords (`public`, `protected`, `private`)

### Files Affected (100+ occurrences)

Major files with extensive usage:

| File | Occurrences (approx) |
|------|----------------------|
| `system/system/lib/eyePear/PEAR.php` | 16+ |
| `system/system/lib/eyePear/Contact/Vcard/Build.php` | 3 |
| `system/system/lib/eyePear/OS/Guess.php` | 5 |
| `system/system/lib/eyePear/File/Archive/Reader/*.php` | 20+ |
| `system/xml-rpc/xmlrpcs.inc` | 10+ |
| `system/xml-rpc/xmlrpc.inc` | 10+ |
| All eyeWidgets widget classes | 40+ |

**Examples Found:**
```php
// From PEAR.php:
var $_debug = false;
var $_default_error_mode = null;
var $_default_error_options = null;
var $_error_class = 'PEAR_Error';

// From PEAR_Error:
var $error_message_prefix = '';
var $mode = PEAR_ERROR_RETURN;
var $level = E_USER_NOTICE;
var $code = -1;
var $message = '';
```

**Migration Example:**
```php
// OLD - Deprecated
class Example {
    var $public_property;
    var $another_property;
}

// NEW - Use visibility
class Example {
    public $public_property;
    public $another_property;
}
```

---

## 8. 🟡 =& new Operator - DEPRECATED PHP 5.3, WARNING PHP 7.0+

**Status:** Generates E_DEPRECATED in PHP 5.3+, E_NOTICE in PHP 7.0+
**Reason:** Objects are always passed by reference in PHP 5+

### Files Affected (2 occurrences)

| File | Line | Context |
|------|------|---------|
| `system/system/lib/eyePear/PEAR.php` | 72 | Comment: `$obj =& new PEAR_child;` |
| `system/system/lib/eyeFileArchive/lib/Archive.eyecode` | Multiple | Actual usage in code |

**Migration Example:**
```php
// OLD - Unnecessary in PHP 5+
$obj =& new MyClass();

// NEW - Simply remove the &
$obj = new MyClass();
```

---

## 9. 🔵 register_globals Handling - OBSOLETE

**Status:** Feature removed in PHP 5.4.0
**Impact:** Code checking/disabling this is now unnecessary

### Files Affected (4 files)

| File | Line | Context |
|------|------|---------|
| `index.php` | Multiple | Checks and disables register_globals |
| `system/system/services/sec/main.eyecode` | Multiple | Security checks |
| `php.ini` | Multiple | Configuration |
| `.htaccess` | Multiple | Apache configuration |

**Example from index.php:**
```php
// Support for old register_globals
// If PHP has register_globals activated...
if (ini_get('register_globals')) {
    // unregister all globals received from HTTP requests
    // [complex de-registration code]
}
```

**Action:** This code can be safely removed in PHP 8+ environments.

---

## 10. 🔵 split() Function - REMOVED PHP 7.0+

**Status:** Fatal error in PHP 7.0+
**Replacement:** `explode()` or `preg_split()`

### Files Affected (20+ occurrences)

Most occurrences are in JavaScript files (not PHP concern), but found in:

| File | Context |
|------|---------|
| `system/system/lib/eyeFileArchive/lib/Archive.eyecode` | PHP usage of split() |

**Note:** Many matches are in JavaScript files (tiny_mce library) which use JavaScript's `split()` method - these are not PHP issues.

**Migration Example:**
```php
// OLD - Fatal error in PHP 7.0+
$parts = split('[/.-]', $date);

// NEW - Use explode for simple delimiter
$parts = explode('/', $date);

// OR - Use preg_split for regex
$parts = preg_split('/[\/.-]/', $date);
```

---

## Summary Statistics

### By Severity

| Severity | Count | Description |
|----------|-------|-------------|
| 🔴 Critical | 70+ | Will cause fatal errors in PHP 8.0+ |
| 🟡 Warning | 120+ | Deprecated patterns, still work |
| 🔵 Info | 10+ | Obsolete but harmless |

### By Category

| Category | Occurrences | Priority |
|----------|-------------|----------|
| PHP4 Constructors | 20+ classes | **HIGH** |
| `create_function()` | 8 | **HIGH** |
| `each()` | 20+ | **HIGH** |
| `ereg` family | 8 | **HIGH** |
| Magic quotes functions | 30+ | **HIGH** |
| `var` keyword | 100+ | MEDIUM |
| `=& new` | 2 | LOW |
| register_globals code | 4 files | LOW |

### By Directory

| Directory | Issues | Notes |
|-----------|--------|-------|
| `system/system/lib/eyePear/` | 80+ | Entire PEAR library needs update |
| `system/apps/eyeMail/` | 10+ | PHPMailer needs update |
| `system/system/lib/eyeFileArchive/` | 5+ | Archive library issues |
| `system/xml-rpc/` | 10+ | XML-RPC library issues |
| Root (`index.php`) | 5+ | Entry point compatibility code |

---

## Recommendations

### Immediate Actions (Before PHP 8 Migration)

1. **Update PEAR Library** - The eyePear library is heavily affected. Consider:
   - Updating to latest PEAR version
   - Migrating away from PEAR to modern alternatives
   - Creating compatibility layer

2. **Update PHPMailer** - The bundled version is very old:
   - Current file: `class.phpmailer.php` (pre-namespace version)
   - Recommended: Update to PHPMailer 6.x with namespaces

3. **Replace XML-RPC Library** - Uses many obsolete patterns:
   - Consider modern JSON-RPC or REST APIs
   - Update to PHP 7/8 compatible XML-RPC library

4. **Fix Critical Functions** - Priority order:
   1. PHP4 constructors → `__construct()`
   2. `create_function()` → anonymous functions
   3. `each()` → `foreach`
   4. `ereg()` → `preg_match()`
   5. Remove magic quotes handling

5. **Update Property Declarations** - Replace `var` with proper visibility

### Long-term Modernization

1. **Code Standards** - Adopt PSR-12 coding standards
2. **Namespaces** - Migrate to namespaced code structure
3. **Type Hints** - Add parameter and return type hints (PHP 7.0+)
4. **Composer** - Replace bundled libraries with Composer packages
5. **Testing** - Add unit tests before refactoring

---

## Testing Strategy

Before migrating to PHP 8:

1. **Set Error Reporting** - Enable all errors:
   ```php
   error_reporting(E_ALL);
   ini_set('display_errors', 1);
   ```

2. **PHP 7.4 Testing** - Test on PHP 7.4 first (shows deprecation notices)

3. **Static Analysis** - Use tools like:
   - PHPStan
   - Psalm
   - PHP_CodeSniffer

4. **Automated Migration** - Consider tools:
   - Rector (automated PHP upgrades)
   - PHP-CS-Fixer (code style fixes)

---

## Additional Notes

### Files Not Analyzed

This analysis covers **PHP files only**. Not included:
- `.eyecode` files (custom format, many contain PHP)
- JavaScript files (separate ecosystem)
- Configuration files (php.ini, .htaccess - noted separately)

### eyeCode Files

The codebase uses a custom `.eyecode` extension for template files that contain PHP. Many obsolete patterns exist in these files (573 files total). These would require separate analysis with proper eyecode parser.

### Third-Party Code

Several obsolete patterns are in third-party libraries:
- **PEAR framework** - Entire library is outdated
- **PHPMailer** - Very old version
- **XML-RPC** - Legacy implementation
- **TinyMCE** - JavaScript library (not PHP concern)

Consider updating or replacing these libraries rather than patching.

---

## Document Information

- **Generated:** 2025-11-08
- **Codebase Location:** `/home/user/os/`
- **PHP Files Analyzed:** 184 files
- **Lines of Code:** ~75,000 PHP lines
- **Branch:** `claude/document-php8-obsolete-code-011CUvfNCQG486FFH2ELDFCq`

---

## References

- [PHP 8.0 Migration Guide](https://www.php.net/manual/en/migration80.php)
- [PHP 8.0 Deprecated Features](https://www.php.net/manual/en/migration80.deprecated.php)
- [PHP 7.0 Removed Extensions and SAPIs](https://www.php.net/manual/en/migration70.removed-exts-sapis.php)
- [PHP RFC: Deprecations for PHP 8.0](https://wiki.php.net/rfc/deprecations_php_8_0)
