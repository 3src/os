# Real System Specifications Feature

## Overview

The matrix6 terminal now fetches and displays **real hardware specifications** from the server instead of hardcoded values. This makes it useful for actual system monitoring and diagnostics.

## Components

### 1. SystemInfo Class (`core/SystemInfo.php`)

A utility class that queries the actual system hardware:

```php
// Get all system info at once
$sysInfo = SystemInfo::getAll();

// Or get individual components
$memory = SystemInfo::getMemoryGB();      // e.g., "16.5"
$cpuCount = SystemInfo::getCPUCount();    // e.g., 8
$cpuModel = SystemInfo::getCPUModel();    // e.g., "Intel Core i7-9700K"
$diskSpace = SystemInfo::getDiskSpaceHuman(); // e.g., "500 GB"
$hasVT = SystemInfo::hasVirtualization(); // true/false
```

#### Data Sources

- **CPU Info**: `/proc/cpuinfo`
  - Processor count
  - Model name
  - CPU speed (MHz)
  - Cache size
  - CPU flags (HT, VT-x, NX, 64-bit)

- **Memory Info**: `/proc/meminfo`
  - Total RAM
  - Available RAM
  - Free RAM
  - Swap space

- **Disk Info**: PHP functions
  - `disk_total_space()`
  - `disk_free_space()`

- **OS Info**: Multiple sources
  - `/etc/os-release` - Distribution name
  - `php_uname()` - Kernel version, hostname, architecture

### 2. SystemInfoCommand (`commands/SystemInfoCommand.php`)

A terminal command that displays comprehensive system information:

```
> sysinfo

=== SYSTEM SPECIFICATIONS ===

--- Operating System ---
OS: Linux
OS Family: Linux
Kernel: Linux 4.4.0
Hostname: user-server
Architecture: x86_64
Distribution: Ubuntu 20.04.3 LTS
Uptime: up 5 days, 3 hours

--- CPU ---
Processors: 8
Model: Intel(R) Core(TM) i7-9700K CPU @ 3.60GHz
Speed: 3600 MHz
Cache: 12288 KB
Features: HyperThreading, Virtualization, NX Bit, 64-bit
Load Average: 0.52, 0.45, 0.38

--- Memory ---
Total RAM: 16384 MB (16 GB)
Available RAM: 12288 MB (12 GB)
Free RAM: 8192 MB
Total Swap: 2048 MB
Free Swap: 2048 MB

--- Disk Storage ---
Root Partition (/):
  Total: 500 GB
  Used: 250 GB
  Free: 250 GB
  Usage: 50%

All Partitions:
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1       500G  250G  250G  50% /

--- Network ---
Server IP: 192.168.1.100
Client IP: 192.168.1.50
Server Name: localhost
Network Interfaces:
  lo, eth0, docker0

--- PHP Environment ---
PHP Version: 8.1.2
PHP SAPI: fpm-fcgi
Memory Limit: 256M
Max Execution Time: 30s
Upload Max Filesize: 10M
Loaded Extensions: 58
```

### 3. BIOS Screen Enhancement

The BIOS boot screen now shows **real system specs** instead of fake data:

**Before (Hardcoded):**
```
Memory Testing: 160GB OK
CPU Detected: 24 x 64-bit Processors
Detected Storage: 19.96 Terabytes
```

**After (Real Data):**
```
Memory Testing: 16GB OK
CPU Detected: 8 x 64-bit Processors
-> Intel(R) Core(TM) i7-9700K CPU @ 3.60GHz
Hyperthreading Technology - Enabled
VT-x Virtualization - Enabled
NX Bit - Enabled
File System: Ubuntu 20.04.3 LTS
Kernel: 4.4.0
Detected Storage: 500 GB
Hostname: user-server
```

## Usage

### In Terminal

1. Login to the terminal (username: `3src`, password: `17`)
2. Type `sysinfo` and press Enter
3. View detailed system specifications

### Via BIOS Screen

The BIOS screen automatically loads and displays real specs on page load.

### Programmatically

