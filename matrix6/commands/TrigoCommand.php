<?php
/**
 * Trigonometry Command
 * Redirects to Trigonometry module
 */

class TrigoCommand implements CommandInterface {
    private $config;

    public function __construct($config) {
        $this->config = $config;
    }

    public function getName() {
        return 'trigo';
    }

    public function getDescription() {
        return 'Launch Trigonometry mathematics module';
    }

    public function execute($params = []) {
        // Return redirect marker for client-side
        return "REDIRECT:" . $this->config['modules']['trigonometry'];
    }
}
