<?php
/**
 * Arithmetic Command
 * Redirects to Arithmetic module
 */

class ArithmeticCommand implements CommandInterface {
    private $config;

    public function __construct($config) {
        $this->config = $config;
    }

    public function getName() {
        return 'arithmetic';
    }

    public function getDescription() {
        return 'Launch Arithmetic mathematics module';
    }

    public function execute($params = []) {
        // Return redirect marker for client-side
        return "REDIRECT:" . $this->config['modules']['arithmetic'];
    }
}
