<?php
/**
 * Finance Command
 * Redirects to Finance module
 */

class FinanceCommand implements CommandInterface {
    private $config;

    public function __construct($config) {
        $this->config = $config;
    }

    public function getName() {
        return 'finance';
    }

    public function getDescription() {
        return 'Launch Finance mathematics module';
    }

    public function execute($params = []) {
        // Return redirect marker for client-side
        return "REDIRECT:" . $this->config['modules']['finance'];
    }
}
