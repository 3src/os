/**
 * Visual Effects Module
 * Matrix rain, glitch effects, typing animations
 */

class MatrixRain {
    constructor(canvasId) {
        this.canvas = document.getElementById(canvasId);
        if (!this.canvas) return;

        this.ctx = this.canvas.getContext('2d');
        this.canvas.width = window.innerWidth;
        this.canvas.height = window.innerHeight;

        this.katakana = 'アァカサタナハマヤャラワガザダバパイィキシチニヒミリヰギジヂビピウゥクスツヌフムユュルグズブヅプエェケセテネヘメレヱゲゼデベペオォコソトノホモヨョロヲゴゾドボポヴッン';
        this.latin = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        this.nums = '0123456789';
        this.symbols = '!"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~';
        this.alphabet = this.katakana + this.latin + this.nums + this.symbols;

        this.fontSize = 16;
        this.columns = Math.floor(this.canvas.width / this.fontSize);
        this.rainDrops = Array(this.columns).fill(1);
    }

    /**
     * Draw matrix rain frame
     */
    draw() {
        if (!this.ctx) return;

        this.ctx.fillStyle = 'rgba(0,0,0,0.05)';
        this.ctx.fillRect(0, 0, this.canvas.width, this.canvas.height);

        this.ctx.fillStyle = '#00ff41';
        this.ctx.font = this.fontSize + 'px monospace';

        for (let i = 0; i < this.rainDrops.length; i++) {
            const text = this.alphabet.charAt(Math.floor(Math.random() * this.alphabet.length));
            this.ctx.fillText(text, i * this.fontSize, this.rainDrops[i] * this.fontSize);

            if (this.rainDrops[i] * this.fontSize > this.canvas.height && Math.random() > 0.975) {
                this.rainDrops[i] = 0;
            }
            this.rainDrops[i]++;
        }
    }

    /**
     * Start animation
     */
    start() {
        setInterval(() => this.draw(), 30);
    }
}

class TypingAnimation {
    /**
     * Animate typing effect on elements
     */
    static animate(selector, speed = 100) {
        const elements = document.querySelectorAll(selector);

        elements.forEach(el => {
            const text = el.textContent;
            el.textContent = '';
            let i = 0;

            const typing = setInterval(() => {
                if (i < text.length) {
                    el.textContent += text.charAt(i);
                    i++;
                } else {
                    clearInterval(typing);
                }
            }, speed);
        });
    }
}

// Initialize effects when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    // Start matrix rain
    const matrixRain = new MatrixRain('matrix-rain');
    if (matrixRain.canvas) {
        matrixRain.start();
    }

    // Start typing animations after a delay
    setTimeout(() => {
        TypingAnimation.animate('.typing-animation', 100);
    }, 500);
});

// Export for use in other modules
window.MatrixRain = MatrixRain;
window.TypingAnimation = TypingAnimation;