```php
// In any PHP file
require_once 'matrix6/core/SystemInfo.php';

// Get specific info
echo "Server has " . SystemInfo::getMemoryGB() . "GB RAM\n";
echo "Running on " . SystemInfo::getCPUCount() . " CPU cores\n";

if (SystemInfo::hasVirtualization()) {
    echo "Virtualization is supported\n";
}

// Get all info
$specs = SystemInfo::getAll();
print_r($specs);
```

## Security Considerations

### Safe Operations

The SystemInfo class only performs **read-only** operations:
- ✅ Reading `/proc/cpuinfo` (read-only file)
- ✅ Reading `/proc/meminfo` (read-only file)
- ✅ Reading `/etc/os-release` (read-only file)
- ✅ Using PHP built-in functions (`disk_total_space`, `php_uname`)
- ✅ No shell command execution (unless explicitly enabled)

### Optional Shell Commands

Some features use shell commands if enabled in config:
```php
// config.php
define('ENABLE_SHELL_EXEC', true);
```

If enabled, these commands are used:
- `uptime -p` - System uptime
- `df -h` - Detailed disk partition info
- `ip addr show` or `ifconfig` - Network interface details

**For Production**: Set `ENABLE_SHELL_EXEC = false` to disable shell execution.

## Performance

### Caching Recommendation

For high-traffic sites, consider caching system info:

```php
// Example: Cache for 5 minutes
$cacheFile = '/tmp/sysinfo_cache.json';
$cacheTime = 300; // 5 minutes

if (file_exists($cacheFile) && (time() - filemtime($cacheFile)) < $cacheTime) {
    $sysInfo = json_decode(file_get_contents($cacheFile), true);
} else {
    $sysInfo = SystemInfo::getAll();
    file_put_contents($cacheFile, json_encode($sysInfo));
}
```

## Compatibility

### Supported Systems

- ✅ **Linux** (Ubuntu, Debian, CentOS, RHEL, etc.)
  - Full support for all features
  - Reads `/proc/cpuinfo`, `/proc/meminfo`

- ⚠️ **macOS** (Limited support)
  - Basic info available via PHP functions
  - No `/proc` filesystem

- ⚠️ **Windows** (Limited support)
  - Basic info via PHP functions
  - Different file paths and commands needed

### PHP Requirements

- PHP 7.4+ (recommended: 8.0+)
- Required extensions: None (uses built-in functions)
- Optional: `shell_exec()` enabled for extended features

## Example Output Formats

### Compact Format (BIOS)
```
Memory: 16GB
CPU: 8 x 64-bit (Intel Core i7-9700K)
Disk: 500 GB
```

### Detailed Format (sysinfo command)
```
=== SYSTEM SPECIFICATIONS ===
[Full detailed output as shown above]
```

### JSON Format (API)
```json
{
  "memory_gb": 16,
  "cpu_count": 8,
  "cpu_model": "Intel(R) Core(TM) i7-9700K CPU @ 3.60GHz",
  "disk_space_human": "500 GB",
  "has_ht": true,
  "has_vt": true,
  "has_nx": true
}
```

## Future Enhancements

Potential additions:
- Real-time monitoring (CPU usage, memory usage)
- Temperature sensors (if available)
- Network traffic statistics
- Process list
- Service status
- Docker container info
- Database connections
- Web server stats (Apache/Nginx)

## Troubleshooting

### "Unknown" Values

If you see "Unknown" for CPU or memory:
- Check that `/proc/cpuinfo` and `/proc/meminfo` exist
- Verify PHP has read permissions
- Confirm you're running on Linux

### Missing Features

If HyperThreading/Virtualization shows as "Disabled":
- It may actually be disabled in BIOS
- Or the CPU doesn't support it
- Check with: `cat /proc/cpuinfo | grep flags`

### Permission Errors

If sysinfo command fails:
- Ensure PHP has read access to `/proc/` files
- Check file permissions: `ls -la /proc/cpuinfo`
- Run PHP as appropriate user (not as restricted user)
