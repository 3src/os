<?php
/**
 * Login Handler
 * Handles user authentication
 */

class LoginHandler {
    private $config;

    public function __construct($config) {
        $this->config = $config;
    }

    /**
     * Verify login credentials
     *
     * @param string $username
     * @param string $password
     * @return bool
     */
    public function verify($username, $password) {
        $validUsername = $this->config['terminal']['username'];
        $validPassword = (string) $this->config['terminal']['default_prime'];

        return ($username === $validUsername && $password === $validPassword);
    }

    /**
     * Generate new password using digineration.php
     *
     * @return string|null
     */
    public function generateNewPassword() {
        $script = PASSWORD_REGEN_SCRIPT;

        if (file_exists($script)) {
            ob_start();
            include $script;
            $newPassword = ob_get_clean();
            return trim($newPassword);
        }

        return null;
    }

    /**
     * Handle login request
     *
     * @param array $credentials
     * @return array
     */
    public function handleLogin($credentials) {
        $username = $credentials['username'] ?? '';
        $password = $credentials['password'] ?? '';

        if ($this->verify($username, $password)) {
            // Start session
            if (session_status() === PHP_SESSION_NONE) {
                session_start();
            }

            $_SESSION['authenticated'] = true;
            $_SESSION['username'] = $username;
            $_SESSION['login_time'] = time();

            // Generate new password
            $newPassword = $this->generateNewPassword();

            return [
                'success' => true,
                'message' => 'Login successful',
                'new_password' => $newPassword
            ];
        } else {
            return [
                'success' => false,
                'message' => 'Invalid username or password'
            ];
        }
    }

    /**
     * Check if user is authenticated
     *
     * @return bool
     */
    public function isAuthenticated() {
        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }

        return isset($_SESSION['authenticated']) && $_SESSION['authenticated'] === true;
    }

    /**
     * Logout user
     */
    public function logout() {
        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }

        session_destroy();
    }
}
