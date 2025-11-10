<?php
/**
 * Algebra Command
 * Redirects to Algebra module
 */

class AlgebraCommand implements CommandInterface {
    private $config;

    public function __construct($config) {
        $this->config = $config;
    }

    public function getName() {
        return 'algebra';
    }

    public function getDescription() {
        return 'Launch Algebra mathematics module';
    }

    public function execute($params = []) {
        // Return redirect marker for client-side
        return "REDIRECT:" . $this->config['modules']['algebra'];
    }
}
