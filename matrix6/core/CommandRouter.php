<?php
/**
 * Command Router
 * Routes commands to their respective handlers
 */

require_once __DIR__ . '/CommandInterface.php';
require_once __DIR__ . '/Response.php';

class CommandRouter {
    private $commands = [];
    private $config;

    public function __construct($config) {
        $this->config = $config;
        $this->registerCommands();
    }

    /**
     * Register all available commands
     */
    private function registerCommands() {
        // Auto-load all command files from commands directory
        $commandFiles = glob(COMMANDS_PATH . '/*Command.php');

        foreach ($commandFiles as $file) {
            require_once $file;
            $className = basename($file, '.php');

            if (class_exists($className)) {
                $command = new $className($this->config);
                if ($command instanceof CommandInterface) {
                    $this->commands[$command->getName()] = $command;

                    // Inject router into help command
                    if (method_exists($command, 'setRouter')) {
                        $command->setRouter($this);
                    }
                }
            }
        }
    }

    /**
     * Route a command to its handler
     *
     * @param string $commandName
     * @param array $params
     * @return mixed
     */
    public function route($commandName, $params = []) {
        $commandName = strtolower(trim($commandName));

        if (!isset($this->commands[$commandName])) {
            return [
                'success' => false,
                'output' => "Command not found: {$commandName}\nType 'help' for available commands"
            ];
        }

        try {
            $result = $this->commands[$commandName]->execute($params);
            return [
                'success' => true,
                'output' => $result
            ];
        } catch (Exception $e) {
            return [
                'success' => false,
                'output' => "Error executing command: " . $e->getMessage()
            ];
        }
    }

    /**
     * Get all registered commands
     *
     * @return array
     */
    public function getCommands() {
        return $this->commands;
    }

    /**
     * Check if command exists
     *
     * @param string $commandName
     * @return bool
     */
    public function hasCommand($commandName) {
        return isset($this->commands[strtolower($commandName)]);
    }
}
