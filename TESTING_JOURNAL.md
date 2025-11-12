# PHP 8 Migration Testing Journal

This document tracks all tests that must be performed during the PHP 8 migration. Tests are organized by component and priority level. Update this document as migrations progress.

**Status Legend:**
- ⏳ **PENDING** - Not yet tested
- 🔄 **IN PROGRESS** - Currently being tested
- ✅ **PASSED** - Test completed successfully
- ❌ **FAILED** - Test failed, needs attention
- ⏭️ **DEFERRED** - Test postponed to later stage
- 🚫 **BLOCKED** - Cannot test until dependency resolved

**Priority Levels:**
- 🔴 **P0 (Critical)** - Must test before any production deployment
- 🟡 **P1 (High)** - Should test before feature sign-off
- 🔵 **P2 (Medium)** - Test during comprehensive QA
- ⚪ **P3 (Low)** - Nice to have, can test opportunistically

---

## Testing Stages

### Stage 1: Unit Testing (Current Migration Phase)
Test individual components as they are migrated.

### Stage 2: Integration Testing
Test interactions between migrated and non-migrated components.

### Stage 3: System Testing
Full system testing on PHP 8 environment.

### Stage 4: User Acceptance Testing (UAT)
End-user testing before production deployment.

### Stage 5: Production Monitoring
Post-deployment monitoring and validation.

---

## 1. PHPMailer Migration Tests

**Component:** Email functionality (eyeMail app)
**Migration Date:** 2025-11-08
**Migration Commit:** 8606db2

### Functional Tests

| Test ID | Description | Priority | Stage | Status | Notes |
|---------|-------------|----------|-------|--------|-------|
| EMAIL-001 | Send plain text email | 🔴 P0 | Stage 1 | ⏳ PENDING | Basic email send functionality |
| EMAIL-002 | Send HTML formatted email | 🔴 P0 | Stage 1 | ⏳ PENDING | Test isHTML(true) setting |
| EMAIL-003 | Send email with single attachment | 🔴 P0 | Stage 1 | ⏳ PENDING | Test addAttachment() method |
| EMAIL-004 | Send email with multiple attachments | 🟡 P1 | Stage 1 | ⏳ PENDING | Multiple addAttachment() calls |
| EMAIL-005 | Send to single recipient | 🔴 P0 | Stage 1 | ⏳ PENDING | Test addAddress() |
| EMAIL-006 | Send to multiple To recipients | 🟡 P1 | Stage 1 | ⏳ PENDING | Multiple addAddress() calls |
| EMAIL-007 | Send with CC recipients | 🟡 P1 | Stage 1 | ⏳ PENDING | Test addCC() method |
| EMAIL-008 | Send with BCC recipients | 🟡 P1 | Stage 1 | ⏳ PENDING | Test addBCC() method |
| EMAIL-009 | Send with all recipient types (To/CC/BCC) | 🟡 P1 | Stage 2 | ⏳ PENDING | Combined recipient types |
| EMAIL-010 | Verify sent emails appear in Sent folder | 🟡 P1 | Stage 2 | ⏳ PENDING | Database integration test |

### SMTP Authentication Tests

| Test ID | Description | Priority | Stage | Status | Notes |
|---------|-------------|----------|-------|--------|-------|
| SMTP-001 | SMTP authentication with valid credentials | 🔴 P0 | Stage 1 | ⏳ PENDING | Basic auth test |
| SMTP-002 | SMTP authentication with invalid credentials | 🟡 P1 | Stage 1 | ⏳ PENDING | Error handling test |
| SMTP-003 | SMTP connection without SSL/TLS | 🔵 P2 | Stage 1 | ⏳ PENDING | Non-secure connection |
| SMTP-004 | SMTP connection with SSL | 🔴 P0 | Stage 1 | ⏳ PENDING | SMTPSecure = 'ssl' |
| SMTP-005 | SMTP connection with TLS | 🟡 P1 | Stage 1 | ⏳ PENDING | SMTPSecure = 'tls' |
| SMTP-006 | SMTP on standard port (25) | 🔵 P2 | Stage 1 | ⏳ PENDING | Standard port test |
| SMTP-007 | SMTP on secure port (587) | 🟡 P1 | Stage 1 | ⏳ PENDING | Submission port |
| SMTP-008 | SMTP on SSL port (465) | 🟡 P1 | Stage 1 | ⏳ PENDING | SSL/TLS port |

### Error Handling Tests

| Test ID | Description | Priority | Stage | Status | Notes |
|---------|-------------|----------|-------|--------|-------|
| ERROR-001 | Exception handling for invalid recipient | 🔴 P0 | Stage 1 | ⏳ PENDING | Test catch block |
| ERROR-002 | Exception handling for SMTP connection failure | 🔴 P0 | Stage 1 | ⏳ PENDING | Network error handling |
| ERROR-003 | Exception handling for authentication failure | 🔴 P0 | Stage 1 | ⏳ PENDING | Auth error handling |
| ERROR-004 | Error message display to user | 🟡 P1 | Stage 2 | ⏳ PENDING | UI error messaging |
| ERROR-005 | Verify ErrorInfo contains useful details | 🟡 P1 | Stage 1 | ⏳ PENDING | Error diagnostics |
| ERROR-006 | Test with missing attachment file | 🟡 P1 | Stage 1 | ⏳ PENDING | File not found error |
| ERROR-007 | Test with oversized attachment | 🔵 P2 | Stage 2 | ⏳ PENDING | Size limit handling |

