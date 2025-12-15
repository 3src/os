# Phase 3: eyePear Library Replacement Strategy

**Status**: 📋 Planning Complete - Ready for Implementation
**Created**: 2025-12-15
**Objective**: Replace outdated eyePear (PEAR) library with modern Composer packages

---

## Executive Summary

**Challenge**: The eyePear library contains 164 PHP files with 64+ PHP 8 compatibility issues (PHP4 constructors, each() calls, ereg() calls).

**Strategy**: Replace only the **8 actively used components** (5% of eyePear) rather than fixing all 164 files.

**Impact**:
- ✅ Eliminates all 64 remaining PHP 8 issues
- ✅ Reduces codebase by ~50,000 lines (eyePear is 35% of total)
- ✅ Modern, maintained dependencies
- ✅ Better performance and security

---

## Current State: eyePear Usage Analysis

### Actually Used Components (8 of 164 files)

| Component | Usage | Files | Priority |
|-----------|-------|-------|----------|
| **HTTP_Request2** | HTTP client | eyeURL | 🔴 P0 Critical |
| **File_Archive** | Archive handling | eyeFileArchive | 🔴 P0 Critical |
| **System_SharedMemory** | Session storage | eyeIPC, eyeSessions | 🔴 P0 Critical |
| **Contact_Vcard_Build** | vCard export | eyeContacts, eyeAddressBook | 🟡 P1 High |
| **Contact_Vcard_Parse** | vCard import | eyeContacts, eyeAddressBook | 🟡 P1 High |
| **Crypt_XXTEA** | XXTEA encryption | eyeCrypt | 🟢 P2 Medium |
| **Crypt_RC42** | RC4 encryption | eyeCrypt | 🟢 P2 Medium |
| **Numbers_Roman** | Roman numerals | eyeString | 🔵 P3 Low |

### Unused Components (156 files - 95%)

**Can be safely removed**:
- PEAR/Registry, PEAR/Config, PEAR/Installer (PEAR management - not needed)
- PEAR/Builder, PEAR/Packager (package creation - not needed)
- PEAR/RunTest, PEAR/ErrorStack (testing - not needed)
- MIME/Type (not actively called)
- Net/URL2 (not actively called)
- OS/Guess (not actively called)
- And 140+ more unused files

---

## Modern Composer Replacements

### P0: Critical Components (Must Replace First)

#### 1. HTTP_Request2 → Guzzle 7.x or Symfony HTTP Client

**Current**: `pear/http_request2` (2011, unmaintained)
**Replacement Options**:

**Option A: Guzzle 7.x** (Recommended)
```json
{
    "require": {
        "guzzlehttp/guzzle": "^7.8"
    }
}
```
- ✅ Industry standard (used by Laravel, Symfony, WordPress)
- ✅ Excellent documentation
- ✅ Active maintenance
- ✅ PSR-7/PSR-18 compliant
- ✅ Simple migration path

**Option B: Symfony HTTP Client**
```json
{
    "require": {
        "symfony/http-client": "^6.4"
    }
}
```
- ✅ Part of Symfony ecosystem
- ✅ PSR-18 compliant
- ⚠️ More complex API

**Recommendation**: **Guzzle 7.x** - simpler API, more popular

**Migration Complexity**: 🟡 Medium (1-2 days)
- API is similar to HTTP_Request2
- Need to update eyeURL wrapper
- Estimated: 1 file modified (system/system/lib/eyeURL/main.eyecode)

---

#### 2. File_Archive → league/flysystem or symfony/filesystem

**Current**: `pear/file_archive` (2008, unmaintained)
**Replacement Options**:

**Option A: league/flysystem** (Recommended)
```json
{
    "require": {
        "league/flysystem": "^3.0",
        "league/flysystem-ziparchive": "^3.0"
    }
}
```
- ✅ Modern abstraction layer
- ✅ Supports multiple storage backends
- ✅ Active maintenance
- ✅ Excellent documentation

**Option B: Native PHP ZipArchive + Symfony Finder**
```json
{
    "require": {
        "symfony/finder": "^6.4"
    }
}
```
- ✅ Uses built-in PHP ZipArchive class (PHP 5.2+)
- ✅ Lighter weight
- ⚠️ Less abstraction

**Recommendation**: **league/flysystem** - better abstraction, future-proof

**Migration Complexity**: 🟠 Medium-High (2-3 days)
- eyeFileArchive is complex (multiple files)
- Need to rewrite archive handling logic
- Estimated: 5-8 files modified in system/system/lib/eyeFileArchive/

---

#### 3. System_SharedMemory → Native PHP or doctrine/cache

**Current**: `pear/system_sharedmemory` (2005, unmaintained)
**Current Usage**: Session storage in files (tmp/smf_*)

**Replacement Options**:

**Option A: Keep Current File-Based Implementation** (Recommended for Quick Wins)
- ✅ Already works (File driver is custom, not PEAR)
- ✅ No dependencies needed
- ✅ Zero migration effort
- ⚠️ PEAR.php base class dependency remains

