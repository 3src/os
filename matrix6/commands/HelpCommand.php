<?php
/**
 * Help Command
 * Displays available commands
 */

class HelpCommand implements CommandInterface {
    private $config;
    private $router;

    public function __construct($config) {
        $this->config = $config;
    }

    public function setRouter($router) {
        $this->router = $router;
    }

    public function getName() {
        return 'help';
    }

    public function getDescription() {
        return 'Display available commands and their descriptions';
    }

    public function execute($params = []) {
        $output = "Available commands:\n\n";

        if ($this->router) {
            $commands = $this->router->getCommands();
            foreach ($commands as $name => $command) {
                $output .= sprintf("  %-15s - %s\n", $name, $command->getDescription());
            }
        } else {
            $output .= "  help            - Display this help message\n";
            $output .= "  clear           - Clear the terminal\n";
            $output .= "  mail            - Send an email via the wormhole\n";
            $output .= "  bash            - Access BASH shell\n";
            $output .= "  portal          - Open interdimensional portal\n";
            $output .= "  algebra         - Run Algebra module\n";
            $output .= "  arithmetic      - Run Arithmetic module\n";
            $output .= "  finance         - Run Finance module\n";
            $output .= "  search          - Run Search module\n";
            $output .= "  trigo           - Run Trigonometry module\n";
        }

        return $output;
    }
}