### Character Encoding Tests

| Test ID | Description | Priority | Stage | Status | Notes |
|---------|-------------|----------|-------|--------|-------|
| CHAR-001 | Send email with UTF-8 characters in subject | 🟡 P1 | Stage 1 | ⏳ PENDING | CharSet = 'utf-8' |
| CHAR-002 | Send email with UTF-8 characters in body | 🟡 P1 | Stage 1 | ⏳ PENDING | International chars |
| CHAR-003 | Send email with emojis | 🔵 P2 | Stage 2 | ⏳ PENDING | Unicode support |
| CHAR-004 | Send email with special characters | 🔵 P2 | Stage 2 | ⏳ PENDING | HTML entities, etc. |

### Integration Tests

| Test ID | Description | Priority | Stage | Status | Notes |
|---------|-------------|----------|-------|--------|-------|
| INT-001 | Composer autoloader loads correctly | 🔴 P0 | Stage 1 | ⏳ PENDING | Verify vendor/autoload.php |
| INT-002 | No conflicts with existing includes | 🔴 P0 | Stage 2 | ⏳ PENDING | Namespace isolation |
| INT-003 | Email functionality in eyeMail app UI | 🔴 P0 | Stage 2 | ⏳ PENDING | Full app integration |
| INT-004 | Attachment handling with VFS | 🟡 P1 | Stage 2 | ⏳ PENDING | vfs('getRealName') integration |
| INT-005 | Database integration for sent emails | 🟡 P1 | Stage 2 | ⏳ PENDING | SQLite storage |
| INT-006 | Multiple email accounts configuration | 🔵 P2 | Stage 3 | ⏳ PENDING | Account switching |

### Performance Tests

| Test ID | Description | Priority | Stage | Status | Notes |
|---------|-------------|----------|-------|--------|-------|
| PERF-001 | Email send time vs old PHPMailer | 🔵 P2 | Stage 3 | ⏳ PENDING | Performance comparison |
| PERF-002 | Memory usage comparison | 🔵 P2 | Stage 3 | ⏳ PENDING | Resource utilization |
| PERF-003 | Autoloader overhead measurement | 🔵 P2 | Stage 3 | ⏳ PENDING | Composer autoload impact |

### Regression Tests

| Test ID | Description | Priority | Stage | Status | Notes |
|---------|-------------|----------|-------|--------|-------|
| REG-001 | Verify existing saved drafts still work | 🟡 P1 | Stage 2 | ⏳ PENDING | Backward compatibility |
| REG-002 | Verify email templates still render | 🟡 P1 | Stage 2 | ⏳ PENDING | Template compatibility |
| REG-003 | Verify contact list integration | 🟡 P1 | Stage 2 | ⏳ PENDING | Address book |

---

## 2. Future Migration Tests (To Be Added)

### 2.1 `var` Keyword Replacement

**Component:** Widget System, Custom Apps, Libraries
**Migration Date:** 2025-11-08
**Files Modified:** 48 files (917 occurrences)
**Status:** ✅ MIGRATION COMPLETE - Tests pending
**Documentation:** VAR_KEYWORD_MIGRATION.md

#### Widget Instantiation Tests

| Test ID | Description | Priority | Stage | Status | Notes |
|---------|-------------|----------|-------|--------|-------|
| VAR-001 | Instantiate Button widget | 🔴 P0 | Stage 1 | ⏳ PENDING | Test var → public conversion |
| VAR-002 | Instantiate Window widget | 🔴 P0 | Stage 1 | ⏳ PENDING | Largest widget class (56 properties) |
| VAR-003 | Instantiate Textbox widget | 🔴 P0 | Stage 1 | ⏳ PENDING | Common input widget |
| VAR-004 | Instantiate Calendar widget | 🔴 P0 | Stage 1 | ⏳ PENDING | Had tab whitespace issues |
| VAR-005 | Instantiate all 33 widget types | 🔴 P0 | Stage 1 | ⏳ PENDING | Comprehensive widget test |

#### Property Access Tests

| Test ID | Description | Priority | Stage | Status | Notes |
|---------|-------------|----------|-------|--------|-------|
| VAR-006 | Read public properties from outside class | 🔴 P0 | Stage 1 | ⏳ PENDING | $widget->property |
| VAR-007 | Write public properties from outside class | 🔴 P0 | Stage 1 | ⏳ PENDING | $widget->property = value |
| VAR-008 | Access default property values | 🟡 P1 | Stage 1 | ⏳ PENDING | var $enabled = 1 |
| VAR-009 | Modify properties after instantiation | 🟡 P1 | Stage 1 | ⏳ PENDING | Runtime property changes |
| VAR-010 | Verify no visibility violations | 🔴 P0 | Stage 2 | ⏳ PENDING | All properties remain public |

