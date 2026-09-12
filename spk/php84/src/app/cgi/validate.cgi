#!/bin/sh
# PHP 8.4 Validation CGI Script
# POSIX-compliant - Validates extension dependencies and configuration

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

# Export environment variables for PHP
export EXTENSIONS_JSON
export CONF_D_DIR
export EXT_DIR

# Process with PHP
"$PHP_BIN" -r '
<?php
$extJson = getenv("EXTENSIONS_JSON") ?: "/var/packages/php84/target/conf/extensions.json";
$confDir = getenv("CONF_D_DIR") ?: "/var/packages/php84/var/etc/conf.d";
$extDir = getenv("EXT_DIR") ?: "/var/packages/php84/target/lib/php/extensions/no-debug-non-zts-20240924";

$method = $_SERVER["REQUEST_METHOD"] ?? "GET";

// Load extensions configuration
$config = file_exists($extJson) ? json_decode(file_get_contents($extJson), true) : null;

if (!$config) {
    echo json_encode(["success" => false, "error" => "Extensions configuration not found"]);
    exit(1);
}

// Check if extension is enabled
function isEnabled($extId, $confDir) {
    return file_exists("$confDir/$extId.ini");
}

// Check if extension is available
function isAvailable($extId, $extDir) {
    return file_exists("$extDir/$extId.so");
}

// Validate dependencies for an extension
function validateDependencies($extId, $config, $confDir, $extDir) {
    $ext = $config["extensions"][$extId] ?? null;
    if (!$ext) {
        return ["valid" => false, "error" => "Unknown extension: $extId"];
    }

    $deps = $ext["dependencies"] ?? [];
    $missing = [];

    foreach ($deps as $dep) {
        if (!isEnabled($dep, $confDir) && !isAvailable($dep, $extDir)) {
            $missing[] = $dep;
        }
    }

    if (!empty($missing)) {
        return [
            "valid" => false,
            "extension" => $extId,
            "missing_dependencies" => $missing,
            "message" => "Extension $extId requires: " . implode(", ", $missing)
        ];
    }

    return ["valid" => true, "extension" => $extId];
}

// Validate all enabled extensions
function validateAll($config, $confDir, $extDir) {
    $results = [];
    $errors = [];

    foreach ($config["extensions"] as $extId => $ext) {
        if (isEnabled($extId, $confDir)) {
            $validation = validateDependencies($extId, $config, $confDir, $extDir);
            if (!$validation["valid"]) {
                $errors[] = $validation;
            }
            $results[] = $validation;
        }
    }

    return [
        "success" => true,
        "valid" => empty($errors),
        "errors" => $errors,
        "checked" => count($results)
    ];
}

// Calculate dependencies for enabling an extension
function getDependencyChain($extId, $config) {
    $ext = $config["extensions"][$extId] ?? null;
    if (!$ext) {
        return [];
    }

    $deps = $ext["dependencies"] ?? [];
    $chain = $deps;

    // Recursively get dependencies of dependencies
    foreach ($deps as $dep) {
        $subDeps = getDependencyChain($dep, $config);
        $chain = array_merge($chain, $subDeps);
    }

    return array_unique($chain);
}

// Calculate what extensions depend on this one
function getDependents($extId, $config) {
    $dependents = [];

    foreach ($config["extensions"] as $id => $ext) {
        $deps = $ext["dependencies"] ?? [];
        if (in_array($extId, $deps)) {
            $dependents[] = $id;
        }
    }

    return $dependents;
}

// Handle request
$queryString = $_SERVER["QUERY_STRING"] ?? "";
parse_str($queryString, $query);
$action = $query["action"] ?? "validate";
$extension = $query["extension"] ?? null;

switch ($action) {
    case "validate":
        if ($extension) {
            // Validate specific extension
            $result = validateDependencies($extension, $config, $confDir, $extDir);
            $result["success"] = true;
            echo json_encode($result);
        } else {
            // Validate all enabled extensions
            echo json_encode(validateAll($config, $confDir, $extDir));
        }
        break;

    case "dependencies":
        if (!$extension) {
            echo json_encode(["success" => false, "error" => "Extension parameter required"]);
            break;
        }
        $chain = getDependencyChain($extension, $config);
        echo json_encode([
            "success" => true,
            "extension" => $extension,
            "dependencies" => $chain,
            "count" => count($chain)
        ]);
        break;

    case "dependents":
        if (!$extension) {
            echo json_encode(["success" => false, "error" => "Extension parameter required"]);
            break;
        }
        $dependents = getDependents($extension, $config);
        echo json_encode([
            "success" => true,
            "extension" => $extension,
            "dependents" => $dependents,
            "count" => count($dependents)
        ]);
        break;

    case "check":
        // Quick check if an extension can be enabled
        if (!$extension) {
            echo json_encode(["success" => false, "error" => "Extension parameter required"]);
            break;
        }

        $available = isAvailable($extension, $extDir);
        $enabled = isEnabled($extension, $confDir);
        $deps = getDependencyChain($extension, $config);
        $missingDeps = [];

        foreach ($deps as $dep) {
            if (!isEnabled($dep, $confDir)) {
                $missingDeps[] = $dep;
            }
        }

        echo json_encode([
            "success" => true,
            "extension" => $extension,
            "available" => $available,
            "enabled" => $enabled,
            "can_enable" => $available && empty($missingDeps),
            "missing_dependencies" => $missingDeps
        ]);
        break;

    default:
        echo json_encode(["success" => false, "error" => "Unknown action"]);
}
?>
'
