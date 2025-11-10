/**
 * Terminal Module
 * Handles terminal command processing and display
 */

class Terminal {
    constructor() {
        this.commandHistory = document.getElementById('command-history');
        this.commandInput = document.getElementById('command-input');
        this.cursor = document.getElementById('cursor');
        this.prompt = document.getElementById('prompt');
        this.currentMode = 'matrix';
        this.historyIndex = -1;
        this.commandHistoryArray = [];

        this.initializeEventListeners();
        this.initializeBootMessages();
    }

    /**
     * Initialize event listeners
     */
    initializeEventListeners() {
        if (this.commandInput) {
            this.commandInput.addEventListener('keydown', (e) => this.handleKeyDown(e));
        }
    }

    /**
     * Handle keyboard input
     */
    handleKeyDown(e) {
        if (e.key === 'Enter') {
            const command = this.commandInput.value;
            this.commandInput.value = '';
            this.processCommand(command);
        } else if (e.key === 'ArrowUp') {
            e.preventDefault();
            this.navigateHistory('up');
        } else if (e.key === 'ArrowDown') {
            e.preventDefault();
            this.navigateHistory('down');
        }
    }

    /**
     * Navigate command history
     */
    navigateHistory(direction) {
        if (direction === 'up' && this.historyIndex < this.commandHistoryArray.length - 1) {
            this.historyIndex++;
            this.commandInput.value = this.commandHistoryArray[this.commandHistoryArray.length - 1 - this.historyIndex];
        } else if (direction === 'down' && this.historyIndex > 0) {
            this.historyIndex--;
            this.commandInput.value = this.commandHistoryArray[this.commandHistoryArray.length - 1 - this.historyIndex];
        } else if (direction === 'down' && this.historyIndex === 0) {
            this.historyIndex = -1;
            this.commandInput.value = '';
        }
    }

    /**
     * Process command
     */
    processCommand(input) {
        if (!input.trim()) return;

        // Add to history
        this.commandHistoryArray.push(input);
        this.historyIndex = -1;

        // Display command
        const promptChar = this.currentMode === 'matrix' ? '>' : '$';
        this.addOutput(`<p class="matrix-text">${promptChar} ${this.escapeHtml(input)}</p>`);

        const parts = input.trim().split(' ');
        const command = parts[0].toLowerCase();
        const args = parts.slice(1);

        // Handle special client-side commands
        if (command === 'clear') {
            this.clear();
            return;
        }

        // Send command to server
        this.executeCommand(command, args, input);
    }

    /**
     * Execute command via API
     */
    executeCommand(command, args, fullInput) {
        fetch('api.php', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: `action=command&cmd=${encodeURIComponent(command)}&args=${encodeURIComponent(JSON.stringify(args))}&full_input=${encodeURIComponent(fullInput)}`
        })
        .then(response => response.json())
        .then(data => {
            if (data.output) {
                // Check for special markers
                if (data.output.startsWith('REDIRECT:')) {
                    const url = data.output.substring(9);
                    window.location.href = url;
                } else if (data.output === 'PORTAL:OPEN') {
                    if (window.portalInstance) {
                        window.portalInstance.open();
                    }
                } else if (data.output.includes('CONNECTION ESTABLISHED')) {
                    this.addOutput(`<p class="matrix-text">${data.output}</p>`);
                    this.switchToBASH();
                } else {
                    this.addOutput(`<p class="matrix-text">${data.output}</p>`);
                }
            }
        })
        .catch(error => {
            console.error('Command error:', error);
            this.addOutput(`<p class="matrix-text">Error executing command: ${error.message}</p>`);
        });
    }

    /**
     * Add output to terminal
     */
    addOutput(html) {
        if (!this.commandHistory) return;

        const div = document.createElement('div');
        div.innerHTML = html;
        this.commandHistory.appendChild(div);
        this.commandHistory.scrollTop = this.commandHistory.scrollHeight;
    }

    /**
     * Clear terminal
     */
    clear() {
        if (this.commandHistory) {
            this.commandHistory.innerHTML = '';
        }
    }

    /**
     * Switch to BASH mode
     */
    switchToBASH() {
        this.currentMode = 'bash';
        if (this.commandInput) {
            this.commandInput.className = 'flex-1 bg-transparent border-none outline-none text-blue-500';
        }
        if (this.prompt) {
            this.prompt.textContent = '$';
        }
    }

    /**
     * Switch to Matrix mode
     */
    switchToMatrix() {
        this.currentMode = 'matrix';
        if (this.commandInput) {
            this.commandInput.className = 'flex-1 bg-transparent border-none outline-none matrix-text';
        }
        if (this.prompt) {
            this.prompt.textContent = '>';
        }
    }

    /**
     * Escape HTML entities
     */
    escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    /**
     * Initialize boot messages
     */
    initializeBootMessages() {
        setTimeout(() => {
            this.addOutput('<p class="matrix-text">> Detecting secondary shell interface...</p>');
            setTimeout(() => {
                this.addOutput('<p class="matrix-text">> BASH shell available</p>');
                this.addOutput('<p class="matrix-text">> Type "bash" to access</p>');
                this.addOutput('<p class="matrix-text">> </p>');
            }, 800);
        }, 1500);
    }
}

// Initialize terminal when DOM is ready
let terminal;

document.addEventListener('DOMContentLoaded', () => {
    terminal = new Terminal();
    window.terminal = terminal;
});
