<?php
/**
 * API Endpoint
 * Handles all AJAX requests from the terminal
 */

// Load configuration
$config = require_once __DIR__ . '/config.php';

// Load core classes
require_once CORE_PATH . '/Response.php';
require_once CORE_PATH . '/CommandRouter.php';
require_once AUTH_PATH . '/LoginHandler.php';

// Handle different actions
$action = $_GET['action'] ?? $_POST['action'] ?? '';

switch ($action) {
    case 'login':
        handleLogin($config);
        break;

    case 'logout':
        handleLogout($config);
        break;

    case 'command':
        handleCommand($config);
        break;

    case 'upload':
        handleFileUpload($config);
        break;

    case 'email':
        handleEmail($config);
        break;

    default:
        Response::error('Invalid action', 400);
}

/**
 * Handle login request
 */
function handleLogin($config) {
    $username = $_POST['username'] ?? '';
    $password = $_POST['password'] ?? '';

    $loginHandler = new LoginHandler($config);
    $result = $loginHandler->handleLogin([
        'username' => $username,
        'password' => $password
    ]);

    Response::json($result);
}

/**
 * Handle logout request
 */
function handleLogout($config) {
    $loginHandler = new LoginHandler($config);
    $loginHandler->logout();
    Response::success('Logged out successfully');
}

/**
 * Handle command execution
 */
function handleCommand($config) {
    $cmd = $_POST['cmd'] ?? '';
    $args = isset($_POST['args']) ? json_decode($_POST['args'], true) : [];
    $fullInput = $_POST['full_input'] ?? '';

    // Special handling for bash commands with shell input
    if ($cmd === 'bash' && !empty($fullInput)) {
        // Extract the actual shell command after 'bash'
        $shellCmd = trim(substr($fullInput, 4)); // Remove 'bash' prefix
        if (!empty($shellCmd)) {
            $args['shell_cmd'] = $shellCmd;
        }
    }

    // Initialize command router
    $router = new CommandRouter($config);

    // Route the command
    $result = $router->route($cmd, $args);

    Response::json($result);
}

/**
 * Handle file upload
 */
function handleFileUpload($config) {
    if (empty($_FILES['file']['tmp_name'])) {
        Response::error('No file uploaded');
    }

    if (empty($_POST['path'])) {
        Response::error('No path specified');
    }

    $router = new CommandRouter($config);
    $result = $router->route('upload', ['path' => $_POST['path']]);

    if ($result['success']) {
        Response::success($result['output']);
    } else {
        Response::error($result['output']);
    }
}

/**
 * Handle email sending
 */
function handleEmail($config) {
    $email = $_POST['email'] ?? '';
    $subject = $_POST['subject'] ?? '';
    $body = $_POST['body'] ?? '';

    $router = new CommandRouter($config);
    $result = $router->route('mail', [
        'email' => $email,
        'subject' => $subject,
        'body' => $body
    ]);

    if ($result['success']) {
        Response::success($result['output']);
    } else {
        Response::error($result['output']);
    }
}
