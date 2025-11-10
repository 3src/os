/**
 * Authentication Module
 * Handles user login
 */

class AuthManager {
    constructor() {
        this.loginPrompt = document.getElementById('login-prompt');
        this.usernameInput = document.getElementById('username');
        this.passwordInput = document.getElementById('password');
        this.commandInput = document.getElementById('command-input');
    }

    /**
     * Login with username and password
     */
    login() {
        const username = this.usernameInput.value;
        const password = this.passwordInput.value;

        // Send login request to server
        fetch('api.php', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: `action=login&username=${encodeURIComponent(username)}&password=${encodeURIComponent(password)}`
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                this.onLoginSuccess(data);
            } else {
                alert(data.message || 'Invalid username or password.');
            }
        })
        .catch(error => {
            console.error('Login error:', error);
            alert('An error occurred during login.');
        });
    }

    /**
     * Handle successful login
     */
    onLoginSuccess(data) {
        // Hide login prompt
        if (this.loginPrompt) {
            this.loginPrompt.style.display = 'none';
        }

        // Focus command input
        if (this.commandInput) {
            this.commandInput.focus();
        }

        // Log new password if generated
        if (data.new_password) {
            console.log("New password generated:", data.new_password);
        }

        // Dispatch login event
        window.dispatchEvent(new CustomEvent('user-logged-in', { detail: data }));
    }

    /**
     * Logout
     */
    logout() {
        fetch('api.php?action=logout')
        .then(() => {
            location.reload();
        });
    }
}

// Make login function available globally for onclick handler
let authManager;

function login() {
    if (!authManager) {
        authManager = new AuthManager();
    }
    authManager.login();
}

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    authManager = new AuthManager();
});
