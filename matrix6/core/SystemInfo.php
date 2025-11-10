<?php
/**
 * System Information Provider
 * Provides real system specifications for BIOS and commands
 */

class SystemInfo {
    /**
     * Get total system memory in GB
     */
    public static function getMemoryGB() {
        if (file_exists('/proc/meminfo')) {
            $meminfo = file_get_contents('/proc/meminfo');
            if (preg_match('/MemTotal:\s+(\d+)\s+kB/m', $meminfo, $matches)) {
                return round($matches[1] / 1024 / 1024, 2);
            }
        }
        return 'Unknown';
    }

    /**
     * Get CPU count
     */
    public static function getCPUCount() {
        if (file_exists('/proc/cpuinfo')) {
            $cpuinfo = file_get_contents('/proc/cpuinfo');
            preg_match_all('/^processor/m', $cpuinfo, $matches);
            return count($matches[0]);
        }
        return 'Unknown';
    }

    /**
     * Get CPU architecture
     */
    public static function getCPUArchitecture() {
        $arch = php_uname('m');

        // Convert to user-friendly format
        if (strpos($arch, 'x86_64') !== false || strpos($arch, 'amd64') !== false) {
            return '64-bit';
        } elseif (strpos($arch, 'i386') !== false || strpos($arch, 'i686') !== false) {
            return '32-bit';
        }

        return $arch;
    }

    /**
     * Get CPU model name
     */
    public static function getCPUModel() {
        if (file_exists('/proc/cpuinfo')) {
            $cpuinfo = file_get_contents('/proc/cpuinfo');
            if (preg_match('/model name\s+:\s+(.+)/m', $cpuinfo, $matches)) {
                return trim($matches[1]);
            }
        }
        return 'Unknown CPU';
    }

    /**
     * Get total disk space in TB
     */
    public static function getDiskSpaceTB() {
        $totalSpace = disk_total_space('/');
        if ($totalSpace) {
            return round($totalSpace / 1024 / 1024 / 1024 / 1024, 2);
        }
        return 'Unknown';
    }

    /**
     * Get total disk space in human readable format
     */
    public static function getDiskSpaceHuman() {
        $totalSpace = disk_total_space('/');
        if ($totalSpace) {
            return self::formatBytes($totalSpace);
        }
        return 'Unknown';
    }

    /**
     * Check if CPU supports Hyperthreading
     */
    public static function hasHyperThreading() {
        if (file_exists('/proc/cpuinfo')) {
            $cpuinfo = file_get_contents('/proc/cpuinfo');
            if (preg_match('/flags\s+:\s+(.+)/m', $cpuinfo, $matches)) {
                $flags = explode(' ', $matches[1]);
                return in_array('ht', $flags);
            }
        }
        return false;
    }

    /**
     * Check if CPU supports Virtualization
     */
    public static function hasVirtualization() {
        if (file_exists('/proc/cpuinfo')) {
            $cpuinfo = file_get_contents('/proc/cpuinfo');
            if (preg_match('/flags\s+:\s+(.+)/m', $cpuinfo, $matches)) {
                $flags = explode(' ', $matches[1]);
                return in_array('vmx', $flags) || in_array('svm', $flags);
            }
        }
        return false;
    }

    /**
     * Check if CPU supports NX bit
     */
    public static function hasNXBit() {
        if (file_exists('/proc/cpuinfo')) {
            $cpuinfo = file_get_contents('/proc/cpuinfo');
            if (preg_match('/flags\s+:\s+(.+)/m', $cpuinfo, $matches)) {
                $flags = explode(' ', $matches[1]);
                return in_array('nx', $flags);
            }
        }
        return false;
    }

    /**
     * Get OS distribution name
     */
    public static function getDistribution() {
        if (file_exists('/etc/os-release')) {
            $osRelease = parse_ini_file('/etc/os-release');
            if (isset($osRelease['PRETTY_NAME'])) {
                return $osRelease['PRETTY_NAME'];
            }
        }
        return PHP_OS;
    }

    /**
     * Get kernel version
     */
    public static function getKernelVersion() {
        return php_uname('r');
    }

    /**
     * Get hostname
     */
    public static function getHostname() {
        return php_uname('n');
    }

    /**
     * Format bytes to human readable format
     */
    private static function formatBytes($bytes, $precision = 2) {
        $units = ['B', 'KB', 'MB', 'GB', 'TB', 'PB'];

        for ($i = 0; $bytes > 1024 && $i < count($units) - 1; $i++) {
            $bytes /= 1024;
        }

        return round($bytes, $precision) . ' ' . $units[$i];
    }

    /**
     * Get all system info as array
     */
    public static function getAll() {
        return [
            'memory_gb' => self::getMemoryGB(),
            'cpu_count' => self::getCPUCount(),
            'cpu_arch' => self::getCPUArchitecture(),
            'cpu_model' => self::getCPUModel(),
            'disk_space_tb' => self::getDiskSpaceTB(),
            'disk_space_human' => self::getDiskSpaceHuman(),
            'has_ht' => self::hasHyperThreading(),
            'has_vt' => self::hasVirtualization(),
            'has_nx' => self::hasNXBit(),
            'distribution' => self::getDistribution(),
            'kernel' => self::getKernelVersion(),
            'hostname' => self::getHostname()
        ];
    }
}
