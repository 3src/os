<?php
/**
 * Portal Command
 * Opens the interdimensional portal interface
 */

class PortalCommand implements CommandInterface {
    private $config;

    public function __construct($config) {
        $this->config = $config;
    }

    public function getName() {
        return 'portal';
    }

    public function getDescription() {
        return 'Open an interdimensional portal for SHA-1 decryption';
    }

    public function execute($params = []) {
        // Return special marker for client-side to open portal
        return "PORTAL:OPEN";
    }
}
