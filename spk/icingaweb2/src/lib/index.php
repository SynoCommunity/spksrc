<?php
/* Synology DSM Icinga Web 2 entry point */
/* Pre-loads vendor autoloaders and sets environment variables for PHP-FPM */

// Define library paths - must be available before Icinga bootstraps
define('ICINGAWEB_CONFIGDIR', '/var/packages/icingaweb2/var/etc/icingaweb2');
define('ICINGAWEB_LIBDIR', '/var/packages/icingaweb2/target/share/icinga-php');
define('ICINGAWEB_STORAGEDIR', '/var/packages/icingaweb2/var/storage');

// Set environment variables (for Icinga's getenv() calls)
putenv('ICINGAWEB_CONFIGDIR=' . ICINGAWEB_CONFIGDIR);
putenv('ICINGAWEB_LIBDIR=' . ICINGAWEB_LIBDIR);
putenv('ICINGAWEB_STORAGEDIR=' . ICINGAWEB_STORAGEDIR);

// Pre-load vendor autoloaders before Icinga bootstraps
// This ensures Zend Framework classes are available when Request.php is loaded
$vendorAutoload = ICINGAWEB_LIBDIR . '/vendor/vendor/autoload.php';
$iplAutoload = ICINGAWEB_LIBDIR . '/ipl/vendor/autoload.php';

if (file_exists($vendorAutoload)) {
    require_once $vendorAutoload;
}
if (file_exists($iplAutoload)) {
    require_once $iplAutoload;
}

require_once dirname(__DIR__) . '/library/Icinga/Application/webrouter.php';
