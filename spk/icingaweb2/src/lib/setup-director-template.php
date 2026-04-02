<?php
// Setup Director agent template with API key for self-service registration
// Usage: php setup-director-template.php <template_name>

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

$templateName = $argv[1] ?? 'agent-template';
$configDir = '/var/packages/icingaweb2/var/etc/icingaweb2';
$apiKeyFile = $configDir . '/self-service-api.key';

try {
    // Get Director database connection
    $dbResource = \Icinga\Data\ResourceFactory::getResourceConfig('icingaweb_db');
    $connection = \Icinga\Data\ResourceFactory::createResource($dbResource);

    // Check if template already exists
    $select = $connection->select()
        ->from('icinga_host', ['object_name', 'api_key', 'object_type'])
        ->where('object_name', $templateName)
        ->where('object_type', 'template');

    $existing = $connection->fetchRow($select);

    if ($existing) {
        echo "Template '$templateName' already exists\n";
        $apiKey = $existing->api_key;

        // If no API key, generate one
        if (empty($apiKey)) {
            echo "Generating API key for existing template...\n";
            $apiKey = generateApiKey();
            $connection->update('icinga_host',
                ['api_key' => $apiKey],
                ['object_name = ?' => $templateName]
            );
            echo "API key generated and stored\n";
        }
    } else {
        // Generate API key first
        $apiKey = generateApiKey();

        // Create the template
        echo "Creating agent template '$templateName'...\n";

        $templateData = [
            'uuid' => generateUuid(),
            'object_name' => $templateName,
            'object_type' => 'template',
            'has_agent' => 'y',
            'accept_config' => 'y',
            'master_should_connect' => 'y',
            'api_key' => $apiKey,
        ];

        // Look up hostalive command ID (built-in, always exists from kickstart)
        $hostaliveCmd = $connection->fetchRow(
            $connection->select()
                ->from('icinga_command', ['id'])
                ->where('object_name', 'hostalive')
        );
        if ($hostaliveCmd) {
            $templateData['check_command_id'] = $hostaliveCmd->id;
        }

        $connection->insert('icinga_host', $templateData);
        echo "Agent template created successfully\n";

        // Get the host template ID for assigning services
        $hostTemplate = $connection->fetchRow(
            $connection->select()
                ->from('icinga_host', ['id'])
                ->where('object_name', $templateName)
                ->where('object_type', 'template')
        );

        // Create services assigned directly to the host template
        // Using built-in ITL commands with their default thresholds
        if ($hostTemplate) {
            $services = [
                ['name' => 'disk', 'display' => 'Disk Space'],
                ['name' => 'load', 'display' => 'CPU Load'],
                ['name' => 'procs', 'display' => 'Processes'],
                ['name' => 'swap', 'display' => 'Swap Usage'],
            ];

            foreach ($services as $svc) {
                $cmd = $connection->fetchRow(
                    $connection->select()
                        ->from('icinga_command', ['id'])
                        ->where('object_name', $svc['name'])
                );

                if ($cmd) {
                    $connection->insert('icinga_service', [
                        'uuid' => generateUuid(),
                        'object_name' => $svc['name'],
                        'object_type' => 'object',
                        'host_id' => $hostTemplate->id,
                        'check_command_id' => $cmd->id,
                    ]);
                    echo "Service created: {$svc['name']}\n";
                }
            }
        }
    }

    // Save API key to file for agents to use
    if (!is_dir($configDir)) {
        mkdir($configDir, 0750, true);
    }
    file_put_contents($apiKeyFile, $apiKey);
    chmod($apiKeyFile, 0640);

    echo "API key saved to: $apiKeyFile\n";
    echo "API key: $apiKey\n";

} catch (Exception $e) {
    echo "ERROR: " . $e->getMessage() . "\n";
    exit(1);
}

/**
 * Generate a unique API key similar to Director's method
 */
function generateApiKey() {
    return sha1(microtime(false) . random_bytes(32));
}

/**
 * Generate a UUID v4 for Director database (stored as VARBINARY(16))
 */
function generateUuid() {
    $data = random_bytes(16);
    // Set version to 0100 (UUID v4)
    $data[6] = chr(ord($data[6]) & 0x0f | 0x40);
    // Set variant to 10xx
    $data[8] = chr(ord($data[8]) & 0x3f | 0x80);
    return $data;  // Return binary directly for VARBINARY(16)
}
