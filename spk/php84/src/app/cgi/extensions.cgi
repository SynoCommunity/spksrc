#!/bin/sh
# PHP 8.4 Extensions CGI Script
# POSIX-compliant - Uses PHP for JSON processing

# Package paths
SYNOPKG_PKGDEST="${SYNOPKG_PKGDEST:-/var/packages/php84/target}"
SYNOPKG_PKGVAR="${SYNOPKG_PKGVAR:-/var/packages/php84/var}"

# Paths
PHP_BIN="${SYNOPKG_PKGDEST}/bin/php"
EXTENSIONS_JSON="${SYNOPKG_PKGDEST}/conf/extensions.json"
CONF_D_DIR="${SYNOPKG_PKGVAR}/etc/conf.d"
EXT_DIR="${SYNOPKG_PKGDEST}/lib/php/extensions/no-debug-non-zts-20240924"

# Output headers
echo "Content-Type: application/json"
echo ""

# Check PHP binary
if [ ! -x "$PHP_BIN" ]; then
    echo '{"success":false,"error":"PHP binary not found"}'
    exit 1
fi

# Create PHP script for JSON processing
process_request() {
    "$PHP_BIN" -r '
<?php
// Configuration
$extDir = getenv("EXT_DIR") ?: "/var/packages/php84/target/lib/php/extensions/no-debug-non-zts-20240924";
$confDir = getenv("CONF_D_DIR") ?: "/var/packages/php84/var/etc/conf.d";
$extJson = getenv("EXTENSIONS_JSON") ?: "/var/packages/php84/target/conf/extensions.json";

// Load extensions configuration
$config = file_exists($extJson) ? json_decode(file_get_contents($extJson), true) : null;

if (!$config) {
    echo json_encode(["success" => false, "error" => "Extensions configuration not found"]);
    exit(1);
}

// Get request method and data
$method = $_SERVER["REQUEST_METHOD"] ?? "GET";
$queryString = $_SERVER["QUERY_STRING"] ?? "";
parse_str($queryString, $query);
$action = $query["action"] ?? "";

// Check if extension .so file exists
function extensionAvailable($extId, $extDir) {
    return file_exists("$extDir/$extId.so");
}

// Get load order prefix for extension (must match postinst)
function getExtensionPrefix($extId) {
    switch ($extId) {
        // Core extensions that others depend on - load first (00-09)
        case "mysqlnd": return "00";
        case "pdo": return "01";
        case "igbinary": return "02";
        case "msgpack": return "03";
        // Database extensions depending on pdo/mysqlnd (10-19)
        case "pdo_mysql":
        case "pdo_sqlite":
        case "pdo_pgsql": return "10";
        case "mysqli": return "11";
        case "sqlite3": return "12";
        // Extensions depending on igbinary/msgpack (20-29)
        case "redis": return "20";
        case "memcached": return "21";
        // All other extensions (50+)
        default: return "50";
    }
}

// Get ini filename with prefix
function getIniFilename($extId) {
    return getExtensionPrefix($extId) . "-" . $extId . ".ini";
}

// Check if extension is enabled (has .ini file with or without prefix)
function extensionEnabled($extId, $confDir) {
    // Check prefixed format first (new format)
    $prefixedFile = $confDir . "/" . getIniFilename($extId);
    if (file_exists($prefixedFile)) return true;
    // Check legacy non-prefixed format
    if (file_exists("$confDir/$extId.ini")) return true;
    return false;
}

// Get all ini files for an extension (for cleanup)
function getExtensionIniFiles($extId, $confDir) {
    $files = [];
    // Prefixed format
    $prefixedFile = $confDir . "/" . getIniFilename($extId);
    if (file_exists($prefixedFile)) $files[] = $prefixedFile;
    // Legacy non-prefixed format
    $legacyFile = "$confDir/$extId.ini";
    if (file_exists($legacyFile)) $files[] = $legacyFile;
    // Also check for any other prefixed variants (XX-extId.ini)
    $pattern = $confDir . "/*-" . $extId . ".ini";
    foreach (glob($pattern) as $f) {
        if (!in_array($f, $files)) $files[] = $f;
    }
    return $files;
}

// GET: List extensions
if ($method === "GET") {
    if ($action === "categories") {
        // Return categories
        $categories = [];
        foreach ($config["categories"] as $id => $cat) {
            $categories[] = [
                "id" => $id,
                "name" => $cat["name"],
                "description" => $cat["description"] ?? "",
                "order" => $cat["order"] ?? 99
            ];
        }
        usort($categories, fn($a, $b) => $a["order"] <=> $b["order"]);
        echo json_encode(["success" => true, "categories" => $categories]);
    } else {
        // Return extensions with their status
        $extensions = [];
        foreach ($config["extensions"] as $id => $ext) {
            $category = $ext["category"] ?? "misc";
            $catInfo = $config["categories"][$category] ?? ["name" => "Autres"];

            $extensions[] = [
                "id" => $id,
                "name" => $ext["name"],
                "category" => $category,
                "categoryName" => $catInfo["name"],
                "filename" => $ext["filename"] ?? "$id.so",
                "default" => $ext["default"] ?? false,
                "dependencies" => $ext["dependencies"] ?? [],
                "zend_extension" => $ext["zend_extension"] ?? false,
                "available" => extensionAvailable($id, $extDir),
                "enabled" => extensionEnabled($id, $confDir)
            ];
        }
        echo json_encode(["success" => true, "extensions" => $extensions, "total" => count($extensions)]);
    }
    exit(0);
}

// POST: Update extensions
if ($method === "POST") {
    $input = file_get_contents("php://input");
    $data = json_decode($input, true);

    if (!$data || !isset($data["extensions"])) {
        echo json_encode(["success" => false, "error" => "Invalid request data"]);
        exit(1);
    }

    // Ensure conf.d directory exists
    if (!is_dir($confDir)) {
        mkdir($confDir, 0755, true);
    }

    $updated = 0;
    $errors = [];

    foreach ($data["extensions"] as $extId => $enable) {
        // Use prefixed filename (matches postinst format)
        $iniFile = "$confDir/" . getIniFilename($extId);
        $soFile = "$extDir/$extId.so";

        if ($enable) {
            // Enable extension
            if (!file_exists($soFile)) {
                $errors[] = "Extension $extId not available";
                continue;
            }

            // First, remove any existing ini files (cleanup duplicates)
            foreach (getExtensionIniFiles($extId, $confDir) as $oldFile) {
                @unlink($oldFile);
            }

            // Determine if Zend extension
            $extInfo = $config["extensions"][$extId] ?? [];
            $isZend = in_array($extId, ["opcache", "xdebug"]) || ($extInfo["zend_extension"] ?? false);

            $content = $isZend ? "zend_extension=$extId.so\n" : "extension=$extId.so\n";

            // Add extension-specific config
            if ($extId === "opcache") {
                $content .= "opcache.enable=1\n";
                $content .= "opcache.enable_cli=0\n";
                $content .= "opcache.memory_consumption=128\n";
                $content .= "opcache.interned_strings_buffer=8\n";
                $content .= "opcache.max_accelerated_files=10000\n";
            } elseif ($extId === "apcu") {
                $content .= "apc.enabled=1\n";
                $content .= "apc.shm_size=32M\n";
                $content .= "apc.ttl=7200\n";
            } elseif ($extId === "xdebug") {
                $content .= "xdebug.mode=off\n";
                $content .= "xdebug.start_with_request=no\n";
            }

            file_put_contents($iniFile, $content);
            chmod($iniFile, 0644);
            $updated++;
        } else {
            // Disable extension - remove ALL ini files (prefixed and legacy)
            $removed = false;
            foreach (getExtensionIniFiles($extId, $confDir) as $oldFile) {
                @unlink($oldFile);
                $removed = true;
            }
            if ($removed) $updated++;
        }
    }

    $response = ["success" => true, "updated" => $updated];
    if (!empty($errors)) {
        $response["errors"] = $errors;
    }
    echo json_encode($response);
    exit(0);
}

echo json_encode(["success" => false, "error" => "Method not allowed"]);
?>
'
}

# Export environment variables for PHP
export EXT_DIR
export CONF_D_DIR
export EXTENSIONS_JSON
export REQUEST_METHOD
export QUERY_STRING
export CONTENT_LENGTH

# Run PHP processor
process_request
