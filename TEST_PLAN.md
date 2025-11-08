# 3src OS PHP 8 Migration Test Plan

**Critical test requirements for PHP 8+ migration validation**

**Project**: 3src OS (PHP 8+ Migration)
**Maintained by**: 3src (Camille Roy) <robot@pastamp.com>
**Last Updated**: 2025-11-08
**Status**: Test environment pending - all tests deferred

---

## Executive Summary

This document consolidates **critical tests** (P0 priority) that MUST pass before production deployment of PHP 8+ migrated code. These tests are currently deferred due to lack of test environment but are documented here for execution when the environment becomes available.

**Test Coverage**:
- **103 Critical Tests (P0)** - Must pass before production
- **3 Completed Migrations** - PHPMailer, var keywords, XML-RPC
- **5 Testing Stages** - Unit → Integration → System → UAT → Production

**Current Status**: ⏳ ALL TESTS PENDING (no test environment)

---

## Table of Contents

1. [Testing Philosophy](#testing-philosophy)
2. [Critical Tests by Migration](#critical-tests-by-migration)
3. [Test Environment Requirements](#test-environment-requirements)
4. [Test Execution Plan](#test-execution-plan)
5. [Success Criteria](#success-criteria)
6. [Rollback Triggers](#rollback-triggers)

---

## Testing Philosophy

### Why These Tests Matter

Each migration changes core functionality that could:
- **Break existing features** (backward compatibility risk)
- **Introduce subtle bugs** (semantic differences)
- **Cause data loss** (email, files, user data)
- **Break integrations** (mobile, browser, third-party apps)

### Testing Approach

**Priority Levels**:
- 🔴 **P0 (Critical)**: MUST pass before ANY production deployment
- 🟡 **P1 (High)**: SHOULD pass before feature sign-off
- 🔵 **P2 (Medium)**: Test during comprehensive QA
- ⚪ **P3 (Low)**: Nice to have, test opportunistically

**Testing Stages**:
1. **Unit**: Test individual components in isolation
2. **Integration**: Test interactions between components
3. **System**: Full system testing on PHP 8 environment
4. **UAT**: End-user acceptance testing
5. **Production**: Post-deployment monitoring

---

## Critical Tests by Migration

### Migration 1: PHPMailer (38 tests total, 11 critical)

**Completion Date**: 2025-11-08
**Risk Level**: MEDIUM
**Documentation**: PHPMAILER_MIGRATION.md

#### P0 Critical Tests (11)

| Test ID | Description | Why Critical | Test Stage |
|---------|-------------|--------------|------------|
| **EMAIL-001** | Send plain text email | Core functionality - if broken, email system unusable | Stage 1 |
| **EMAIL-002** | Send HTML formatted email | Most emails are HTML - widespread impact | Stage 1 |
| **EMAIL-003** | Send email with single attachment | Attachments heavily used - data loss risk | Stage 1 |
| **EMAIL-005** | Send to single recipient | Core functionality - if broken, no emails sent | Stage 1 |
| **SMTP-001** | SMTP authentication with valid credentials | Without auth, no emails sent | Stage 1 |
| **SMTP-004** | SMTP connection with SSL | Security requirement - most servers use SSL | Stage 1 |
| **ERROR-001** | Exception handling for invalid recipient | Prevents crashes on bad input | Stage 1 |
| **ERROR-002** | Exception handling for SMTP connection failure | Network failures are common - must handle gracefully | Stage 1 |
| **ERROR-003** | Exception handling for authentication failure | Auth failures are common - must handle gracefully | Stage 1 |
| **INT-001** | Composer autoloader loads correctly | If autoloader fails, PHPMailer won't load at all | Stage 1 |
| **INT-003** | Email functionality in eyeMail app UI | End-to-end integration - user-facing feature | Stage 2 |

**Test Execution Priority**: HIGH (email is critical functionality)

**Success Criteria**:
- All 11 P0 tests must pass
- No exceptions or fatal errors during email send
- Sent emails appear in recipient inbox
- Sent emails saved to Sent folder

**Rollback Trigger**:
- Any P0 test fails
- Silent email failures (no errors but email not sent)
- Data loss (emails not saved to Sent folder)

---

### Migration 2: var Keywords (32 tests total, 13 critical)

**Completion Date**: 2025-11-08
**Risk Level**: LOW
**Documentation**: VAR_KEYWORD_MIGRATION.md

#### P0 Critical Tests (13)

| Test ID | Description | Why Critical | Test Stage |
|---------|-------------|--------------|------------|
| **VAR-001** | Instantiate Button widget | Most common widget - widespread use | Stage 1 |
| **VAR-002** | Instantiate Window widget | Container for all widgets - if broken, UI unusable | Stage 1 |
| **VAR-003** | Instantiate Textbox widget | Common input widget - forms broken if fails | Stage 1 |
| **VAR-004** | Instantiate Calendar widget | Had whitespace issues - high-risk file | Stage 1 |
| **VAR-005** | Instantiate all 33 widget types | Comprehensive widget validation | Stage 1 |
| **VAR-006** | Read public properties from outside class | Core API - if broken, widgets unusable | Stage 1 |
| **VAR-007** | Write public properties from outside class | Core API - dynamic properties heavily used | Stage 1 |
| **VAR-010** | Verify no visibility violations | Ensures no accidental private/protected | Stage 2 |
| **VAR-011** | Render Button widget | Visual rendering test - UI functionality | Stage 2 |
| **VAR-012** | Render Window with child widgets | Container rendering - complex UI test | Stage 2 |
| **VAR-016** | eyeFeeds: RSS feed parsing | 210 var replacements - high-risk app | Stage 2 |
| **VAR-019** | All three apps launch successfully | Integration test - app loading | Stage 2 |
| **VAR-028** | No PHP deprecation warnings | Ensures all var keywords actually replaced | Stage 1 |
| **VAR-029** | No fatal errors on widget creation | Smoke test - basic functionality | Stage 1 |
| **VAR-030** | Desktop environment loads | Full integration - user-facing feature | Stage 2 |

**Test Execution Priority**: MEDIUM (syntax-only changes, low risk)

**Success Criteria**:
- All widgets instantiate without errors
- Properties remain publicly accessible
- No E_DEPRECATED warnings in error log
- Desktop UI renders correctly

**Rollback Trigger**:
- Any widget fails to instantiate
- Property access violations
- Desktop fails to load

---

### Migration 3: XML-RPC Library (33 tests total, 14 critical)

**Completion Date**: 2025-11-08
**Risk Level**: HIGH
**Documentation**: XMLRPC_MIGRATION.md

#### P0 Critical Tests (14)

| Test ID | Description | Why Critical | Test Stage |
|---------|-------------|--------------|------------|
| **XMLRPC-001** | XML-RPC server starts successfully | If server doesn't start, API completely broken | Stage 1 |
| **XMLRPC-002** | Server loads dispatch map from config.xml | Without dispatch map, no methods registered | Stage 1 |
| **XMLRPC-003** | Server registers service methods | Core functionality - service calls | Stage 1 |
| **XMLRPC-004** | Server registers lib methods | Core functionality - library calls | Stage 1 |
| **XMLRPC-006** | Call service method with authentication | End-to-end service call test | Stage 1 |
| **XMLRPC-007** | Call lib method with authentication | End-to-end library call test | Stage 1 |
| **XMLRPC-011** | Encode/decode integer values | Basic data type - used in all API calls | Stage 1 |
| **XMLRPC-012** | Encode/decode string values | Most common data type - widespread use | Stage 1 |
| **XMLRPC-015** | Encode/decode arrays | Fixed each() in line 3469 - HIGH RISK | Stage 1 |
| **XMLRPC-016** | Encode/decode structs | Fixed structeach() method - HIGH RISK | Stage 1 |
| **XMLRPC-020** | Create xmlrpcresp with success value | Response creation - fixed __construct | Stage 1 |
| **XMLRPC-023** | Create xmlrpcval with various types | Value creation - fixed __construct | Stage 1 |
| **XMLRPC-025** | Create xmlrpc_server instance | Server creation - fixed __construct | Stage 1 |
| **XMLRPC-026** | Browser interface XML-RPC calls | User-facing feature - web interface | Stage 2 |
| **XMLRPC-027** | Mobile interface XML-RPC calls | User-facing feature - mobile interface | Stage 2 |
| **XMLRPC-030** | No PHP warnings or deprecations | Ensures all each() calls fixed | Stage 1 |
| **XMLRPC-031** | No fatal errors on server startup | Smoke test - basic functionality | Stage 1 |
| **XMLRPC-032** | Existing API clients still work | Backward compatibility - critical for integrations | Stage 2 |

**Test Execution Priority**: CRITICAL (API is core infrastructure)

**Success Criteria**:
- XML-RPC server starts without errors
- All method calls succeed with correct data types
- No fatal errors, warnings, or deprecations
- Browser and mobile interfaces functional
- Third-party integrations work

**Rollback Trigger**:
- Server fails to start
- Any P0 test fails
- Data corruption in struct/array encoding
- Third-party integrations broken

---

## Test Environment Requirements

### Minimum Requirements

**PHP Environment**:
- PHP 8.0, 8.1, or 8.2 (test on all three)
- All required extensions (xml, mbstring, curl, sqlite, gd)
- Composer installed
- Error logging enabled (error_reporting = E_ALL)

**Web Server**:
- Apache or Nginx
- mod_rewrite enabled
- .htaccess support (Apache) or equivalent (Nginx)

**Database**:
- SQLite (default) or MySQL
- Test database with sample data

**Test Data**:
- Test user accounts (at least 3)
- Test emails (at least 10 different scenarios)
- Test files (various types and sizes)
- Test XML-RPC clients (browser, mobile, third-party)

### Ideal Test Environment

**Multiple PHP Versions**:
- PHP 7.4 (baseline compatibility)
- PHP 8.0 (target minimum)
- PHP 8.1 (current stable)
- PHP 8.2 (latest stable)
- PHP 8.3 (future-proofing)

**Test Scenarios**:
- Fresh installation (no data)
- Upgrade from existing installation
- With sample data (users, emails, files)
- High load (concurrent users)

---

## Test Execution Plan

### Phase 1: Unit Testing (Week 1-2)

**Goal**: Validate individual components work correctly

**Tests to Execute**:
1. All P0 Stage 1 tests (38 total)
2. Selected P1 Stage 1 tests (15 total)

**Execution Order**:
1. var keyword tests (lowest risk, quick validation)
2. PHPMailer tests (medium risk, high impact)
3. XML-RPC tests (highest risk, critical infrastructure)

**Success Criteria**: 90%+ of P0 tests pass

### Phase 2: Integration Testing (Week 3-4)

**Goal**: Validate components work together

**Tests to Execute**:
1. All P0 Stage 2 tests (28 total)
2. Cross-component integration tests

**Execution Order**:
1. Widget rendering with desktop environment
2. Email integration with apps (eyeMail)
3. XML-RPC integration with browser/mobile

**Success Criteria**: 100% of P0 tests pass, 85%+ of P1 tests pass

### Phase 3: System Testing (Week 5-6)

**Goal**: Full system validation on PHP 8

**Tests to Execute**:
1. All remaining tests (P2, P3)
2. Performance testing
3. Load testing
4. Security testing

**Success Criteria**: No critical bugs, acceptable performance

### Phase 4: User Acceptance Testing (Week 7-8)

**Goal**: Real-world usage validation

**Tests to Execute**:
1. End-user workflows
2. Common use cases
3. Edge cases

**Success Criteria**: User sign-off

### Phase 5: Production Deployment (Week 9)

**Goal**: Safe production rollout

**Approach**:
1. Deploy to staging (identical to production)
2. Run smoke tests
3. Gradual rollout (10% → 50% → 100% of users)
4. Monitor error logs
5. Be ready to rollback

---

## Success Criteria

### Overall Success Criteria

For the migration to be considered **successful**:

✅ **Critical Tests**: 100% of P0 tests pass (38 tests)
✅ **High Priority Tests**: 90%+ of P1 tests pass
✅ **No Regressions**: No existing functionality broken
✅ **No Errors**: No fatal errors, warnings, or deprecations in PHP 8
✅ **Performance**: No performance degradation (or improvement)
✅ **User Acceptance**: End users confirm system works as expected

### Per-Migration Success Criteria

**PHPMailer**:
- Emails send successfully
- Attachments work
- No data loss

**var Keywords**:
- All widgets work
- Desktop loads
- No property access violations

**XML-RPC**:
- API calls work
- Browser/mobile interfaces functional
- Third-party integrations work

---

## Rollback Triggers

### Immediate Rollback (No Discussion)

Rollback immediately if:

🚨 **Data Loss**: Emails not sent, files corrupted, user data lost
🚨 **Fatal Errors**: PHP fatal errors preventing system use
🚨 **Security Breach**: New vulnerabilities introduced
🚨 **Complete Failure**: Core functionality completely broken

### Consider Rollback (Team Discussion)

Consider rollback if:

⚠️ **Multiple P0 Failures**: More than 3 P0 tests fail
⚠️ **Critical Bugs**: Severe bugs affecting many users
⚠️ **Performance Degradation**: System becomes unusably slow
⚠️ **Integration Breakage**: Third-party integrations broken

### Fix Forward (Preferred)

Fix forward if:

✅ **Minor Failures**: Only P1/P2/P3 tests fail
✅ **Known Workarounds**: Issues have documented workarounds
✅ **Limited Impact**: Issues affect small subset of users
✅ **Quick Fixes**: Issues can be fixed within 24 hours

---

## Test Tracking

### Test Status Dashboard

Current test execution status (updated manually):

```
PHPMailer Tests:    ⏳ 0/11 P0 tests completed (0%)
var Keyword Tests:  ⏳ 0/13 P0 tests completed (0%)
XML-RPC Tests:      ⏳ 0/14 P0 tests completed (0%)

Overall P0 Tests:   ⏳ 0/38 completed (0%)
```

**Last Test Run**: Never (no test environment)
**Next Test Run**: TBD (environment setup pending)

### Test Results Log

When tests are executed, results will be logged here:

**Format**:
```
[YYYY-MM-DD HH:MM] TEST-ID: STATUS - Notes
```

**Example**:
```
[2025-11-15 10:30] EMAIL-001: ✅ PASSED - Plain text email sent successfully
[2025-11-15 10:31] EMAIL-002: ✅ PASSED - HTML email rendered correctly
[2025-11-15 10:32] EMAIL-003: ❌ FAILED - Attachment not sent (bug #123)
```

---

## Next Steps

### Immediate (Before Testing)

1. ✅ Document all critical tests (this document)
2. ⏳ Set up PHP 8 test environment
3. ⏳ Prepare test data (users, emails, files)
4. ⏳ Install migrated codebase on test environment
5. ⏳ Configure error logging

### During Testing

1. Execute P0 tests systematically
2. Log all results
3. File bugs for failures
4. Fix critical issues immediately
5. Retest after fixes

### After Testing

1. Update test status dashboard
2. Generate test report
3. Get stakeholder sign-off
4. Plan production deployment
5. Prepare rollback procedures

---

## Conclusion

This test plan consolidates **38 critical tests** across 3 completed migrations. All tests are currently **deferred** due to lack of test environment.

**When test environment is available**:
1. Execute tests in order (var → PHPMailer → XML-RPC)
2. Achieve 100% P0 test pass rate
3. Fix any failures immediately
4. Get stakeholder sign-off
5. Deploy to production with confidence

**Risk Mitigation**:
- All changes documented
- Rollback procedures defined
- Success criteria clear
- Test coverage comprehensive

---

**Related Documentation**:
- [TESTING_JOURNAL.md](TESTING_JOURNAL.md) - Complete test catalog (100+ tests)
- [PHPMAILER_MIGRATION.md](PHPMAILER_MIGRATION.md) - PHPMailer migration details
- [VAR_KEYWORD_MIGRATION.md](VAR_KEYWORD_MIGRATION.md) - var keyword migration details
- [XMLRPC_MIGRATION.md](XMLRPC_MIGRATION.md) - XML-RPC migration details
- [MIGRATION_STATUS.md](docs/MIGRATION_STATUS.md) - Overall migration status