#### Widget Display Tests

| Test ID | Description | Priority | Stage | Status | Notes |
|---------|-------------|----------|-------|--------|-------|
| VAR-011 | Render Button widget | 🔴 P0 | Stage 2 | ⏳ PENDING | Visual rendering test |
| VAR-012 | Render Window with child widgets | 🔴 P0 | Stage 2 | ⏳ PENDING | Container widget test |
| VAR-013 | Render all widget types in desktop | 🟡 P1 | Stage 2 | ⏳ PENDING | Full widget suite |
| VAR-014 | Test widget positioning (x, y properties) | 🟡 P1 | Stage 2 | ⏳ PENDING | Layout properties |
| VAR-015 | Test widget sizing (width, height) | 🟡 P1 | Stage 2 | ⏳ PENDING | Dimension properties |

#### Custom Apps Tests

| Test ID | Description | Priority | Stage | Status | Notes |
|---------|-------------|----------|-------|--------|-------|
| VAR-016 | eyeFeeds: RSS feed parsing | 🔴 P0 | Stage 2 | ⏳ PENDING | 210 var replacements |
| VAR-017 | eyeSheets: ODS file handling | 🟡 P1 | Stage 2 | ⏳ PENDING | 10 var replacements |
| VAR-018 | eyeArchive: Project class instantiation | 🟡 P1 | Stage 2 | ⏳ PENDING | 4 var replacements |
| VAR-019 | All three apps launch successfully | 🔴 P0 | Stage 2 | ⏳ PENDING | Integration test |

#### Custom Libraries Tests

| Test ID | Description | Priority | Stage | Status | Notes |
|---------|-------------|----------|-------|--------|-------|
| VAR-020 | eyeSmtp: Email sending | 🔴 P0 | Stage 2 | ⏳ PENDING | 45 var replacements |
| VAR-021 | eyeZip: Archive creation | 🟡 P1 | Stage 2 | ⏳ PENDING | 5 var replacements |
| VAR-022 | eyeSimpleDb: Database operations | 🟡 P1 | Stage 2 | ⏳ PENDING | 5 var replacements |
| VAR-023 | eyeSockets: Socket connections | 🔵 P2 | Stage 2 | ⏳ PENDING | 8 var replacements |
| VAR-024 | eyeContacts: vCard handling | 🔵 P2 | Stage 2 | ⏳ PENDING | 3 var replacements |
| VAR-025 | eyeAddressBook: Contact management | 🔵 P2 | Stage 2 | ⏳ PENDING | 3 var replacements |

#### XML-RPC Tests

| Test ID | Description | Priority | Stage | Status | Notes |
|---------|-------------|----------|-------|--------|-------|
| VAR-026 | XML-RPC method calls | 🔵 P2 | Stage 2 | ⏳ PENDING | 63 var replacements |
| VAR-027 | XML-RPC data serialization | 🔵 P2 | Stage 2 | ⏳ PENDING | Property access test |

#### Regression Tests

| Test ID | Description | Priority | Stage | Status | Notes |
|---------|-------------|----------|-------|--------|-------|
| VAR-028 | No PHP deprecation warnings | 🔴 P0 | Stage 1 | ⏳ PENDING | Check error log |
| VAR-029 | No fatal errors on widget creation | 🔴 P0 | Stage 1 | ⏳ PENDING | Basic smoke test |
| VAR-030 | Desktop environment loads | 🔴 P0 | Stage 2 | ⏳ PENDING | Full integration |
| VAR-031 | Existing saved desktops still work | 🟡 P1 | Stage 2 | ⏳ PENDING | Data compatibility |
| VAR-032 | Widget state persistence | 🟡 P1 | Stage 2 | ⏳ PENDING | Save/restore properties |

### 2.2 XML-RPC Library Update

**Component:** XML-RPC Library (Remote API Server)
**Migration Date:** 2025-11-08
**Files Modified:** 2 files (xmlrpc.inc, xmlrpcs.inc)
**Status:** ✅ MIGRATION COMPLETE - Tests pending
**Documentation:** XMLRPC_MIGRATION.md

**Issues Fixed:**
- 13 each() calls (fatal errors in PHP 8.0)
- 5 PHP4 constructors (deprecated in PHP 8.0)

#### Server Functionality Tests

| Test ID | Description | Priority | Stage | Status | Notes |
|---------|-------------|----------|-------|--------|-------|
| XMLRPC-001 | XML-RPC server starts successfully | 🔴 P0 | Stage 1 | ⏳ PENDING | Basic server initialization |
| XMLRPC-002 | Server loads dispatch map from config.xml | 🔴 P0 | Stage 1 | ⏳ PENDING | Configuration parsing |
| XMLRPC-003 | Server registers service methods | 🔴 P0 | Stage 1 | ⏳ PENDING | Method registration |
| XMLRPC-004 | Server registers lib methods | 🔴 P0 | Stage 1 | ⏳ PENDING | Library method registration |
| XMLRPC-005 | Test method responds correctly | 🟡 P1 | Stage 1 | ⏳ PENDING | Built-in test endpoint |

