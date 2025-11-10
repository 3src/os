<?php
/**
 * 3SRC Terminal - Modular Version
 * Main entry point
 */

// Load configuration
$config = require_once __DIR__ . '/config.php';
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo TERMINAL_TITLE; ?> - Enhanced</title>

    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>

    <!-- Custom Stylesheets -->
    <link rel="stylesheet" href="assets/css/terminal.css">
    <link rel="stylesheet" href="assets/css/animations.css">
    <link rel="stylesheet" href="assets/css/components.css">
</head>
<body class="bg-black text-green-500 p-4">

    <!-- BIOS Boot Screen -->
    <div id="bios-screen" class="bios-screen">
        <h1><?php echo SYSTEM_VENDOR; ?></h1>
        <p><?php echo SYSTEM_COPYRIGHT; ?></p>
        <p><?php echo SYSTEM_AUTHOR; ?></p>
        <p><?php echo SYSTEM_PHONE; ?></p>
        <p>BIOS: <?php echo BIOS_VERSION; ?></p>
        <p>Initializing USB Controllers .. Done</p>
        <p>Initializing DVD Devices .. Done</p>
        <p>Internet Keyboard Detected</p>
        <p>Detecting Internet Drives ...</p>
        <p>Memory Testing: <?php echo SYSTEM_MEMORY; ?> OK</p>
        <p>Memory Map Passed - ECC Verified</p>
        <p>CPU Detected: <?php echo SYSTEM_CPU_COUNT; ?> x <?php echo SYSTEM_CPU_TYPE; ?></p>
        <p>-> 8 Multi-threaded CPU found</p>
        <p>Hyperthreading Technology - Enabled</p>
        <p>VT-x Virtualization - Enabled</p>
        <p>NX Bit - Enabled</p>
        <p>AHCI Controller Initialized - 4 Channels Active</p>
        <p>ZFS File System Found</p>
        <p>Detected Storage: <?php echo SYSTEM_STORAGE; ?></p>
        <p>Maximum <?php echo SYSTEM_MAX_STORAGE; ?> File System Ready</p>
        <p>USB Legacy Support - Enabled</p>
        <p>PXE Boot Agent - Enabled</p>
        <p>DVD Boot Agent - Enabled</p>
        <p>Internet Boot Agent - Enabled</p>
        <p>Initializing Bootloader ...</p>
        <p>Booting from Internet Device ...</p>
    </div>

    <!-- Login Prompt -->
    <div id="login-prompt" class="login-prompt" style="display: none;">
        <p>Login to <?php echo TERMINAL_TITLE; ?></p>
        <input type="text" id="username" placeholder="Username">
        <input type="password" id="password" placeholder="Password">
        <button onclick="login()">Login</button>
    </div>

    <!-- Matrix rain effect -->
    <canvas id="matrix-rain" class="matrix-rain"></canvas>

    <!-- Teleportation Portal -->
    <div id="portal" class="portal" style="display: none;">
        <div class="p-4">
            <input
                type="text"
                id="entity-input"
                class="w-full bg-transparent border-none outline-none text-blue-500"
                placeholder="entity"
                autocomplete="off"
            >
            <input
                type="text"
                id="sha1-input"
                class="w-full bg-transparent border-none outline-none text-blue-500 mt-2"
                placeholder="Secure Hash Algorithm 1"
                autocomplete="off"
                maxlength="40"
            >
            <p class="text-xs text-blue-500 mt-2">160-bit hash – 40 hexadecimal digits.</p>
            <button
                class="w-full bg-blue-500 text-black mt-4 py-1 rounded"
                onclick="decrypt()"
            >
                Decrypt
            </button>
        </div>
    </div>

    <div class="container mx-auto max-w-4xl">
        <!-- Header with glitch effect -->
        <div class="glitch mb-6" data-text="<?php echo TERMINAL_TITLE; ?>">
            <h1 class="text-3xl font-bold text-blue-500"><?php echo TERMINAL_TITLE; ?></h1>
        </div>

        <div class="border border-green-500 rounded p-4 bg-black bg-opacity-80">
            <!-- Command history -->
            <div id="command-history" class="command-history mb-4">
                <div class="matrix-text">
                    <p>SYSTEM INITIALIZED...</p>
                    <p>CONNECTING TO MAINFRAME...</p>
                    <p class="typing-animation">ACCESS GRANTED</p>
                    <p>> Welcome to the <?php echo TERMINAL_TITLE; ?> interface.</p>
                    <p>> Type 'help' for available commands.</p>
                    <p>> </p>
                </div>
            </div>

            <!-- Command input -->
            <div class="flex items-center">
                <span id="prompt" class="matrix-text mr-2">></span>
                <input
                    type="text"
                    id="command-input"
                    class="flex-1 bg-transparent border-none outline-none matrix-text"
                    autocomplete="off"
                    spellcheck="false"
                    autofocus
                >
                <span id="cursor" class="cursor"></span>
            </div>
        </div>

        <div class="mt-4 text-xs matrix-text opacity-70">
            <p>WARNING: Unauthorized access is prohibited. All activity is monitored.</p>
        </div>
    </div>

    <!-- Branding Footer -->
    <p style="border-radius: 8px; text-align: center; font-size: 12px; color: #fff; margin-top: 16px; position: fixed; left: 8px; bottom: 8px; z-index: 10; background: rgba(0,0,0,0.8); padding: 4px 8px;">
        Made with <img src="<?php echo BRAND_LOGO_URL; ?>" alt="4LIOD Logo" style="width: 36px; height: 36px; vertical-align: middle; margin-right:3px; filter:brightness(0) invert(1);">
        <a href="<?php echo BRAND_LINK_3SRC; ?>" style="color: #fff; text-decoration: underline;" target="_blank">3SRC</a> - 🧬
        <a href="<?php echo BRAND_LINK_LOCKER; ?>" style="color: #fff; text-decoration: underline;" target="_blank">Locker Linux</a>
    </p>

    <!-- JavaScript Modules -->
    <script src="assets/js/boot.js"></script>
    <script src="assets/js/auth.js"></script>
    <script src="assets/js/effects.js"></script>
    <script src="assets/js/portal.js"></script>
    <script src="assets/js/terminal.js"></script>
</body>
</html>
