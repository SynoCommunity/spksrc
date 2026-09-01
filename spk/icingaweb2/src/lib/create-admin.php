<?php
// Create admin user for Icinga Web 2 using Icinga's built-in classes

putenv('ICINGAWEB_LIBDIR=/var/packages/icingaweb2/target/share/icinga-php');
putenv('ICINGAWEB_CONFIGDIR=/var/packages/icingaweb2/var/etc/icingaweb2');
$vendorAutoload = getenv('ICINGAWEB_LIBDIR') . '/vendor/vendor/autoload.php';
$iplAutoload = getenv('ICINGAWEB_LIBDIR') . '/ipl/vendor/autoload.php';

if (file_exists($vendorAutoload)) {
    require_once $vendorAutoload;
}
if (file_exists($iplAutoload)) {
    require_once $iplAutoload;
}

require_once '/var/packages/icingaweb2/target/share/icingaweb2/library/Icinga/Application/Cli.php';

\Icinga\Application\Cli::start('/var/packages/icingaweb2/target/share/icingaweb2', '/var/packages/icingaweb2/var/etc/icingaweb2');

$adminUser = $argv[1] ?? null;
$adminPass = $argv[2] ?? null;

if (! $adminUser || ! $adminPass) {
    echo "Usage: php create-admin.php <username> <password>\n";
    exit(1);
}

try {
    
    $dbResource = \Icinga\Data\ResourceFactory::getResourceConfig('icingaweb_db');
    $connection = \Icinga\Data\ResourceFactory::createResource($dbResource);
    
    $userBackend = new \Icinga\Authentication\User\DbUserBackend($connection);
    
    $existingUser = $userBackend->select()->where('user_name', $adminUser);
    if ($existingUser->count() === 0) {
        $userBackend->insert('user', [
            'user_name' => $adminUser,
            'password'  => $adminPass,
            'is_active' => true
        ]);
        echo "Admin user '$adminUser' created successfully\n";
    } else {
        echo "Admin user '$adminUser' already exists, skipping creation\n";
    }
    
} catch (Exception $e) {
    echo "ERROR: " . $e->getMessage() . "\n";
    exit(1);
}