#### Method Call Tests

| Test ID | Description | Priority | Stage | Status | Notes |
|---------|-------------|----------|-------|--------|-------|
| XMLRPC-006 | Call service method with authentication | 🔴 P0 | Stage 1 | ⏳ PENDING | service.*.* pattern |
| XMLRPC-007 | Call lib method with authentication | 🔴 P0 | Stage 1 | ⏳ PENDING | lib.*.* pattern |
| XMLRPC-008 | Authentication with invalid credentials | 🟡 P1 | Stage 1 | ⏳ PENDING | Should reject |
| XMLRPC-009 | Method call without authentication | 🟡 P1 | Stage 1 | ⏳ PENDING | Should reject |
| XMLRPC-010 | Method with multiple parameters | 🟡 P1 | Stage 1 | ⏳ PENDING | Array parameter parsing |

#### Data Type Tests (each() fix verification)

| Test ID | Description | Priority | Stage | Status | Notes |
|---------|-------------|----------|-------|--------|-------|
| XMLRPC-011 | Encode/decode integer values | 🔴 P0 | Stage 1 | ⏳ PENDING | xmlrpcval with int |
| XMLRPC-012 | Encode/decode string values | 🔴 P0 | Stage 1 | ⏳ PENDING | xmlrpcval with string |
| XMLRPC-013 | Encode/decode boolean values | 🟡 P1 | Stage 1 | ⏳ PENDING | xmlrpcval with boolean |
| XMLRPC-014 | Encode/decode double values | 🟡 P1 | Stage 1 | ⏳ PENDING | xmlrpcval with double |
| XMLRPC-015 | Encode/decode arrays | 🔴 P0 | Stage 1 | ⏳ PENDING | Fixed each() in line 3469 |
| XMLRPC-016 | Encode/decode structs | 🔴 P0 | Stage 1 | ⏳ PENDING | Fixed structeach() method |
| XMLRPC-017 | Encode/decode nested structures | 🟡 P1 | Stage 2 | ⏳ PENDING | Complex data structures |
| XMLRPC-018 | Encode/decode dateTime values | 🔵 P2 | Stage 2 | ⏳ PENDING | ISO 8601 format |
| XMLRPC-019 | Encode/decode base64 values | 🔵 P2 | Stage 2 | ⏳ PENDING | Binary data |

#### Response Handling Tests (PHP4 constructor verification)

| Test ID | Description | Priority | Stage | Status | Notes |
|---------|-------------|----------|-------|--------|-------|
| XMLRPC-020 | Create xmlrpcresp with success value | 🔴 P0 | Stage 1 | ⏳ PENDING | __construct fixed line 1946 |
| XMLRPC-021 | Create xmlrpcresp with fault/error | 🔴 P0 | Stage 1 | ⏳ PENDING | Error response creation |
| XMLRPC-022 | Create xmlrpcmsg for method call | 🔴 P0 | Stage 1 | ⏳ PENDING | __construct fixed line 2094 |
| XMLRPC-023 | Create xmlrpcval with various types | 🔴 P0 | Stage 1 | ⏳ PENDING | __construct fixed line 2717 |
| XMLRPC-024 | Create xmlrpc_client for remote calls | 🟡 P1 | Stage 2 | ⏳ PENDING | __construct fixed line 875 |
| XMLRPC-025 | Create xmlrpc_server instance | 🔴 P0 | Stage 1 | ⏳ PENDING | __construct fixed line 501 |

#### Integration Tests

| Test ID | Description | Priority | Stage | Status | Notes |
|---------|-------------|----------|-------|--------|-------|
| XMLRPC-026 | Browser interface XML-RPC calls | 🔴 P0 | Stage 2 | ⏳ PENDING | browser/index.php integration |
| XMLRPC-027 | Mobile interface XML-RPC calls | 🔴 P0 | Stage 2 | ⏳ PENDING | mobile/index.php integration |
| XMLRPC-028 | Multiple concurrent API calls | 🟡 P1 | Stage 3 | ⏳ PENDING | Load testing |
| XMLRPC-029 | Large payload handling | 🔵 P2 | Stage 3 | ⏳ PENDING | Performance testing |

#### Regression Tests

| Test ID | Description | Priority | Stage | Status | Notes |
|---------|-------------|----------|-------|--------|-------|
| XMLRPC-030 | No PHP warnings or deprecations | 🔴 P0 | Stage 1 | ⏳ PENDING | Check error log |
| XMLRPC-031 | No fatal errors on server startup | 🔴 P0 | Stage 1 | ⏳ PENDING | Smoke test |
| XMLRPC-032 | Existing API clients still work | 🔴 P0 | Stage 2 | ⏳ PENDING | Backward compatibility |
| XMLRPC-033 | Third-party integrations functional | 🟡 P1 | Stage 3 | ⏳ PENDING | External apps |

