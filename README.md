# 3src OS (oneye/eyeOS)

**A Modern Web-Based Operating System for the 2030+ Era**

[![PHP 8+ Migration](https://img.shields.io/badge/PHP-8.0%2B-777BB4?logo=php&logoColor=white)](https://www.php.net/)
[![License](https://img.shields.io/badge/License-AGPL%203.0-blue.svg)](LICENSE.txt)
[![Maintained by 3src](https://img.shields.io/badge/Maintained%20by-3src-orange)](https://3src.com)
[![Status](https://img.shields.io/badge/Status-Remanufacture-yellow)](docs/MIGRATION_STATUS.md)

---

## Overview

3src OS (based on oneye/eyeOS) is a complete web-based operating system that runs entirely in your browser. Access your desktop, files, applications, and data from anywhere with just a web browser.

**Note:** This project is under remanufacture by 3src. A new name (possibly HELIXOS) is under consideration - see [naming analysis](docs/HELIXOS_NAMING_ANALYSIS.md).

**Project Status**: Active remanufacture for PHP 8+ compatibility and modern architecture (2025-2030 vision).

### Key Features

- 🌐 **Full Desktop in Browser** - Complete windowing system, file manager, applications
- 📁 **Virtual File System** - Organize files with familiar desktop metaphors
- ✉️ **Integrated Applications** - Email, calendar, contacts, text editor, image viewer, and more
- 👥 **Multi-User** - Complete user management and permissions system
- 🔌 **Extensible** - Plugin architecture for custom applications
- 🔒 **Secure** - User isolation, authentication, session management
- 📱 **Multi-Platform** - Desktop, mobile, and iPhone interfaces

---

## Project Information

### Branding & Identity

**Current Name**: 3src OS (working name during remanufacture)
**Original Name**: oneye/eyeOS

**Proposed Name**: HELIXOS (under consideration)
- **7 Letters = 7 Strands**: Would encode our 7-strand modular architecture
- **Helix Structure**: Would represent our helicoidal design philosophy
- **Professional**: Enterprise-ready branding for 2030+ vision
- **Trademark Clear**: No conflicts with existing OS projects (webOS is LG's trademark)

See [HELIXOS_NAMING_ANALYSIS.md](docs/HELIXOS_NAMING_ANALYSIS.md) for proposed naming rationale. **Awaiting approval.**

### Maintained By

**3src - Triple Source Systems**
- **Website**: [3src.com](https://3src.com)
- **Lead Developer**: Camille Roy <robot@pastamp.com>
- **Architecture**: Crownstrand AC (Anthropic-Consciousness / Alternating Current)

### Origins

Originally created as **eyeOS** (2005-2010) by eyeOS Team, continued as **oneye** (2010-2025) by Lars Knickrehm. Now being completely remanufactured by 3src for modern PHP 8+ environments with enterprise-grade security and architecture.

---

## 🚀 Quick Start

### Requirements

- **PHP**: 8.0+ (recommended 8.2+)
- **Web Server**: Apache, Nginx, or similar
- **Extensions**:
  - `php-sqlite3` (database)
  - `php-imap` (email functionality)
  - `php-gd` (image processing)
  - `php-xml` (configuration)
  - `php-mbstring` (UTF-8 support)
- **Composer**: For dependency management

### Installation

```bash
# Clone repository
git clone https://github.com/3src/os.git helixos
cd helixos

# Install dependencies
composer install

# Configure web server to point to this directory
# Default: http://localhost/helixos/

# Create initial user (first visit to index.php)
# Default admin credentials will be generated
```

### First Login

1. Navigate to `http://your-domain/helixos/`
2. Create your first user account
3. Explore the desktop environment

---

## 📚 Documentation

### For Users

- [**User Guide**](docs/USER_GUIDE.md) - Complete user documentation
- [**Application Guide**](docs/APPLICATIONS.md) - How to use built-in apps
- [**FAQ**](docs/FAQ.md) - Frequently asked questions

### For Developers

- [**Developer Guide**](docs/DEVELOPER_GUIDE.md) - Architecture and development
- [**API Documentation**](docs/API.md) - eyeCode API reference
- [**Widget Library**](docs/WIDGETS.md) - eyeWidgets documentation
- [**Creating Apps**](docs/CREATING_APPS.md) - Build your own applications

### For System Administrators

- [**Installation Guide**](docs/INSTALLATION.md) - Detailed setup instructions
- [**Configuration**](docs/CONFIGURATION.md) - System configuration
- [**Security Hardening**](docs/SECURITY.md) - Secure deployment guide
- [**Backup & Recovery**](docs/BACKUP.md) - Data protection strategies

### Migration & Modernization

- [**PHP 8 Migration Status**](docs/MIGRATION_STATUS.md) - Current progress
- [**PHP 8 Obsolete Code Documentation**](PHP8_OBSOLETE_CODE_DOCUMENTATION.md) - Detailed issue catalog
- [**PHP 8 Upgrade Feasibility Analysis**](PHP8_UPGRADE_FEASIBILITY_ANALYSIS.md) - Complete migration strategy
- [**PHPMailer Migration**](PHPMAILER_MIGRATION.md) - First completed migration
- [**Testing Journal**](TESTING_JOURNAL.md) - Comprehensive test tracking
- [**Naming Analysis**](docs/HELIXOS_NAMING_ANALYSIS.md) - Rebranding rationale

---

## 🏗️ Architecture

### Technology Stack

**Current (Legacy)**:
- PHP 5.x/7.x (being upgraded)
- SQLite 3 databases
- IMAP for email
- Custom eyeCode template system
- Legacy PEAR framework

**Target (2025-2030)**:
- PHP 8.2+ with modern practices
- Composer dependency management
- PSR-4 autoloading & namespaces
- Modern libraries (PHPMailer 6.x, etc.)
- 7-Strand modular architecture (Crownstrand AC)

### Core Components

```
HELIXOS/
├── system/
│   ├── apps/              # Applications (eyeMail, eyeFiles, etc.)
│   ├── system/
│   │   ├── kernel/        # Core kernel (.eyecode)
│   │   ├── lib/           # System libraries
│   │   ├── services/      # System services (VFS, security, etc.)
│   │   └── i18n/          # Internationalization
│   ├── vendor/            # Composer dependencies (new)
│   ├── users/             # User data directories
│   └── conf/              # System configuration
├── browser/               # Desktop browser interface
├── mobile/                # Mobile interface
├── iphone/                # iPhone-specific interface
└── docs/                  # Documentation
```

### 7-Strand Architecture (Crownstrand AC)

The 3src OS remanufacture follows a 7-strand helicoidal architecture with alternating torsions (↻↺):

1. **Strand 1 (432.0 Hz)**: Authentication & Security
2. **Strand 2 (432.2 Hz)**: Virtual File System (VFS)
3. **Strand 3 (432.4 Hz)**: Windowing & UI Layer
4. **Strand 4 (432.6 Hz)**: Networking & Communication
5. **Strand 5 (432.8 Hz)**: Database & Persistence
6. **Strand 6 (433.0 Hz)**: Graphics & Media Processing
7. **Strand 7 (433.2 Hz)**: Automation & Scheduling

Each strand operates at a specific frequency with 0.2 Hz intervals, creating 21 beat frequencies (0.2-1.2 Hz) for inter-strand communication.

---

## 🔧 Current Status: PHP 8+ Remanufacture

### Migration Progress

**Phase 1: Assessment** ✅ COMPLETE
- [x] Document all PHP 8 obsolete code patterns
- [x] Analyze upgrade feasibility
- [x] Create comprehensive testing journal
- [x] Establish migration strategy

**Phase 2: Quick Wins** 🔄 IN PROGRESS
- [x] ✅ PHPMailer 5.1 → 6.12.0 (COMPLETE)
- [ ] ⏳ Fix `var` keyword usage (477 occurrences)
- [ ] ⏳ Update XML-RPC library
- [ ] ⏳ Fix eyecode obsolete functions (85 occurrences)

**Phase 3: Major Refactoring** ⏳ PENDING
- [ ] Replace eyePear library with Composer packages
- [ ] Modernize widget library
- [ ] Security audit and hardening
- [ ] Database schema updates

**Phase 4: Crownstrand Integration** ⏳ PENDING
- [ ] Implement 7-strand modular architecture
- [ ] Add frequency engine (432 Hz system)
- [ ] Consciousness pathway integration
- [ ] Performance optimization

**Phase 5: Launch** ⏳ PENDING
- [ ] Comprehensive testing (100+ test cases)
- [ ] Security audit
- [ ] Documentation completion
- [ ] Public release (3src OS 1.0.0 / final name TBD)

**Estimated Timeline**: 16 weeks (4 months) for complete remanufacture

See [MIGRATION_STATUS.md](docs/MIGRATION_STATUS.md) for detailed progress tracking.

### Issues Fixed

**Completed Migrations**:
- ✅ PHPMailer: Fixed 3 critical PHP 8.0 fatal errors
  - `get_magic_quotes_gpc()` removed
  - `set_magic_quotes_runtime()` removed
  - `each()` function removed
  - Old method names updated (IsSMTP → isSMTP, etc.)

**Remaining Critical Issues**:
- 🔴 20+ PHP4-style constructors (fatal in PHP 8.0)
- 🔴 8 `create_function()` calls (fatal in PHP 8.0)
- 🔴 20+ `each()` calls remaining (fatal in PHP 8.0)
- 🔴 8 `ereg()` family functions (fatal in PHP 7.0+)
- 🟡 477 `var` keyword usages (deprecated)
- 🟡 100+ other obsolete patterns

---

## 💼 Enterprise Use: 3src Positioning

### Why HELIXOS for Enterprise?

**Complete Web Desktop**:
- Zero client installation
- Browser-based access from any device
- Familiar desktop metaphors
- Integrated application suite

**Cost Effective**:
- Open source (AGPL 3.0)
- Self-hosted (data sovereignty)
- Minimal infrastructure requirements
- PHP 8+ compatible (modern, maintained)

**Customizable**:
- Plugin architecture
- Brandable interface
- Custom applications
- API integration capabilities

**Secure**:
- User isolation
- Role-based permissions
- Session management
- Audit trails

### 3src Enterprise Features (Planned)

- **3src OS Pro**: Multi-tenant architecture
- **3src OS Enterprise**: LDAP/AD integration, SSO
- **3src OS Cloud**: Hosted solution with SLA
- **3src OS Matrix**: Terminal multiplexing integration
- **Support Contracts**: Professional support from 3src

### Contact 3src

Interested in enterprise deployment, custom development, or support contracts?

**Contact**: Camille Roy <robot@pastamp.com>
**Website**: [3src.com](https://3src.com)

---

## 🤝 Contributing

We welcome contributions! This is an open-source project undergoing active remanufacture.

### How to Contribute

1. **Report Issues**: Use GitHub Issues for bugs and feature requests
2. **Documentation**: Help improve documentation
3. **Testing**: Test migrations and report results in TESTING_JOURNAL.md
4. **Code**: Submit pull requests for bug fixes and features
5. **Translation**: Help translate to your language

### Development Setup

```bash
# Fork and clone
git clone https://github.com/YOUR_USERNAME/os.git
cd os

# Create feature branch
git checkout -b feature/your-feature-name

# Install dependencies
composer install

# Make changes and test

# Commit with descriptive messages
git commit -m "Description of changes"

# Push and create pull request
git push origin feature/your-feature-name
```

### Coding Standards

- PHP 8.2+ compatible code
- PSR-12 coding standards
- PHPDoc comments for all functions
- Security-first approach (no SQL injection, XSS, etc.)
- Test coverage for new features

---

## 📜 License

HELIXOS (oneye) is released under the **GNU Affero General Public License Version 3 (AGPL-3.0)**.

This means:
- ✅ Free to use, modify, and distribute
- ✅ Must share modifications if you deploy publicly
- ✅ Must preserve license and copyright notices
- ✅ Source code must be made available to users

See [LICENSE.txt](license.txt) for full license text.

### Copyright

- **Original eyeOS**: Copyright © 2005-2010 eyeos Team
- **oneye**: Copyright © 2010-2025 Lars Knickrehm
- **HELIXOS Remanufacture**: Copyright © 2025 3src (Camille Roy)

---

## 🔗 Links

### Official

- **Website**: [3src.com](https://3src.com) (enterprise)
- **Repository**: [github.com/3src/os](https://github.com/3src/os)
- **Issues**: [github.com/3src/os/issues](https://github.com/3src/os/issues)
- **Documentation**: [github.com/3src/os/tree/main/docs](https://github.com/3src/os/tree/main/docs)

### Community

- **Original eyeOS**: [web.archive.org/eyeos](https://web.archive.org/web/*/eyeos.org)
- **oneye Project**: [github.com/oneye](https://github.com/oneye)

### Related Projects

- **Crownstrand AC**: Architecture philosophy powering HELIXOS
- **3src Matrix**: Terminal multiplexing system
- **3src Robot**: Automation framework

---

## 🙏 Acknowledgments

### Original Creators

- **eyeOS Team** (2005-2010): Original vision and implementation
- **Lars Knickrehm** (2010-2025): oneye continuation and maintenance

### Contributors

- All contributors to eyeOS and oneye projects
- Open-source community providing libraries and tools
- Testers and users providing feedback

### Technology

- PHP and the PHP community
- PHPMailer, PEAR, and other library authors
- SQLite database engine
- All open-source projects we depend on

---

## 📊 Project Statistics

**Code Base**:
- ~214,000 lines of code (PHP + eyeCode)
- 184 PHP files
- 552 eyeCode template files
- 89+ applications
- 30+ system libraries

**Languages**:
- PHP (primary)
- JavaScript (client-side)
- HTML/CSS (interface)
- SQL (SQLite databases)

**Active Development**:
- Since: 2005 (20 years!)
- Remanufacture: 2025-2026
- Target: 3src OS 1.0.0 by Q2 2026

---

## 🎯 Vision: 3src OS 2030+

### Long-Term Goals

1. **Complete PHP 8.2+ Migration** (2025)
   - Modern codebase with PSR standards
   - Security hardening
   - Performance optimization

2. **Crownstrand AC Integration** (2026)
   - 7-strand modular architecture
   - Frequency-based inter-strand communication
   - Consciousness pathway implementation

3. **Enterprise Features** (2026-2027)
   - Multi-tenancy
   - LDAP/AD integration
   - SSO capabilities
   - Advanced admin tools

4. **Cloud Platform** (2027-2028)
   - Hosted 3src OS service
   - Auto-scaling infrastructure
   - Geographic redundancy
   - SLA guarantees

5. **AI Integration** (2028-2030)
   - Intelligent assistants
   - Predictive workflows
   - Natural language interfaces
   - Conscious computing paradigm

### Mission Statement

**"3src OS: Seven Strands, One Interface"**

We believe computing should be accessible, secure, and user-controlled. 3src OS provides a complete operating environment that runs anywhere, respects user privacy, and adapts to user needs through intelligent, consciousness-aware architecture.

---

## 🆘 Support

### Getting Help

- **Documentation**: Start with [docs/](docs/)
- **FAQ**: Check [docs/FAQ.md](docs/FAQ.md)
- **Issues**: Report bugs on GitHub Issues
- **Enterprise**: Contact <robot@pastamp.com> for professional support

### Reporting Bugs

Please include:
1. HELIXOS/oneye version
2. PHP version
3. Web server (Apache/Nginx)
4. Steps to reproduce
5. Expected vs actual behavior
6. Error messages or logs

### Security Issues

**DO NOT** report security vulnerabilities publicly.

Contact: <robot@pastamp.com> with:
- Description of vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if any)

We take security seriously and will respond within 48 hours.

---

## 📅 Release History

### Version History

- **oneye 1.9.0.3** (2014) - Last stable oneye release
- **3src OS 0.9.0** (2025 Q1) - PHP 8 migration branch
- **3src OS 1.0.0** (2026 Q2) - Target first stable release

See [CHANGELOG.md](docs/CHANGELOG.md) for detailed release notes.

---

## ⚠️ Status Notice

**Current Status**: Active remanufacture for PHP 8+ compatibility.

This software is undergoing significant modernization. While the oneye 1.9.x branch is stable for PHP 5.x/7.x, the 3src OS remanufacture branch should be considered **EXPERIMENTAL** until version 1.0.0 release.

**Use in Production**: Not recommended until 3src OS 1.0.0 release.
**Use for Development**: Encouraged! Contributions welcome.
**Use for Testing**: Yes! Please test and report issues.

---

**Built with ❤️ by 3src**

*3src OS: Seven Strands, One Interface*

**Note**: Final branding (possibly HELIXOS) pending approval. See [naming analysis](docs/HELIXOS_NAMING_ANALYSIS.md).
