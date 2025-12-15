<?php
/**
 * Test script for eyeIPC File driver (Phase 3A verification)
 * Tests that session storage works after removing PEAR dependency
 */

// Bootstrap minimal eyeOS environment
define('EYE_ROOT', __DIR__);
define('SYSTEM_DIR', 'system/system');
define('LIB_DIR', 'lib');
define('EYE_CODE_EXTENSION', '.eyecode');

// Mock get_tmp_dir() if not available
if (!function_exists('get_tmp_dir')) {
    function get_tmp_dir() {
        return sys_get_temp_dir();
    }
}

// Load the eyeIPC library
require_once EYE_ROOT . '/' . SYSTEM_DIR . '/' . LIB_DIR . '/eyeIPC/modules/Common' . EYE_CODE_EXTENSION;
require_once EYE_ROOT . '/' . SYSTEM_DIR . '/' . LIB_DIR . '/eyeIPC/modules/File' . EYE_CODE_EXTENSION;
require_once EYE_ROOT . '/' . SYSTEM_DIR . '/' . LIB_DIR . '/eyeIPC/main' . EYE_CODE_EXTENSION;

// Mock errorCodes function
if (!function_exists('errorCodes')) {
    function errorCodes($action, $params) {
        // Mock implementation
    }
}

define('INCORRECT_PARAMS', 'INCORRECT_PARAMS');

echo "=== eyeIPC Phase 3A Test Suite ===\n\n";

// Test 1: Factory function
echo "Test 1: Factory function creates driver instance... ";
$driver = eyeIPC_factory();
if ($driver instanceof System_SharedMemory_File) {
    echo "✓ PASS\n";
} else {
    echo "✗ FAIL\n";
    exit(1);
}

// Test 2: Driver is connected
echo "Test 2: Driver is connected to file system... ";
if ($driver->isConnected()) {
    echo "✓ PASS\n";
} else {
    echo "✗ FAIL\n";
    exit(1);
}

// Test 3: Set variable
echo "Test 3: Set session variable... ";
$testKey = 'test_session_' . time();
$testValue = ['user' => 'testuser', 'data' => 'test data', 'timestamp' => time()];
$result = lib_eyeIPC_setVar([$testKey, $testValue]);
if ($result === true) {
    echo "✓ PASS\n";
} else {
    echo "✗ FAIL\n";
    exit(1);
}

// Test 4: Check variable exists
echo "Test 4: Check variable exists... ";
$exists = lib_eyeIPC_isSet([$testKey]);
if ($exists === true) {
    echo "✓ PASS\n";
} else {
    echo "✗ FAIL\n";
    exit(1);
}

// Test 5: Get variable
echo "Test 5: Get session variable... ";
$retrieved = lib_eyeIPC_getVar([$testKey]);
if ($retrieved === $testValue) {
    echo "✓ PASS\n";
} else {
    echo "✗ FAIL\n";
    echo "  Expected: " . print_r($testValue, true);
    echo "  Got: " . print_r($retrieved, true);
    exit(1);
}

// Test 6: Verify file was created
echo "Test 6: Verify session file was created... ";
$tmpDir = sys_get_temp_dir();
$filename = $tmpDir . '/smf_' . md5($testKey);
if (file_exists($filename)) {
    echo "✓ PASS\n";
} else {
    echo "✗ FAIL (file not found: $filename)\n";
    exit(1);
}

// Test 7: Remove variable
echo "Test 7: Remove session variable... ";
$result = lib_eyeIPC_rmVar([$testKey]);
if ($result === true) {
    echo "✓ PASS\n";
} else {
    echo "✗ FAIL\n";
    exit(1);
}

// Test 8: Verify variable is gone
echo "Test 8: Verify variable is removed... ";
$exists = lib_eyeIPC_isSet([$testKey]);
if ($exists === false) {
    echo "✓ PASS\n";
} else {
    echo "✗ FAIL\n";
    exit(1);
}

// Test 9: Verify file was deleted
echo "Test 9: Verify session file was deleted... ";
if (!file_exists($filename)) {
    echo "✓ PASS\n";
} else {
    echo "✗ FAIL\n";
    exit(1);
}

// Test 10: PHP 8 compatibility - no PEAR dependency
echo "Test 10: No PEAR dependency loaded... ";
if (!class_exists('PEAR', false)) {
    echo "✓ PASS\n";
} else {
    echo "✗ FAIL (PEAR class detected)\n";
    exit(1);
}

echo "\n=== All Tests Passed! ===\n";
echo "eyeIPC File driver is working correctly without PEAR dependency.\n";
echo "Session storage: $tmpDir/smf_*\n";

exit(0);
