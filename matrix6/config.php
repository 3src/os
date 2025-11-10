<?php
/**
 * 3SRC Terminal Configuration
 * Central configuration file for the modular terminal system
 */

// Terminal Configuration
define('TERMINAL_TITLE', '3SRC Terminal Access TA103');
define('TERMINAL_VERSION', '1.0.0');
define('TERMINAL_USERNAME', '3src');
define('TERMINAL_DEFAULT_PRIME', 17);

// Email Configuration
define('EMAIL_FROM', '3src@localhost');

// System Information (BIOS)
define('SYSTEM_VENDOR', '3SRC Camille Roy');
define('SYSTEM_COPYRIGHT', 'Copyright (C) 1980-2025, All Rights Reserved');
define('SYSTEM_AUTHOR', 'Camille Roy - root@linux.locker');
define('SYSTEM_PHONE', '514.895.8636');
define('BIOS_VERSION', '4LIOD v1.0.3 2011-2025');
define('SYSTEM_MEMORY', '160GB');
define('SYSTEM_CPU_COUNT', '24');
define('SYSTEM_CPU_TYPE', '64-bit Processors');
define('SYSTEM_STORAGE', '19.96 Terabytes');
define('SYSTEM_MAX_STORAGE', '1 Zettabyte');

// Math Modules Paths
define('MODULE_ALGEBRA', 'math/Algebra.php');
define('MODULE_ARITHMETIC', 'math/Arithmetic.php');
define('MODULE_FINANCE', 'math/Finance.php');
define('MODULE_SEARCH', 'math/Search.php');
define('MODULE_TRIGONOMETRY', 'math/Trigonometry.php');

// Password Regeneration
define('PASSWORD_REGEN_SCRIPT', 'digineration.php');

// Paths
define('BASE_PATH', __DIR__);
define('CORE_PATH', BASE_PATH . '/core');
define('COMMANDS_PATH', BASE_PATH . '/commands');
define('AUTH_PATH', BASE_PATH . '/auth');
define('ASSETS_PATH', BASE_PATH . '/assets');

// Security Settings
define('ENABLE_SHELL_EXEC', true); // Set to false in production!
define('ENABLE_FILE_UPLOAD', true);
define('MAX_UPLOAD_SIZE', 10 * 1024 * 1024); // 10MB

// Branding
define('BRAND_LOGO_URL', 'https://3src.com/themes/contrib/aristotle/assets/4LIOD.svg');
define('BRAND_LINK_3SRC', 'https://3src.com/cleqc');
define('BRAND_LINK_LOCKER', 'https://linux.locker');

return [
    'terminal' => [
        'title' => TERMINAL_TITLE,
        'version' => TERMINAL_VERSION,
        'username' => TERMINAL_USERNAME,
        'default_prime' => TERMINAL_DEFAULT_PRIME
    ],
    'email' => [
        'from' => EMAIL_FROM
    ],
    'modules' => [
        'algebra' => MODULE_ALGEBRA,
        'arithmetic' => MODULE_ARITHMETIC,
        'finance' => MODULE_FINANCE,
        'search' => MODULE_SEARCH,
        'trigonometry' => MODULE_TRIGONOMETRY
    ],
    'security' => [
        'shell_exec' => ENABLE_SHELL_EXEC,
        'file_upload' => ENABLE_FILE_UPLOAD,
        'max_upload_size' => MAX_UPLOAD_SIZE
    ]
];
