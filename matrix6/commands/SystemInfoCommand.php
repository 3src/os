<?php
/**
 * System Info Command
 * Displays real system specifications
 */

class SystemInfoCommand implements CommandInterface {
    private $config;

    public function __construct($config) {
        $this->config = $config;
    }

    public function getName() {
        return 'sysinfo';
    }

    public function getDescription() {
        return 'Display actual system specifications';
    }

    public function execute($params = []) {
        $output = "=== SYSTEM SPECIFICATIONS ===\n\n";

        // Operating System
        $output .= $this->getOSInfo();

        // CPU Information
        $output .= $this->getCPUInfo();

        // Memory Information
        $output .= $this->getMemoryInfo();

        // Disk Information
        $output .= $this->getDiskInfo();

        // Network Information
        $output .= $this->getNetworkInfo();

        // PHP Information
        $output .= $this->getPHPInfo();

        return $output;
    }

    /**
     * Get Operating System Information
     */
    private function getOSInfo() {
        $output = "--- Operating System ---\n";

        $output .= "OS: " . PHP_OS . "\n";
        $output .= "OS Family: " . PHP_OS_FAMILY . "\n";
        $output .= "Kernel: " . php_uname('s') . " " . php_uname('r') . "\n";
        $output .= "Hostname: " . php_uname('n') . "\n";
        $output .= "Architecture: " . php_uname('m') . "\n";

        // Get detailed OS info from /etc/os-release if available
        if (file_exists('/etc/os-release')) {
            $osRelease = parse_ini_file('/etc/os-release');
            if (isset($osRelease['PRETTY_NAME'])) {
                $output .= "Distribution: " . $osRelease['PRETTY_NAME'] . "\n";
            }
        }

        // System uptime
        if (function_exists('shell_exec') && $this->config['security']['shell_exec']) {
            $uptime = shell_exec('uptime -p 2>/dev/null');
            if ($uptime) {
                $output .= "Uptime: " . trim($uptime) . "\n";
            }
        }

        $output .= "\n";
        return $output;
    }

    /**
     * Get CPU Information
     */
    private function getCPUInfo() {
        $output = "--- CPU ---\n";

        if (file_exists('/proc/cpuinfo')) {
            $cpuinfo = file_get_contents('/proc/cpuinfo');

            // Count processors
            preg_match_all('/^processor/m', $cpuinfo, $matches);
            $cpuCount = count($matches[0]);
            $output .= "Processors: " . $cpuCount . "\n";

            // Get model name
            if (preg_match('/model name\s+:\s+(.+)/m', $cpuinfo, $matches)) {
                $output .= "Model: " . trim($matches[1]) . "\n";
            }

            // Get CPU MHz
            if (preg_match('/cpu MHz\s+:\s+(.+)/m', $cpuinfo, $matches)) {
                $output .= "Speed: " . round($matches[1]) . " MHz\n";
            }

            // Get cache size
            if (preg_match('/cache size\s+:\s+(.+)/m', $cpuinfo, $matches)) {
                $output .= "Cache: " . trim($matches[1]) . "\n";
            }

            // Check for flags (features)
            if (preg_match('/flags\s+:\s+(.+)/m', $cpuinfo, $matches)) {
                $flags = explode(' ', $matches[1]);
                $features = [];
                if (in_array('ht', $flags)) $features[] = 'HyperThreading';
                if (in_array('vmx', $flags) || in_array('svm', $flags)) $features[] = 'Virtualization';
                if (in_array('nx', $flags)) $features[] = 'NX Bit';
                if (in_array('lm', $flags)) $features[] = '64-bit';

                if (!empty($features)) {
                    $output .= "Features: " . implode(', ', $features) . "\n";
                }
            }
        } else {
            $output .= "CPU info not available on this system\n";
        }

        // Load average
        if (function_exists('sys_getloadavg')) {
            $load = sys_getloadavg();
            $output .= "Load Average: " . round($load[0], 2) . ", " . round($load[1], 2) . ", " . round($load[2], 2) . "\n";
        }

        $output .= "\n";
        return $output;
    }