### 2.3 eyecode Files (`each()`, `ereg()`, etc.)

**Status:** Not yet started
**Estimated Tests:** 100+ tests across 85 occurrences

| Test ID | Description | Priority | Stage | Status | Notes |
|---------|-------------|----------|-------|--------|-------|
| EYECODE-001 | eyeFeeds functionality (22 occurrences) | 🔴 P0 | Stage 1 | 🚫 BLOCKED | Not yet migrated |
| EYECODE-002 | eyeMail events (9 occurrences) | 🔴 P0 | Stage 1 | 🚫 BLOCKED | Not yet migrated |
| EYECODE-003 | eyeCalendar config (7 occurrences) | 🟡 P1 | Stage 1 | 🚫 BLOCKED | Not yet migrated |

### 2.4 eyePear Library Replacement

**Status:** Not yet started
**Estimated Tests:** 200+ tests

| Test ID | Description | Priority | Stage | Status | Notes |
|---------|-------------|----------|-------|--------|-------|
| PEAR-001 | HTTP client replacement tests | 🔴 P0 | Stage 1 | 🚫 BLOCKED | Not yet migrated |
| PEAR-002 | File archive operations | 🔴 P0 | Stage 1 | 🚫 BLOCKED | Not yet migrated |
| PEAR-003 | Error handling replacement | 🔴 P0 | Stage 1 | 🚫 BLOCKED | Not yet migrated |

---

## 3. PHP 8 Compatibility Tests

### General PHP 8 Compatibility

| Test ID | Description | Priority | Stage | Status | Notes |
|---------|-------------|----------|-------|--------|-------|
| PHP8-001 | Run codebase on PHP 8.0 | 🔴 P0 | Stage 3 | 🚫 BLOCKED | After major migrations |
| PHP8-002 | Run codebase on PHP 8.1 | 🔴 P0 | Stage 3 | 🚫 BLOCKED | After major migrations |
| PHP8-003 | Run codebase on PHP 8.2 | 🟡 P1 | Stage 3 | 🚫 BLOCKED | After major migrations |
| PHP8-004 | Run codebase on PHP 8.3 | 🟡 P1 | Stage 4 | 🚫 BLOCKED | After major migrations |
| PHP8-005 | Check for deprecation warnings | 🔴 P0 | Stage 3 | 🚫 BLOCKED | E_DEPRECATED monitoring |
| PHP8-006 | Check for strict type errors | 🟡 P1 | Stage 3 | 🚫 BLOCKED | Type compatibility |
| PHP8-007 | Verify no fatal errors on startup | 🔴 P0 | Stage 3 | 🚫 BLOCKED | Basic functionality |

### Static Analysis Tests

| Test ID | Description | Priority | Stage | Status | Notes |
|---------|-------------|----------|-------|--------|-------|
| STATIC-001 | Run PHPStan level 0 | 🟡 P1 | Stage 2 | ⏳ PENDING | Basic static analysis |
| STATIC-002 | Run PHPStan level 5 | 🔵 P2 | Stage 3 | ⏳ PENDING | Advanced analysis |
| STATIC-003 | Run Psalm | 🔵 P2 | Stage 3 | ⏳ PENDING | Alternative analyzer |
| STATIC-004 | Run PHP_CodeSniffer | 🔵 P2 | Stage 3 | ⏳ PENDING | Code style |

---

## 4. System-Wide Integration Tests

### Core Functionality Tests

| Test ID | Description | Priority | Stage | Status | Notes |
|---------|-------------|----------|-------|--------|-------|
| SYS-001 | User login functionality | 🔴 P0 | Stage 3 | ⏳ PENDING | Authentication system |
| SYS-002 | File manager (eyeFiles) | 🔴 P0 | Stage 3 | ⏳ PENDING | Core app |
| SYS-003 | Calendar (eyeCalendar) | 🟡 P1 | Stage 3 | ⏳ PENDING | Date handling |
| SYS-004 | Contacts (eyeContacts) | 🟡 P1 | Stage 3 | ⏳ PENDING | Database ops |
| SYS-005 | Image viewer (eyeImage) | 🔵 P2 | Stage 3 | ⏳ PENDING | Media handling |
| SYS-006 | Text editor | 🔵 P2 | Stage 3 | ⏳ PENDING | File editing |
| SYS-007 | Application installer | 🟡 P1 | Stage 3 | ⏳ PENDING | eyeManageApps |
| SYS-008 | User settings management | 🟡 P1 | Stage 3 | ⏳ PENDING | Configuration |

### Widget Library Tests

| Test ID | Description | Priority | Stage | Status | Notes |
|---------|-------------|----------|-------|--------|-------|
| WIDGET-001 | Window widget creation | 🔴 P0 | Stage 2 | ⏳ PENDING | Core widget |
| WIDGET-002 | Button widget functionality | 🔴 P0 | Stage 2 | ⏳ PENDING | Interactive element |
| WIDGET-003 | Textbox widget | 🔴 P0 | Stage 2 | ⏳ PENDING | Input element |
| WIDGET-004 | Textarea widget | 🟡 P1 | Stage 2 | ⏳ PENDING | Text input |
| WIDGET-005 | Table/Sortabletable widget | 🟡 P1 | Stage 2 | ⏳ PENDING | Data display |
| WIDGET-006 | Tree widget | 🔵 P2 | Stage 2 | ⏳ PENDING | Hierarchical data |
| WIDGET-007 | All eyeWidgets instantiation | 🔴 P0 | Stage 3 | ⏳ PENDING | Complete widget test |

