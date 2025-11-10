# Architecture Documentation

## Modular vs Monolithic Comparison

### Before (matrix6.php - Monolithic)
- **Single file**: 657 lines of mixed PHP, HTML, CSS, and JavaScript
- **Tight coupling**: All functionality in one place
- **Hard to maintain**: Changes affect multiple concerns
- **No separation**: Backend and frontend code intertwined
- **Difficult testing**: Can't test components in isolation

### After (matrix6/ - Modular)
- **25+ separate files**: Organized by concern
- **Loose coupling**: Components interact through interfaces
- **Easy maintenance**: Each file has a single responsibility
- **Clear separation**: Backend (PHP), Frontend (JS), Styling (CSS)
- **Testable**: Each component can be tested independently

## Architecture Patterns

### 1. **Command Pattern** (Backend)
Each terminal command is implemented as a separate class implementing `CommandInterface`:

```
CommandInterface
    ├── HelpCommand
    ├── ClearCommand
    ├── EmailCommand
    ├── BashCommand
    └── ...
```

**Benefits:**
- Easy to add new commands without modifying existing code
- Commands are self-contained and reusable
- Follows Open/Closed Principle

### 2. **Router Pattern**
`CommandRouter` dynamically loads and routes commands:

```
User Input → API → CommandRouter → Command Handler → Response
```

**Benefits:**
- Automatic command discovery
- Centralized routing logic
- Easy to extend

### 3. **Module Pattern** (Frontend)
JavaScript organized into functional modules:

```
Terminal.js (main controller)
    ├── Uses: Auth.js
    ├── Uses: Effects.js
    ├── Uses: Portal.js
    └── Uses: Boot.js
```

**Benefits:**
- Encapsulation of functionality
- Reusable components
- Clear dependencies

### 4. **API-First Design**
All client-server communication goes through `api.php`:

```
Frontend (AJAX) ←→ api.php ←→ Backend Logic
```

**Benefits:**
- Single entry point for API requests
- Easy to version and modify
- Can add authentication/rate limiting in one place

## Component Responsibilities

### Configuration Layer
- `config.php`: Centralized configuration
  - System settings
  - Security flags
  - Module paths
  - Branding

### Core Layer
- `CommandInterface.php`: Defines command contract
- `CommandRouter.php`: Routes and executes commands
- `Response.php`: Standardizes HTTP responses

### Command Layer
Each command file handles ONE specific functionality:
- `HelpCommand.php`: Lists available commands
- `EmailCommand.php`: Sends emails
- `BashCommand.php`: Executes shell commands
- etc.

### Auth Layer
- `LoginHandler.php`: Authentication logic
  - Credential verification
  - Session management
  - Password generation

### Presentation Layer (Frontend)

**CSS Modules:**
- `terminal.css`: Core terminal styling
- `animations.css`: Visual effects
- `components.css`: UI elements

**JavaScript Modules:**
- `boot.js`: BIOS boot sequence
- `auth.js`: Login handling
- `effects.js`: Visual effects (matrix rain, glitch)
- `portal.js`: Portal interface
- `terminal.js`: Command processing and display

### API Layer
- `api.php`: RESTful endpoint
  - Handles login/logout
  - Routes commands
  - Manages file uploads
  - Sends emails

## Data Flow Examples

### 1. User Login Flow
```
User enters credentials
    ↓
auth.js sends AJAX request
    ↓
api.php receives login action
    ↓
LoginHandler verifies credentials
    ↓
Session created
    ↓
Response sent to frontend
    ↓
auth.js hides login prompt
    ↓
Terminal interface activated
```

### 2. Command Execution Flow
```
User types command
    ↓
terminal.js captures input
    ↓
AJAX request to api.php
    ↓
CommandRouter loads command handler
    ↓
Command executes and returns output
    ↓
Response formatted and sent
    ↓
terminal.js displays output
```

## Extensibility

### Adding a New Command
1. Create `commands/MyCommand.php`
2. Implement `CommandInterface`
3. No other changes needed - auto-discovered!

### Adding a New CSS Effect
1. Create new CSS file in `assets/css/`
2. Add `<link>` in `index.php`
3. Apply classes in HTML

### Adding a New JS Module
1. Create new JS file in `assets/js/`
2. Add `<script>` in `index.php`
3. Use existing patterns (classes, modules)

## Security Layers

### 1. Configuration Level
```php
define('ENABLE_SHELL_EXEC', false);
define('ENABLE_FILE_UPLOAD', false);
```

### 2. Command Level
Each command validates its own inputs:
```php
class EmailCommand {
    public function execute($params) {
        // Validate email
        if (!filter_var($to, FILTER_VALIDATE_EMAIL)) {
            return "Invalid email";
        }
        // Sanitize inputs
        $subject = htmlspecialchars($params['subject']);
        // ...
    }
}
```

### 3. API Level
```php
// api.php can add:
// - Rate limiting
// - Authentication checks
// - Input validation
// - CSRF protection
```

## Performance Considerations

### What Was Optimized
1. **Separation of Concerns**: Browser only loads needed code
2. **Caching**: Static CSS/JS files can be cached
3. **Lazy Loading**: Commands loaded on-demand
4. **AJAX**: No page reloads for command execution

### Future Optimizations
1. **Minification**: Combine and minify CSS/JS
2. **CDN**: Serve static assets from CDN
3. **Compression**: Enable gzip compression
4. **Caching**: Add Redis for session/command caching

## Testing Strategy

### Unit Testing (Recommended)
```php
// Test individual commands
class EmailCommandTest extends PHPUnit\Framework\TestCase {
    public function testSendEmail() {
        $command = new EmailCommand($config);
        $result = $command->execute([
            'email' => 'test@example.com',
            'subject' => 'Test',
            'body' => 'Test body'
        ]);
        $this->assertStringContains('sent', $result);
    }
}
```

### Integration Testing
```javascript
// Test API endpoints
describe('API Tests', () => {
    it('should login with valid credentials', async () => {
        const response = await fetch('api.php', {
            method: 'POST',
            body: 'action=login&username=3src&password=17'
        });
        const data = await response.json();
        expect(data.success).toBe(true);
    });
});
```

## Migration Guide

### From matrix6.php to Modular Structure

**Step 1**: Set up new structure
```bash
mkdir -p matrix6/{core,commands,auth,assets/{css,js}}
```

**Step 2**: Configure
- Copy config values from old file to `config.php`

**Step 3**: Test
- Deploy to test environment
- Verify all commands work
- Test authentication
- Check visual effects

**Step 4**: Deploy
- Backup old file
- Deploy new structure
- Update web server configuration if needed

## Maintenance Guide

### Common Tasks

**Update Terminal Title:**
```php
// config.php
define('TERMINAL_TITLE', 'New Title');
```

**Disable Shell Execution:**
```php
// config.php
define('ENABLE_SHELL_EXEC', false);
```

**Add New Math Module:**
1. Create module file in `math/`
2. Add constant in `config.php`
3. Create corresponding command in `commands/`

**Change Login Password:**
```php
// config.php
define('TERMINAL_DEFAULT_PRIME', 23); // New prime number
```

## Conclusion

The modular architecture provides:
- ✅ Better organization
- ✅ Easier maintenance
- ✅ Improved testability
- ✅ Enhanced security
- ✅ Better performance
- ✅ Easier collaboration
- ✅ Future-proof design

The small overhead of additional files is vastly outweighed by the benefits of modularity, maintainability, and extensibility.
