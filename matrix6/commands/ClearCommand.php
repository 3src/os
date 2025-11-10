<?php
/**
 * Clear Command
 * Clears the terminal (handled client-side)
 */

class ClearCommand implements CommandInterface {
    private $config;

    public function __construct($config) {
        $this->config = $config;
    }

    public function getName() {
        return 'clear';
    }

    public function getDescription() {
        return 'Clear the terminal screen';
    }

    public function execute($params = []) {
        // Return empty string - client-side handles clearing
        return '';
    }
}
