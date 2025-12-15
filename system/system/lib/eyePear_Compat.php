<?php
/**
 * eyePear Compatibility Layer (Phase 3A)
 *
 * Provides backward compatibility for code that uses old PEAR-based APIs
 * Redirects to modern standalone implementations
 *
 * This file allows gradual migration from eyePear to modern Composer packages
 *
 * @package   3src OS
 * @copyright 2025 3src (Camille Roy)
 * @license   AGPL-3.0-or-later
 * @created   2025-12-15
 */

/**
 * System_SharedMemory compatibility class
 *
 * Provides backward compatibility for old System_SharedMemory::factory() calls
 * Redirects to eyeIPC_factory() implementation
 */
class System_SharedMemory
{
    /**
     * Factory method for backward compatibility
     *
     * @param string|false $type Driver type (only 'File' supported in 3src OS)
     * @param array $options Configuration options
     * @return System_SharedMemory_File Driver instance
     * @deprecated Use eyeIPC_factory() directly instead
     */
    public static function factory($type = false, $options = array())
    {
        // Ensure eyeIPC is loaded
        if (!function_exists('eyeIPC_factory')) {
            require_once EYE_ROOT . '/' . SYSTEM_DIR . '/' . LIB_DIR . '/eyeIPC/main' . EYE_CODE_EXTENSION;
        }

        // Default to File driver (only one used in 3src OS)
        if ($type === false || $type === 'File') {
            return eyeIPC_factory('File', $options);
        }

        // Fallback for other types (not implemented)
        trigger_error(
            "System_SharedMemory::factory('$type') is not supported. " .
            "3src OS only uses File driver for session storage.",
            E_USER_WARNING
        );

        return eyeIPC_factory('File', $options);
    }

    /**
     * Get available driver types
     *
     * @param bool $only_first Return only first available type
     * @return string|array Available driver types
     * @deprecated Not needed in modern implementation
     */
    public static function getAvailableTypes($only_first = false)
    {
        if ($only_first) {
            return 'File';
        }

        return array('File');
    }
}

/**
 * HTTP_Request2 compatibility class (Phase 3B placeholder)
 *
 * Will be implemented in Phase 3B when replacing with Guzzle
 * Placeholder to prevent fatal errors if code tries to use it
 */
class HTTP_Request2
{
    public function __construct($url = null, $method = 'GET', array $config = array())
    {
        throw new RuntimeException(
            'HTTP_Request2 has been replaced with Guzzle. ' .
            'Please use Guzzle HTTP client instead. ' .
            'See PHASE3_EYEPEAR_REPLACEMENT_STRATEGY.md for migration guide.'
        );
    }
}

/**
 * File_Archive compatibility class (Phase 3C placeholder)
 *
 * Will be implemented in Phase 3C when replacing with Flysystem
 * Placeholder to prevent fatal errors if code tries to use it
 */
class File_Archive
{
    public static function __callStatic($name, $arguments)
    {
        throw new RuntimeException(
            'File_Archive has been replaced with League\\Flysystem. ' .
            'Please use Flysystem for file operations. ' .
            'See PHASE3_EYEPEAR_REPLACEMENT_STRATEGY.md for migration guide.'
        );
    }
}

/**
 * Contact_Vcard_Build compatibility class (Phase 3D placeholder)
 *
 * Will be implemented in Phase 3D when replacing with Sabre VObject
 * Placeholder to prevent fatal errors if code tries to use it
 */
class Contact_Vcard_Build
{
    public function __construct($version = '3.0')
    {
        throw new RuntimeException(
            'Contact_Vcard_Build has been replaced with Sabre\\VObject. ' .
            'Please use VObject for vCard operations. ' .
            'See PHASE3_EYEPEAR_REPLACEMENT_STRATEGY.md for migration guide.'
        );
    }
}

/**
 * Contact_Vcard_Parse compatibility class (Phase 3D placeholder)
 *
 * Will be implemented in Phase 3D when replacing with Sabre VObject
 * Placeholder to prevent fatal errors if code tries to use it
 */
class Contact_Vcard_Parse
{
    public function __construct($text = '')
    {
        throw new RuntimeException(
            'Contact_Vcard_Parse has been replaced with Sabre\\VObject. ' .
            'Please use VObject for vCard operations. ' .
            'See PHASE3_EYEPEAR_REPLACEMENT_STRATEGY.md for migration guide.'
        );
    }
}

// Add more compatibility classes as needed during Phase 3B-3E migration

/**
 * Migration status information
 *
 * Tracks which eyePear components have been replaced
 */
class EyePear_Migration_Status
{
    const PHASE_3A_COMPLETE = true;   // eyeIPC extracted
    const PHASE_3B_COMPLETE = false;  // HTTP_Request2 → Guzzle
    const PHASE_3C_COMPLETE = false;  // File_Archive → Flysystem
    const PHASE_3D_COMPLETE = false;  // Contact/Crypt → Sabre/phpseclib
    const PHASE_3E_COMPLETE = false;  // Cleanup complete

    /**
     * Get migration status report
     *
     * @return array Migration status by phase
     */
    public static function getStatus()
    {
        return array(
            'Phase 3A' => array(
                'name' => 'Foundation - Remove PEAR dependency',
                'complete' => self::PHASE_3A_COMPLETE,
                'components' => array('eyeIPC File driver')
            ),
            'Phase 3B' => array(
                'name' => 'HTTP Client - Replace with Guzzle',
                'complete' => self::PHASE_3B_COMPLETE,
                'components' => array('HTTP_Request2 → Guzzle 7.x')
            ),
            'Phase 3C' => array(
                'name' => 'File Archive - Replace with Flysystem',
                'complete' => self::PHASE_3C_COMPLETE,
                'components' => array('File_Archive → league/flysystem')
            ),
            'Phase 3D' => array(
                'name' => 'Contacts & Crypto',
                'complete' => self::PHASE_3D_COMPLETE,
                'components' => array(
                    'Contact_Vcard_* → sabre/vobject',
                    'Crypt_* → phpseclib'
                )
            ),
            'Phase 3E' => array(
                'name' => 'Cleanup - Delete eyePear',
                'complete' => self::PHASE_3E_COMPLETE,
                'components' => array('Delete system/system/lib/eyePear/')
            )
        );
    }

    /**
     * Check if migration is complete
     *
     * @return bool True if all phases complete
     */
    public static function isComplete()
    {
        return self::PHASE_3A_COMPLETE
            && self::PHASE_3B_COMPLETE
            && self::PHASE_3C_COMPLETE
            && self::PHASE_3D_COMPLETE
            && self::PHASE_3E_COMPLETE;
    }
}
