# 3SRC Terminal - Modular Version

A modular, extensible terminal interface built with PHP and JavaScript.

## Project Structure

```
matrix6/
├── config.php                 # Central configuration
├── index.php                  # Main entry point
├── api.php                    # AJAX API endpoint
│
├── core/                      # Core system classes
│   ├── CommandInterface.php   # Command interface definition
│   ├── CommandRouter.php      # Routes commands to handlers
│   └── Response.php           # HTTP response helper
│
├── commands/                  # Command handlers
│   ├── HelpCommand.php        # Display available commands
│   ├── ClearCommand.php       # Clear terminal
│   ├── EmailCommand.php       # Send emails
│   ├── BashCommand.php        # Execute shell commands
│   ├── PortalCommand.php      # Open portal interface
│   ├── FileUploadCommand.php  # Handle file uploads
│   ├── AlgebraCommand.php     # Math module navigation
│   ├── ArithmeticCommand.php  # Math module navigation
│   ├── FinanceCommand.php     # Math module navigation
│   ├── SearchCommand.php      # Search module navigation
│   └── TrigoCommand.php       # Trigonometry module navigation
│
├── auth/                      # Authentication
│   └── LoginHandler.php       # Login/logout handling
│
└── assets/                    # Frontend assets
    ├── css/                   # Stylesheets
    │   ├── terminal.css       # Core terminal styles
    │   ├── animations.css     # Animations & effects
    │   └── components.css     # UI components
    │
    └── js/                    # JavaScript modules
        ├── boot.js            # BIOS boot sequence
        ├── auth.js            # Authentication
        ├── effects.js         # Matrix rain, glitch effects
        ├── portal.js          # Portal interface
        └── terminal.js        # Terminal command processing
```

## Features

### Backend (PHP)
- **Modular Command System**: Each command is a separate class
- **Command Router**: Automatically loads and routes commands
- **Authentication**: Prime number-based login system
- **Configuration**: Centralized config file
- **API Endpoint**: RESTful API for AJAX requests

### Frontend (JavaScript)
- **Terminal Interface**: Interactive command-line interface
- **Matrix Rain Effect**: Animated background
- **BIOS Boot Sequence**: Simulated system initialization
- **Portal Interface**: SHA-1 decryption UI
- **Glitch Effects**: Cyberpunk-style text effects

### Available Commands
- `help` - Display available commands
- `clear` - Clear terminal screen
- `mail` - Send email
- `bash` - Execute shell commands
- `portal` - Open portal interface
- `algebra` - Launch Algebra module
- `arithmetic` - Launch Arithmetic module
- `finance` - Launch Finance module
- `search` - Launch Search module
- `trigo` - Launch Trigonometry module

## Adding New Commands

1. Create a new file in `commands/` directory (e.g., `MyCommand.php`)
2. Implement the `CommandInterface`:

```php
<?php
class MyCommand implements CommandInterface {
    private $config;

    public function __construct($config) {
        $this->config = $config;
    }

    public function getName() {
        return 'mycommand';
    }

    public function getDescription() {
        return 'Description of my command';
    }

    public function execute($params = []) {
        // Command logic here
        return "Command output";
    }
}
```

3. The command will be automatically loaded by the CommandRouter

## Configuration

Edit `config.php` to customize:
- Terminal title and branding
- System specifications (BIOS info)
- Email settings
- Security settings
- Module paths

## Security Notes

⚠️ **WARNING**: This code includes potentially dangerous features:

1. **Shell Execution**: The BashCommand executes arbitrary shell commands
2. **File Upload**: File upload with minimal validation
3. **Hardcoded Password**: Default password is "17"

**For Production:**
- Set `ENABLE_SHELL_EXEC = false` in config
- Implement proper authentication
- Add CSRF protection
- Validate and sanitize all inputs
- Use HTTPS only
- Implement rate limiting

## Installation

1. Copy the `matrix6/` directory to your web server
2. Ensure PHP 7.4+ is installed
3. Configure `config.php` as needed
4. Access `index.php` in your browser
5. Login with username: `3src`, password: `17`

## Dependencies

- PHP 7.4+
- Tailwind CSS (CDN)
- Modern web browser with JavaScript enabled

## Credits

- **phpbash** by Alexander Reid (Arrexel)
- **3SRC Terminal** by HubX
- Built with 4LIOD framework

## License

All Rights Reserved - Copyright (C) 1980-2025