### Database Tests

| Test ID | Description | Priority | Stage | Status | Notes |
|---------|-------------|----------|-------|--------|-------|
| DB-001 | SQLite operations | 🔴 P0 | Stage 3 | ⏳ PENDING | Core database |
| DB-002 | SQLite escaping functions | 🔴 P0 | Stage 3 | ⏳ PENDING | Security |
| DB-003 | XML config file operations | 🔴 P0 | Stage 3 | ⏳ PENDING | eyeXML functions |
| DB-004 | User data isolation | 🔴 P0 | Stage 3 | ⏳ PENDING | Security/privacy |

### Security Tests

| Test ID | Description | Priority | Stage | Status | Notes |
|---------|-------------|----------|-------|--------|-------|
| SEC-001 | SQL injection prevention | 🔴 P0 | Stage 3 | ⏳ PENDING | Input sanitization |
| SEC-002 | XSS prevention | 🔴 P0 | Stage 3 | ⏳ PENDING | Output escaping |
| SEC-003 | File upload restrictions | 🔴 P0 | Stage 3 | ⏳ PENDING | Upload validation |
| SEC-004 | Path traversal prevention | 🔴 P0 | Stage 3 | ⏳ PENDING | File access control |
| SEC-005 | Session security | 🔴 P0 | Stage 3 | ⏳ PENDING | Session handling |
| SEC-006 | Authentication bypass attempts | 🔴 P0 | Stage 4 | ⏳ PENDING | Penetration testing |

---

## 5. Browser Compatibility Tests

### Desktop Browser Tests

| Test ID | Description | Priority | Stage | Status | Notes |
|---------|-------------|----------|-------|--------|-------|
| BROWSER-001 | Chrome/Chromium latest | 🔴 P0 | Stage 4 | ⏳ PENDING | Primary browser |
| BROWSER-002 | Firefox latest | 🔴 P0 | Stage 4 | ⏳ PENDING | Primary browser |
| BROWSER-003 | Safari latest | 🟡 P1 | Stage 4 | ⏳ PENDING | Mac users |
| BROWSER-004 | Edge latest | 🟡 P1 | Stage 4 | ⏳ PENDING | Windows users |

### Mobile Browser Tests

| Test ID | Description | Priority | Stage | Status | Notes |
|---------|-------------|----------|-------|--------|-------|
| MOBILE-001 | Mobile Safari (iOS) | 🟡 P1 | Stage 4 | ⏳ PENDING | iPhone interface |
| MOBILE-002 | Chrome Mobile (Android) | 🟡 P1 | Stage 4 | ⏳ PENDING | Mobile interface |
| MOBILE-003 | Firefox Mobile | 🔵 P2 | Stage 4 | ⏳ PENDING | Alternative mobile |

---

## 6. Performance & Load Tests

| Test ID | Description | Priority | Stage | Status | Notes |
|---------|-------------|----------|-------|--------|-------|
| LOAD-001 | Single user concurrent operations | 🟡 P1 | Stage 3 | ⏳ PENDING | Basic performance |
| LOAD-002 | 10 concurrent users | 🟡 P1 | Stage 4 | ⏳ PENDING | Multi-user |
| LOAD-003 | 50 concurrent users | 🔵 P2 | Stage 4 | ⏳ PENDING | Load testing |
| LOAD-004 | Memory consumption monitoring | 🟡 P1 | Stage 3 | ⏳ PENDING | Resource usage |
| LOAD-005 | Autoloader performance impact | 🔵 P2 | Stage 3 | ⏳ PENDING | Composer overhead |

---

## Test Execution Log

### 2025-11-08: PHPMailer Migration

**Tested:** None (tests deferred to later stage)
**Blocker:** No test environment available currently
**Action:** All tests marked as PENDING, to be executed in Stage 1

**Notes:**
- PHPMailer migration code complete
- All functional tests documented above
- Tests to be executed when test environment is available
- Priority: EMAIL-001 through EMAIL-010, SMTP-001 through SMTP-008

---

## Test Environment Requirements

### Minimum Requirements for Testing

1. **PHP Environment:**
   - PHP 8.0+ installed
   - All required extensions enabled (mysqli, sqlite, imap, etc.)
   - Error reporting set to E_ALL

2. **SMTP Server:**
   - Test SMTP server or account
   - Both SSL and non-SSL configurations
   - Valid credentials for authentication testing

3. **Test Data:**
   - Sample email accounts configured
   - Test attachments (various sizes and types)
   - Sample recipient addresses (including invalid ones for error testing)

