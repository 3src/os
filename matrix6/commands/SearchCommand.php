<?php
/**
 * Search Command
 * Redirects to Search module
 */

class SearchCommand implements CommandInterface {
    private $config;

    public function __construct($config) {
        $this->config = $config;
    }

    public function getName() {
        return 'search';
    }

    public function getDescription() {
        return 'Launch Search module';
    }

    public function execute($params = []) {
        // Return redirect marker for client-side
        return "REDIRECT:" . $this->config['modules']['search'];
    }
}
