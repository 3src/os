/**
 * Portal Module
 * Handles the interdimensional portal interface
 */

class Portal {
    constructor() {
        this.portalElement = document.getElementById('portal');
        this.entityInput = document.getElementById('entity-input');
        this.sha1Input = document.getElementById('sha1-input');
    }

    /**
     * Open the portal
     */
    open() {
        if (this.portalElement) {
            this.portalElement.style.display = 'block';
            this.portalElement.style.left = '50%';
            this.portalElement.style.top = '50%';
            this.portalElement.style.transform = 'translate(-50%, -50%)';

            if (this.entityInput) {
                this.entityInput.focus();
            }
        }
    }

    /**
     * Close the portal
     */
    close() {
        if (this.portalElement) {
            this.portalElement.style.display = 'none';
        }
    }

    /**
     * Decrypt SHA-1 hash
     */
    decrypt() {
        const sha1 = this.sha1Input ? this.sha1Input.value : '';
        const entity = this.entityInput ? this.entityInput.value : '';

        if (sha1.length === 40) {
            // Add output to terminal
            if (window.terminal) {
                window.terminal.addOutput(`Decrypting SHA-1 hash: ${sha1}`);
                if (entity) {
                    window.terminal.addOutput(`Entity: ${entity}`);
                }
            }
            this.close();
        } else {
            if (window.terminal) {
                window.terminal.addOutput('Invalid SHA-1 hash. Must be 40 hexadecimal characters.');
            }
        }
    }
}

// Make decrypt function available globally for onclick handler
let portalInstance;

function decrypt() {
    if (!portalInstance) {
        portalInstance = new Portal();
    }
    portalInstance.decrypt();
}

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    portalInstance = new Portal();
});

// Export for use in other modules
window.Portal = Portal;