4. **Database:**
   - SQLite support
   - Test user accounts
   - Sample email data

5. **Tools:**
   - PHPStan or Psalm for static analysis
   - PHP_CodeSniffer for code style
   - Browser developer tools
   - Network debugging tools (for SMTP testing)

---

## Test Reporting Template

When executing tests, use this template to record results:

```markdown
### Test Execution: [DATE]

**Tester:** [Name]
**Environment:** PHP [version], [OS], [Browser if applicable]
**Component:** [Component being tested]

#### Tests Executed:
- [TEST-ID]: [PASSED/FAILED] - [Notes]
- [TEST-ID]: [PASSED/FAILED] - [Notes]

#### Issues Found:
1. [Issue description]
   - Severity: [Critical/High/Medium/Low]
   - Test ID: [TEST-ID]
   - Reproduction steps: [...]
   - Expected: [...]
   - Actual: [...]

#### Recommendations:
- [Action items]

#### Sign-off:
- [ ] All critical tests passed
- [ ] All issues documented
- [ ] Component ready for next stage
```

---

## Summary Statistics

### Current Status (as of 2025-11-08)

| Category | Total Tests | Pending | Blocked | Passed | Failed |
|----------|-------------|---------|---------|--------|--------|
| PHPMailer | 38 | 38 | 0 | 0 | 0 |
| Future Migrations | 15 | 0 | 15 | 0 | 0 |
| PHP 8 Compatibility | 11 | 7 | 4 | 0 | 0 |
| System Integration | 24 | 24 | 0 | 0 | 0 |
| Browser Compatibility | 7 | 7 | 0 | 0 | 0 |
| Performance | 5 | 5 | 0 | 0 | 0 |
| **TOTAL** | **100** | **81** | **19** | **0** | **0** |

### Coverage

- **PHPMailer:** 38 tests defined, comprehensive coverage
- **Future work:** 19 tests blocked pending migration
- **System-wide:** 56 tests pending test environment

### Next Testing Priorities

1. **Immediate (Stage 1):**
   - EMAIL-001 through EMAIL-010 (PHPMailer basic functionality)
   - SMTP-001, SMTP-004 (Authentication and SSL)
   - ERROR-001 through ERROR-003 (Error handling)

2. **Short-term (Stage 2):**
   - INT-001 through INT-006 (Integration tests)
   - WIDGET-001 through WIDGET-005 (Core widgets)

3. **Medium-term (Stage 3):**
   - SYS-001 through SYS-008 (System functionality)
   - PHP8-001 through PHP8-007 (PHP 8 compatibility)

---

## Document Maintenance

**Created:** 2025-11-08
**Last Updated:** 2025-11-08
**Owner:** PHP 8 Migration Team
**Review Frequency:** After each major migration

**Update this document:**
- ✅ After each migration (add new test categories)
- ✅ After test execution (update status)
- ✅ When issues are found (document in execution log)
- ✅ When new requirements discovered

---

## Notes for Testers

1. **Don't skip error tests** - Error handling is critical for user experience
2. **Test with real data** - Use actual email addresses, real files
3. **Document everything** - Even "obvious" failures need documentation
4. **Security first** - Security tests are P0 priority
5. **Performance matters** - Note any slowdowns, even if tests pass
6. **Browser quirks** - Test in all target browsers, not just Chrome
7. **Mobile testing** - Don't forget the iPhone and mobile interfaces

## 4. Cookie & Session Management Tests

**Component:** eyeSessions library (browser compatibility)
**Migration Date:** 2025-11-12
**Issue:** Chromium cookie compatibility (missing SameSite attribute)
**File:** system/system/lib/eyeSessions/main.eyecode:51

### Browser Compatibility Tests

| Test ID | Description | Priority | Stage | Status | Notes |
|---------|-------------|----------|-------|--------|-------|
| COOKIE-001 | Login with Chrome (latest) | 🔴 P0 | Stage 1 | ⏳ PENDING | Primary Chromium browser |
| COOKIE-002 | Login with Edge (latest) | 🔴 P0 | Stage 1 | ⏳ PENDING | Microsoft Chromium browser |
| COOKIE-003 | Login with Firefox (latest) | 🔴 P0 | Stage 1 | ⏳ PENDING | Regression test |
| COOKIE-004 | Login with Brave | 🟡 P1 | Stage 1 | ⏳ PENDING | Privacy-focused Chromium |
| COOKIE-005 | Login with Opera | 🔵 P2 | Stage 2 | ⏳ PENDING | Alternative Chromium |
| COOKIE-006 | Login with Safari (macOS/iOS) | 🔵 P2 | Stage 2 | ⏳ PENDING | WebKit browser |

### Session Persistence Tests