**Option B: symfony/cache**
```json
{
    "require": {
        "symfony/cache": "^6.4"
    }
}
```
- ✅ Modern PSR-6/PSR-16 compliant
- ✅ Multiple backends (file, Redis, Memcached, APCu)
- ✅ Better performance
- ⚠️ More complex migration

**Option C: Native PHP Sessions**
- ✅ Built-in, no dependencies
- ⚠️ Major architectural change
- ⚠️ Breaks VFS compatibility

**Recommendation**: **Keep current implementation**, remove PEAR.php dependency

**Migration Complexity**: 🟢 Low (1 day)
- Extract File driver from eyeIPC
- Remove PEAR base class extends
- No API changes to rest of system

---

### P1: High Priority Components

#### 4 & 5. Contact_Vcard_Build/Parse → sabre/vobject

**Current**: `pear/contact_vcard_build` + `pear/contact_vcard_parse` (2005, unmaintained)
**Replacement**:

```json
{
    "require": {
        "sabre/vobject": "^4.5"
    }
}
```

**Benefits**:
- ✅ Modern, actively maintained
- ✅ Handles vCard 3.0, 4.0, and iCalendar
- ✅ Better parsing and validation
- ✅ Used by ownCloud, Nextcloud, Sabre/DAV

**Migration Complexity**: 🟡 Medium (2 days)
- Affects: eyeContacts, eyeAddressBook
- Need to rewrite vCard import/export functions
- Estimated: 4 files modified

---

### P2: Medium Priority Components

#### 6 & 7. Crypt_XXTEA / Crypt_RC42 → phpseclib/phpseclib

**Current**: `pear/crypt_xxtea` + `pear/crypt_rc42` (2004, unmaintained)
**Replacement**:

```json
{
    "require": {
        "phpseclib/phpseclib": "^3.0"
    }
}
```

**Benefits**:
- ✅ Pure PHP cryptography library
- ✅ Supports RC4, AES, RSA, and many more
- ✅ Active maintenance
- ✅ Better security practices

**Migration Complexity**: 🟢 Low-Medium (1 day)
- Affects: eyeCrypt library
- Simple API replacement
- Estimated: 2 files modified

---

### P3: Low Priority Components

#### 8. Numbers_Roman → Custom Implementation

**Current**: `pear/numbers_roman` (2003, unmaintained)
**Replacement**: Write custom function (50 lines)

```php
function romanToNumber($roman) {
    $values = ['I'=>1, 'V'=>5, 'X'=>10, 'L'=>50, 'C'=>100, 'D'=>500, 'M'=>1000];
    $result = 0;
    $prev = 0;
    for ($i = strlen($roman) - 1; $i >= 0; $i--) {
        $current = $values[$roman[$i]];
        if ($current < $prev) {
            $result -= $current;
        } else {
            $result += $current;
        }
        $prev = $current;
    }
    return $result;
}
```

**Migration Complexity**: 🟢 Very Low (1 hour)
- Affects: eyeString app only
- Simple replacement
- Estimated: 1 file modified

---

## Migration Plan: Phased Approach

### Phase 3A: Foundation (Week 1)
**Objective**: Remove PEAR dependency, keep functionality

1. **Extract eyeIPC File driver** (1 day)
   - Remove PEAR base class dependency
   - Create standalone File_SharedMemory class
   - Test session storage still works

2. **Update composer.json** (1 hour)
   - Add Guzzle, Flysystem, sabre/vobject, phpseclib
   - Run `composer install`

3. **Create compatibility wrappers** (1 day)
   - Create eyePear_Compat class for backward compatibility
   - Allows gradual migration

**Deliverables**:
- ✅ PEAR.php no longer required
- ✅ New Composer packages installed
- ✅ Sessions still work (no regression)

---

### Phase 3B: HTTP Client (Week 2)
**Objective**: Replace HTTP_Request2 with Guzzle

1. **Rewrite eyeURL wrapper** (1 day)
   - Replace HTTP_Request2 calls with Guzzle
   - Maintain same API for backward compatibility

2. **Test HTTP functionality** (1 day)
   - Test eyeURL operations
   - Test external URL fetching
   - Verify eyeFeeds still works (RSS/Atom)

**Deliverables**:
- ✅ Guzzle replaces HTTP_Request2
- ✅ eyeURL tests pass
- ✅ eyeFeeds RSS fetching works

---

### Phase 3C: File Archive (Week 3)
**Objective**: Replace File_Archive with Flysystem

1. **Rewrite eyeFileArchive** (2 days)
   - Replace File_Archive with Flysystem
   - Maintain VFS compatibility
   - Support ZIP, TAR, GZ formats

2. **Test archive operations** (1 day)
   - Test file compression/decompression
   - Test archive browsing
   - Verify eyeFiles integration

**Deliverables**:
- ✅ Flysystem replaces File_Archive
- ✅ Archive operations work
- ✅ eyeFiles can handle archives

