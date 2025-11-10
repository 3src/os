<?php
/**
 * Email Command
 * Sends emails via PHP mail() function
 */

class EmailCommand implements CommandInterface {
    private $config;

    public function __construct($config) {
        $this->config = $config;
    }

    public function getName() {
        return 'mail';
    }

    public function getDescription() {
        return 'Send an email via the wormhole';
    }

    public function execute($params = []) {
        // Check if required parameters are provided
        if (!isset($params['email']) || !isset($params['subject']) || !isset($params['body'])) {
            return "Email command requires email, subject, and body parameters.";
        }

        $to = filter_var($params['email'], FILTER_SANITIZE_EMAIL);
        $subject = htmlspecialchars($params['subject'], ENT_QUOTES, 'UTF-8');
        $body = htmlspecialchars($params['body'], ENT_QUOTES, 'UTF-8');
        $headers = "From: " . $this->config['email']['from'];

        // Validate email
        if (!filter_var($to, FILTER_VALIDATE_EMAIL)) {
            return "Invalid email address provided.";
        }

        // Send email
        $result = mail($to, $subject, $body, $headers);

        return $result ? "Email sent successfully to {$to}" : "Failed to send email.";
    }
}
