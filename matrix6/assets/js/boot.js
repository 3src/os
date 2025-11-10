/**
 * BIOS Boot Sequence
 * Handles the boot screen animation
 */

class BootSequence {
    constructor() {
        this.biosScreen = document.getElementById('bios-screen');
        this.loginPrompt = document.getElementById('login-prompt');
        this.biosLines = this.biosScreen ? this.biosScreen.querySelectorAll('p') : [];
        this.currentLine = 0;
    }

    /**
     * Show BIOS lines one by one
     */
    showBiosLine() {
        if (this.currentLine < this.biosLines.length) {
            this.biosLines[this.currentLine].style.display = 'block';
            this.currentLine++;
            setTimeout(() => this.showBiosLine(), 500);
        } else {
            this.showLoginPrompt();
        }
    }

    /**
     * Show login prompt after BIOS sequence
     */
    showLoginPrompt() {
        if (this.loginPrompt) {
            this.loginPrompt.style.display = 'block';
        }
    }

    /**
     * Hide BIOS screen
     */
    hideBiosScreen() {
        if (this.biosScreen) {
            this.biosScreen.style.display = 'none';
        }
    }

    /**
     * Start boot sequence
     */
    start() {
        this.showBiosLine();
    }
}

// Initialize boot sequence when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    const boot = new BootSequence();
    boot.start();
});