    /**
     * Get Memory Information
     */
    private function getMemoryInfo() {
        $output = "--- Memory ---\n";

        if (file_exists('/proc/meminfo')) {
            $meminfo = file_get_contents('/proc/meminfo');

            // Total memory
            if (preg_match('/MemTotal:\s+(\d+)\s+kB/m', $meminfo, $matches)) {
                $totalMB = round($matches[1] / 1024);
                $totalGB = round($matches[1] / 1024 / 1024, 2);
                $output .= "Total RAM: " . $totalMB . " MB (" . $totalGB . " GB)\n";
            }

            // Available memory
            if (preg_match('/MemAvailable:\s+(\d+)\s+kB/m', $meminfo, $matches)) {
                $availMB = round($matches[1] / 1024);
                $availGB = round($matches[1] / 1024 / 1024, 2);
                $output .= "Available RAM: " . $availMB . " MB (" . $availGB . " GB)\n";
            }

            // Free memory
            if (preg_match('/MemFree:\s+(\d+)\s+kB/m', $meminfo, $matches)) {
                $freeMB = round($matches[1] / 1024);
                $output .= "Free RAM: " . $freeMB . " MB\n";
            }

            // Swap
            if (preg_match('/SwapTotal:\s+(\d+)\s+kB/m', $meminfo, $matches)) {
                $swapMB = round($matches[1] / 1024);
                $output .= "Total Swap: " . $swapMB . " MB\n";
            }

            if (preg_match('/SwapFree:\s+(\d+)\s+kB/m', $meminfo, $matches)) {
                $swapFreeMB = round($matches[1] / 1024);
                $output .= "Free Swap: " . $swapFreeMB . " MB\n";
            }
        } else {
            $output .= "Memory info not available on this system\n";
        }

        $output .= "\n";
        return $output;
    }

    /**
     * Get Disk Information
     */
    private function getDiskInfo() {
        $output = "--- Disk Storage ---\n";

        // Get disk space for current directory
        $totalSpace = disk_total_space('/');
        $freeSpace = disk_free_space('/');
        $usedSpace = $totalSpace - $freeSpace;

        $output .= "Root Partition (/):\n";
        $output .= "  Total: " . $this->formatBytes($totalSpace) . "\n";
        $output .= "  Used: " . $this->formatBytes($usedSpace) . "\n";
        $output .= "  Free: " . $this->formatBytes($freeSpace) . "\n";
        $output .= "  Usage: " . round(($usedSpace / $totalSpace) * 100, 2) . "%\n";

        // Try to get mount points info
        if (function_exists('shell_exec') && $this->config['security']['shell_exec']) {
            $df = shell_exec('df -h 2>/dev/null | grep -E "^(/dev/|Filesystem)"');
            if ($df) {
                $output .= "\nAll Partitions:\n";
                $output .= $df . "\n";
            }
        }

        $output .= "\n";
        return $output;
    }

    /**
     * Get Network Information
     */
    private function getNetworkInfo() {
        $output = "--- Network ---\n";

        $output .= "Server IP: " . ($_SERVER['SERVER_ADDR'] ?? 'N/A') . "\n";
        $output .= "Client IP: " . ($_SERVER['REMOTE_ADDR'] ?? 'N/A') . "\n";
        $output .= "Server Name: " . ($_SERVER['SERVER_NAME'] ?? 'N/A') . "\n";

        // Try to get network interface info
        if (function_exists('shell_exec') && $this->config['security']['shell_exec']) {
            $ifconfig = shell_exec('ip addr show 2>/dev/null || ifconfig 2>/dev/null');
            if ($ifconfig) {
                $output .= "\nNetwork Interfaces:\n";
                // Parse interface names
                if (preg_match_all('/^\d+:\s+(\S+):/m', $ifconfig, $matches)) {
                    $interfaces = array_unique($matches[1]);
                    $output .= "  " . implode(', ', $interfaces) . "\n";
                }
            }
        }

        $output .= "\n";
        return $output;
    }

    /**
     * Get PHP Information
     */
    private function getPHPInfo() {
        $output = "--- PHP Environment ---\n";

        $output .= "PHP Version: " . PHP_VERSION . "\n";
        $output .= "PHP SAPI: " . PHP_SAPI . "\n";
        $output .= "Memory Limit: " . ini_get('memory_limit') . "\n";
        $output .= "Max Execution Time: " . ini_get('max_execution_time') . "s\n";
        $output .= "Upload Max Filesize: " . ini_get('upload_max_filesize') . "\n";

        // Loaded extensions
        $extensions = get_loaded_extensions();
        $output .= "Loaded Extensions: " . count($extensions) . "\n";

        $output .= "\n";
        return $output;
    }

    /**
     * Format bytes to human readable format
     */
    private function formatBytes($bytes, $precision = 2) {
        $units = ['B', 'KB', 'MB', 'GB', 'TB', 'PB'];

        for ($i = 0; $bytes > 1024 && $i < count($units) - 1; $i++) {
            $bytes /= 1024;
        }

        return round($bytes, $precision) . ' ' . $units[$i];
    }
}
