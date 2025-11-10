<?php
/**
 * Bash Command
 * Executes shell commands (if enabled in config)
 */

class BashCommand implements CommandInterface {
    private $config;

    public function __construct($config) {
        $this->config = $config;
    }

    public function getName() {
        return 'bash';
    }

    public function getDescription() {
        return 'Access BASH shell for command execution';
    }

    public function execute($params = []) {
        // If no shell command is provided, return connection message
        if (!isset($params['shell_cmd']) || empty($params['shell_cmd'])) {
            return "ACCESSING BASH SHELL...\nESTABLISHING SECURE CONNECTION...\nCONNECTION ESTABLISHED\n";
        }

        // Check if shell execution is enabled
        if (!$this->config['security']['shell_exec']) {
            return "Shell execution is disabled for security reasons.";
        }

        // Execute shell command
        $cmd = $params['shell_cmd'];

        // Basic command sanitization (WARNING: This is still dangerous in production!)
        // In production, you should use a whitelist of allowed commands
        $output = shell_exec($cmd . " 2>&1");

        if ($output === null) {
            return "Failed to execute command.";
        }

        // Split output into lines and sanitize
        $lines = preg_split('/[\n]/', $output);
        $sanitizedOutput = '';

        foreach ($lines as $line) {
            $sanitizedOutput .= htmlentities($line, ENT_QUOTES | ENT_HTML5, 'UTF-8') . "\n";
        }

        return $sanitizedOutput;
    }
}
