<?php
/**
 * Command Interface
 * All command handlers must implement this interface
 */

interface CommandInterface {
    /**
     * Execute the command
     *
     * @param array $params Command parameters
     * @return mixed Command output
     */
    public function execute($params = []);

    /**
     * Get command description
     *
     * @return string
     */
    public function getDescription();

    /**
     * Get command name
     *
     * @return string
     */
    public function getName();
}