---

### Phase 3D: Contacts & Crypto (Week 4)
**Objective**: Replace vCard and crypto libraries

1. **Rewrite eyeContacts with sabre/vobject** (1.5 days)
   - Replace Contact_Vcard_Build/Parse
   - Test vCard import/export
   - Update eyeAddressBook

2. **Rewrite eyeCrypt with phpseclib** (1 day)
   - Replace Crypt_XXTEA and Crypt_RC42
   - Test encryption/decryption
   - Verify data compatibility

3. **Replace Numbers_Roman** (0.5 day)
   - Implement custom function
   - Test Roman numeral conversions

**Deliverables**:
- ✅ sabre/vobject replaces vCard libraries
- ✅ phpseclib replaces crypto libraries
- ✅ Custom Roman numeral function
- ✅ ALL eyePear dependencies removed

---

### Phase 3E: Cleanup (Week 5)
**Objective**: Remove eyePear library entirely

1. **Remove eyePear directory** (1 hour)
   - Delete system/system/lib/eyePear/ (164 files, ~50,000 lines)
   - Update INDEX.md documentation

2. **Remove eyePear loader** (1 hour)
   - Delete system/system/lib/eyePear/main.eyecode
   - Update index.php (remove eyePear include path)

3. **Final testing** (2 days)
   - Run all 135+ tests from TESTING_JOURNAL.md
   - Verify no PEAR dependencies remain
   - Check for regressions

**Deliverables**:
- ✅ eyePear directory deleted (-50,000 lines)
- ✅ All tests pass
- ✅ 0 PHP 8 issues remain (100% complete)

---

## Success Metrics

### Before Phase 3
- PHP 8 Issues: 64 (in eyePear)
- Lines of Code: ~145,000
- Dependencies: eyePear (unmaintained, 2005-2011)
- PHP 8 Compatibility: 93.7%

### After Phase 3
- PHP 8 Issues: 0 ✅
- Lines of Code: ~95,000 (-50,000)
- Dependencies: Modern Composer packages (maintained)
- PHP 8 Compatibility: 100% ✅

---

## Risk Assessment

### Overall Risk: 🟡 MEDIUM

| Component | Risk | Mitigation |
|-----------|------|------------|
| HTTP Client | 🟢 Low | Guzzle API is similar, well-documented |
| File Archive | 🟠 Medium-High | Complex logic, thorough testing required |
| IPC/Sessions | 🟢 Low | Keep current implementation, minimal changes |
| vCard | 🟡 Medium | sabre/vobject is mature, test import/export |
| Crypto | 🟢 Low | phpseclib is well-tested |
| Roman Numerals | 🟢 Very Low | Simple logic, easy to test |

### Critical Path Dependencies
```
Phase 3A (Foundation)
  ↓
Phase 3B (HTTP) + Phase 3C (Archive) [parallel]
  ↓
Phase 3D (Contacts + Crypto) [parallel]
  ↓
Phase 3E (Cleanup & Testing)
```

### Rollback Plan
- Keep eyePear in separate branch for 30 days
- Document all API changes
- Maintain compatibility wrappers during transition

---

## Estimated Timeline

| Phase | Duration | Effort | Dependencies |
|-------|----------|--------|--------------|
| 3A: Foundation | 2 days | 16 hours | None |
| 3B: HTTP Client | 2 days | 16 hours | 3A complete |
| 3C: File Archive | 3 days | 24 hours | 3A complete |
| 3D: Contacts + Crypto | 2 days | 16 hours | 3B, 3C complete |
| 3E: Cleanup | 3 days | 24 hours | 3A-3D complete |
| **TOTAL** | **2-3 weeks** | **96 hours** | Sequential + parallel |

With parallel execution of 3B + 3C, actual calendar time: **2 weeks**

---

## Next Steps

### Immediate (Option 1): Start Phase 3A
1. Create `system/system/lib/eyeIPC/FileStorage.eyecode`
2. Extract File driver, remove PEAR dependency
3. Test sessions still work

### Immediate (Option 2): Update composer.json First
1. Add all modern packages to composer.json
2. Run `composer install`
3. Then proceed with Phase 3A

### Deferred: Full Testing
- Requires test environment setup
- Execute 135+ tests from TESTING_JOURNAL.md
- Recommended after Phase 3E complete

---

## Decision Required

**Which approach do you prefer?**

**A) Aggressive** - Replace all 8 components (2-3 weeks, 100% complete)
**B) Conservative** - Replace only P0 critical (1 week, eliminates 90% of issues)
**C) Minimal** - Fix eyePear PHP 8 issues in place (3 days, keeps technical debt)

**Recommendation**: **Option A (Aggressive)** - Best long-term investment, modern dependencies, cleaner codebase.

---

**Document Status**: ✅ Complete Analysis & Planning
**Ready for**: Implementation Phase 3A
**Approval Needed**: Approach selection (A/B/C)
