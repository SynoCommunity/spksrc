#!/bin/sh
# PHP 8.4 Configuration CGI Script
# POSIX-compliant - Handles GET (read) and POST (update) for PHP configuration

# Package paths
SYNOPKG_PKGDEST="${SYNOPKG_PKGDEST:-/var/packages/php84/target}"
SYNOPKG_PKGVAR="${SYNOPKG_PKGVAR:-/var/packages/php84/var}"

# Paths
PHP_BIN="${SYNOPKG_PKGDEST}/bin/php"
PHP_INI="${SYNOPKG_PKGVAR}/etc/php.ini"
USER_CONFIG="${SYNOPKG_PKGVAR}/config.json"

# Output headers
echo "Content-Type: application/json"
echo ""

# Check PHP binary
if [ ! -x "$PHP_BIN" ]; then
    echo '{"success":false,"error":"PHP binary not found"}'
    exit 1
fi

# Process with PHP
"$PHP_BIN" -r '
<?php
$phpIni = getenv("PHP_INI") ?: "/var/packages/php84/var/etc/php.ini";
$userConfig = getenv("USER_CONFIG") ?: "/var/packages/php84/var/config.json";
$method = $_SERVER["REQUEST_METHOD"] ?? "GET";

// Read current configuration
function readConfig($phpIni, $userConfig) {
    $config = [
        "memory_limit" => "256M",
        "max_execution_time" => 60,
        "upload_max_filesize" => "64M",
        "post_max_size" => "64M",
        "timezone" => "UTC",
        "display_errors" => false,
        "error_reporting" => "E_ALL & ~E_DEPRECATED & ~E_STRICT"
    ];

    // Read from user config if exists
    if (file_exists($userConfig)) {
        $userData = json_decode(file_get_contents($userConfig), true);
        if ($userData && isset($userData["settings"])) {
            $config = array_merge($config, $userData["settings"]);
        }
    }

    // Read actual values from php.ini if exists
    if (file_exists($phpIni)) {
        $iniContent = file_get_contents($phpIni);

        // Parse key values
        if (preg_match("/^memory_limit\s*=\s*(.+)$/m", $iniContent, $m)) {
            $config["memory_limit"] = trim($m[1]);
        }
        if (preg_match("/^max_execution_time\s*=\s*(\d+)/m", $iniContent, $m)) {
            $config["max_execution_time"] = (int)$m[1];
        }
        if (preg_match("/^upload_max_filesize\s*=\s*(.+)$/m", $iniContent, $m)) {
            $config["upload_max_filesize"] = trim($m[1]);
        }
        if (preg_match("/^post_max_size\s*=\s*(.+)$/m", $iniContent, $m)) {
            $config["post_max_size"] = trim($m[1]);
        }
        if (preg_match("/^date\.timezone\s*=\s*[\"'\'']*([^\"'\''\n]+)/m", $iniContent, $m)) {
            $config["timezone"] = trim($m[1], "\"'\''");
        }
        if (preg_match("/^display_errors\s*=\s*(On|Off|1|0)/mi", $iniContent, $m)) {
            $config["display_errors"] = in_array(strtolower($m[1]), ["on", "1"]);
        }
    }

    return $config;
}

// Update configuration
function updateConfig($phpIni, $userConfig, $newSettings) {
    // Read current php.ini
    $iniContent = file_exists($phpIni) ? file_get_contents($phpIni) : "";

    // Update values
    $updates = [
        "memory_limit" => $newSettings["memory_limit"] ?? null,
        "max_execution_time" => $newSettings["max_execution_time"] ?? null,
        "upload_max_filesize" => $newSettings["upload_max_filesize"] ?? null,
        "post_max_size" => $newSettings["post_max_size"] ?? null,
        "date.timezone" => isset($newSettings["timezone"]) ? "\"{$newSettings["timezone"]}\"" : null,
        "display_errors" => isset($newSettings["display_errors"]) ? ($newSettings["display_errors"] ? "On" : "Off") : null
    ];

    foreach ($updates as $key => $value) {
        if ($value === null) continue;

        $pattern = "/^" . preg_quote($key, "/") . "\s*=.*$/m";
        $replacement = "$key = $value";

        if (preg_match($pattern, $iniContent)) {
            $iniContent = preg_replace($pattern, $replacement, $iniContent);
        } else {
            $iniContent .= "\n$replacement";
        }
    }

    // Write php.ini
    file_put_contents($phpIni, $iniContent);

    // Update user config
    $userData = file_exists($userConfig) ? json_decode(file_get_contents($userConfig), true) : [];
    $userData["settings"] = $newSettings;
    $userData["last_modified"] = date("c");
    file_put_contents($userConfig, json_encode($userData, JSON_PRETTY_PRINT));

    return true;
}

// Handle GET
if ($method === "GET") {
    $config = readConfig($phpIni, $userConfig);
    echo json_encode(["success" => true, "config" => $config]);
    exit(0);
}

// Handle POST
if ($method === "POST") {
    $input = file_get_contents("php://input");
    $data = json_decode($input, true);

    if (!$data || !isset($data["settings"])) {
        echo json_encode(["success" => false, "error" => "Invalid request data"]);
        exit(1);
    }

    if (updateConfig($phpIni, $userConfig, $data["settings"])) {
        echo json_encode(["success" => true, "message" => "Configuration updated"]);
    } else {
        echo json_encode(["success" => false, "error" => "Failed to update configuration"]);
    }
    exit(0);
}

echo json_encode(["success" => false, "error" => "Method not allowed"]);
?>
'