| Test ID | Description | Priority | Stage | Status | Notes |
|---------|-------------|----------|-------|--------|-------|
| SESSION-001 | Session survives page refresh | 🔴 P0 | Stage 1 | ⏳ PENDING | Basic persistence |
| SESSION-002 | Session survives navigation between pages | 🔴 P0 | Stage 1 | ⏳ PENDING | Multi-page navigation |
| SESSION-003 | Session shared across multiple tabs | 🔴 P0 | Stage 1 | ⏳ PENDING | Multi-tab behavior |
| SESSION-004 | Session expires on logout | 🔴 P0 | Stage 1 | ⏳ PENDING | Clean logout |
| SESSION-005 | Session persists for 24 hours | 🟡 P1 | Stage 2 | ⏳ PENDING | Long-lived cookie test |
| SESSION-006 | Session cleared on browser close (if session-only) | 🔵 P2 | Stage 2 | ⏳ PENDING | Session vs persistent cookie |

### Cookie Attribute Verification Tests

| Test ID | Description | Priority | Stage | Status | Notes |
|---------|-------------|----------|-------|--------|-------|
| ATTR-001 | Verify cookie has SameSite=Lax attribute | 🔴 P0 | Stage 1 | ⏳ PENDING | Check in DevTools |
| ATTR-002 | Verify cookie has HttpOnly flag | 🔴 P0 | Stage 1 | ⏳ PENDING | XSS protection |
| ATTR-003 | Verify cookie has Secure flag (HTTPS only) | 🔴 P0 | Stage 1 | ⏳ PENDING | HTTPS security |
| ATTR-004 | Verify cookie Path is '/' | 🟡 P1 | Stage 1 | ⏳ PENDING | Site-wide access |
| ATTR-005 | Verify cookie Domain is correct | 🟡 P1 | Stage 1 | ⏳ PENDING | Domain scope |
| ATTR-006 | Verify cookie Expires timestamp | 🔵 P2 | Stage 1 | ⏳ PENDING | 2038-01-19 max value |

### Security Tests

| Test ID | Description | Priority | Stage | Status | Notes |
|---------|-------------|----------|-------|--------|-------|
| SEC-001 | Cookie not accessible via document.cookie | 🔴 P0 | Stage 1 | ⏳ PENDING | HttpOnly verification |
| SEC-002 | Cookie not sent over HTTP (only HTTPS) | 🔴 P0 | Stage 1 | ⏳ PENDING | Secure flag verification |
| SEC-003 | Cookie not sent in cross-site requests | 🟡 P1 | Stage 2 | ⏳ PENDING | SameSite=Lax verification |
| SEC-004 | Session ID is random and unpredictable | 🟡 P1 | Stage 1 | ⏳ PENDING | md5(uniqid(rand())) strength |

### Functional Tests

| Test ID | Description | Priority | Stage | Status | Notes |
|---------|-------------|----------|-------|--------|-------|
| FUNC-001 | eyeDesk launches after login | 🔴 P0 | Stage 1 | ⏳ PENDING | Desktop environment |
| FUNC-002 | eyeFiles file operations work | 🔴 P0 | Stage 1 | ⏳ PENDING | AJAX operations |
| FUNC-003 | eyeConsole launches and functions | 🟡 P1 | Stage 1 | ⏳ PENDING | Console app |
| FUNC-004 | Multiple apps can run simultaneously | 🟡 P1 | Stage 2 | ⏳ PENDING | Multi-app session |
| FUNC-005 | File upload works correctly | 🟡 P1 | Stage 2 | ⏳ PENDING | Form POST with cookies |

### Regression Tests

| Test ID | Description | Priority | Stage | Status | Notes |
|---------|-------------|----------|-------|--------|-------|
| REG-001 | Old sessions continue to work | 🔴 P0 | Stage 3 | ⏳ PENDING | Backward compatibility |
| REG-002 | Flash upload fix still works | 🔵 P2 | Stage 2 | ⏳ PENDING | Line 86-87 flash trick |
| REG-003 | API endpoint (?api=1) works | 🟡 P1 | Stage 2 | ⏳ PENDING | XML-RPC with cookies |
| REG-004 | Extern file serving works | 🟡 P1 | Stage 2 | ⏳ PENDING | Line 50-52 extern files |

### Test Environment Setup

**Required:**
1. PHP 7.3+ environment (for setcookie() array syntax)
2. HTTPS server (to test Secure flag)
3. Multiple browsers installed (Chrome, Firefox, Edge)
4. Browser DevTools for cookie inspection

**Test URLs:**
- Production: https://os.pastamp.com
- Staging: (if available)
- Local: https://localhost/os (with self-signed cert)

**Pre-Test Checklist:**
- [ ] Clear all browser cookies for test domain
- [ ] Clear browser cache
- [ ] Disable browser extensions (test in Incognito/Private mode)
- [ ] Open browser DevTools → Application → Cookies before login
- [ ] Document PHP version: `php -v`
- [ ] Document browser version: Check About page

**Test Procedure:**
1. Open browser DevTools (F12) → Application → Cookies
2. Navigate to os.pastamp.com
3. Login with test credentials
4. Verify cookie attributes in DevTools
5. Test session persistence (refresh, navigate, new tab)
6. Test application functionality
7. Logout and verify cookie cleared
8. Document results with screenshots

---

**Remember:** A passing test proves the code works. A failing test proves we found it before the user did! 🎯
