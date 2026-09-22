#!/bin/bash
# PHP 8.4 Extension Manager - Interactive Bash CGI
# Handles GET (display) and POST (toggle extensions)

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/syno/bin:/usr/syno/sbin

PKG_NAME="php84"
PKG_BASE="/var/packages/${PKG_NAME}"
CONF_DIR="${PKG_BASE}/var/etc/conf.d"
EXT_DIR="${PKG_BASE}/target/lib/php/extensions/no-debug-non-zts-20240924"
FPM_SERVICE="${PKG_NAME}-fpm"

# Zend extensions list (require zend_extension= instead of extension=)
ZEND_EXTS="opcache xdebug"

# Extension load order priorities (lower = loaded first)
# Core extensions that others depend on (20-)
PRIORITY_CORE="session sockets mysqlnd pdo igbinary"
# Extensions that depend on core extensions (70-)
PRIORITY_DEPENDENT="ev event msgpack mysqli pdo_mysql redis memcached"

# Authentication check - DSM 7 compatible
# CGI scripts run as 'http' user via synoscgi
# We check multiple methods to verify DSM session

AUTH_OK="false"
AUTH_USER=""

# Method 1: Check for DSM session cookie (most reliable for CGI)
# The 'id=' cookie is set when user logs into DSM
if [ -n "$HTTP_COOKIE" ]; then
    if echo "$HTTP_COOKIE" | grep -qE '(^|;)[[:space:]]*id='; then
        AUTH_OK="true"
    fi
fi

# Method 2: login.cgi fallback (returns JSON with success status)
# Note: Output includes HTTP headers, so we grep for success in JSON
if [ "$AUTH_OK" = "false" ]; then
    syno_login=$(/usr/syno/synoman/webman/login.cgi 2>/dev/null)
    # Handle both "success":true and "success" : true formats
    if echo "$syno_login" | grep -q 'success.*true'; then
        AUTH_OK="true"
    fi
fi

# Method 3: authenticate.cgi (may not work in all CGI contexts)
if [ "$AUTH_OK" = "false" ]; then
    AUTH_USER=$(/usr/syno/synoman/webman/modules/authenticate.cgi 2>/dev/null)
    if [ -n "$AUTH_USER" ]; then
        AUTH_OK="true"
    fi
fi

if [ "$AUTH_OK" = "false" ]; then
    echo "Content-type: text/html"
    echo ""
    echo "Access denied"
    exit 1
fi

# Function to find ini file for extension (with or without prefix)
find_ini_file() {
    local ext="$1"
    # Check for prefixed files first (XX-ext.ini)
    local prefixed=$(ls "${CONF_DIR}/"*"-${ext}.ini" 2>/dev/null | head -1)
    if [ -n "$prefixed" ]; then
        echo "$prefixed"
        return 0
    fi
    # Check for non-prefixed file
    if [ -f "${CONF_DIR}/${ext}.ini" ]; then
        echo "${CONF_DIR}/${ext}.ini"
        return 0
    fi
    return 1
}

# Function to check if extension is enabled
is_enabled() {
    local ext="$1"
    find_ini_file "$ext" >/dev/null 2>&1
}

# Function to check if it's a zend extension
is_zend_ext() {
    local ext="$1"
    for z in $ZEND_EXTS; do
        [ "$z" = "$ext" ] && return 0
    done
    return 1
}

# Function to get priority prefix for extension load order
get_priority_prefix() {
    local ext="$1"
    # Core extensions load first (20-)
    for e in $PRIORITY_CORE; do
        [ "$e" = "$ext" ] && echo "20" && return
    done
    # Dependent extensions load last (70-)
    for e in $PRIORITY_DEPENDENT; do
        [ "$e" = "$ext" ] && echo "70" && return
    done
    # Standard extensions (50-)
    echo "50"
}

# Function to enable extension
enable_ext() {
    local ext="$1"
    local prefix=$(get_priority_prefix "$ext")
    mkdir -p "${CONF_DIR}"
    # Remove any existing .ini files for this extension (old prefixes)
    rm -f "${CONF_DIR}/"*"-${ext}.ini" "${CONF_DIR}/${ext}.ini" 2>/dev/null
    # Create new file with correct prefix
    if is_zend_ext "$ext"; then
        echo "zend_extension=${ext}.so" > "${CONF_DIR}/${prefix}-${ext}.ini"
    else
        echo "extension=${ext}.so" > "${CONF_DIR}/${prefix}-${ext}.ini"
    fi
}

# Function to disable extension
disable_ext() {
    local ext="$1"
    # Remove both prefixed and non-prefixed files
    rm -f "${CONF_DIR}/"*"-${ext}.ini" "${CONF_DIR}/${ext}.ini" 2>/dev/null
}

# Handle POST request
if [ "$REQUEST_METHOD" = "POST" ]; then
    # Read POST data
    if [ -n "$CONTENT_LENGTH" ] && [ "$CONTENT_LENGTH" -gt 0 ]; then
        read -n "$CONTENT_LENGTH" POST_DATA
    else
        POST_DATA=""
    fi

    # Parse action and ext using sed (busybox compatible)
    action=$(echo "$POST_DATA" | sed -n 's/.*action=\([^&]*\).*/\1/p')
    ext=$(echo "$POST_DATA" | sed -n 's/.*ext=\([^&]*\).*/\1/p')

    # URL decode extension name (simple decode for common chars)
    ext=$(echo "$ext" | sed 's/+/ /g; s/%2B/+/g; s/%20/ /g; s/%2F/\//g; s/%5F/_/g; s/%2D/-/g')

    echo "Content-type: application/json; charset=UTF-8"
    echo ""

    if [ "$action" = "toggle" ] && [ -n "$ext" ]; then
        # Validate extension exists
        if [ -f "${EXT_DIR}/${ext}.so" ]; then
            if is_enabled "$ext"; then
                if disable_ext "$ext"; then
                    echo "{\"success\":true,\"enabled\":false,\"ext\":\"${ext}\"}"
                else
                    echo "{\"success\":false,\"error\":\"Failed to disable extension\"}"
                fi
            else
                if enable_ext "$ext"; then
                    echo "{\"success\":true,\"enabled\":true,\"ext\":\"${ext}\"}"
                else
                    echo "{\"success\":false,\"error\":\"Failed to enable extension\"}"
                fi
            fi
        else
            echo "{\"success\":false,\"error\":\"Extension not found: ${ext}\"}"
        fi
    elif [ "$action" = "reload" ]; then
        # Create a reload flag file that the watcher will detect
        # The watcher (running as package user) will send USR2 to PHP-FPM
        RELOAD_FLAG="${CONF_DIR}/reload.flag"

        if echo "reload_requested=$(date +%s)" > "$RELOAD_FLAG" 2>/dev/null; then
            echo "{\"success\":true,\"message\":\"Rechargement demande\"}"
        else
            echo "{\"success\":false,\"error\":\"Cannot create reload flag\"}"
        fi
    else
        echo "{\"success\":false,\"error\":\"Invalid action: ${action}\"}"
    fi
    exit 0
fi

# GET request - Display HTML interface
# Count extensions
total=0
enabled=0
for so in "${EXT_DIR}"/*.so; do
    [ -f "$so" ] || continue
    ((total++))
    name=$(basename "$so" .so)
    if is_enabled "$name"; then
        ((enabled++))
    fi
done

echo "Content-type: text/html; charset=UTF-8"
echo ""

cat << 'HTMLHEAD'
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PHP 8.4 Extension Manager</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Arial, sans-serif;
            font-size: 13px; background: #f5f5f5; padding: 20px;
        }
        .header { margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 10px; }
        .header-left h1 { color: #333; font-size: 20px; margin-bottom: 5px; }
        .stats { color: #666; font-size: 13px; }
        .header-right { display: flex; gap: 10px; }
        .btn {
            padding: 8px 16px; border: none; border-radius: 4px; cursor: pointer;
            font-size: 13px; font-weight: 500; transition: all 0.2s;
        }
        .btn-primary { background: #2196f3; color: #fff; }
        .btn-primary:hover { background: #1976d2; }
        .btn-primary:disabled { background: #ccc; cursor: not-allowed; }
        .btn-success { background: #4caf50; color: #fff; }
        .btn-success:hover { background: #388e3c; }
        .search-box {
            padding: 8px 12px; border: 1px solid #ddd; border-radius: 4px;
            font-size: 13px; width: 200px;
        }
        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 8px;
        }
        .ext {
            background: #fff; padding: 10px 12px; border-radius: 4px;
            border: 1px solid #ddd; display: flex; align-items: center; gap: 10px;
            cursor: pointer; transition: all 0.2s; user-select: none;
        }
        .ext:hover { border-color: #2196f3; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .ext.enabled { border-left: 3px solid #4caf50; }
        .ext.disabled { border-left: 3px solid #ccc; }
        .ext.pending { opacity: 0.6; pointer-events: none; }
        .ext-name { font-weight: 500; flex: 1; }
        .ext.disabled .ext-name { color: #999; }
        .toggle {
            width: 36px; height: 20px; background: #ccc; border-radius: 10px;
            position: relative; transition: background 0.2s;
        }
        .toggle::after {
            content: ''; position: absolute; width: 16px; height: 16px;
            background: #fff; border-radius: 50%; top: 2px; left: 2px;
            transition: transform 0.2s;
        }
        .ext.enabled .toggle { background: #4caf50; }
        .ext.enabled .toggle::after { transform: translateX(16px); }
        .message {
            position: fixed; top: 20px; right: 20px; padding: 12px 20px;
            border-radius: 4px; color: #fff; font-weight: 500;
            animation: fadeIn 0.3s; z-index: 1000;
        }
        .message.success { background: #4caf50; }
        .message.error { background: #f44336; }
        .message.info { background: #2196f3; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }
        .changes-indicator {
            display: none; padding: 10px 20px; background: #fff3cd; color: #856404;
            border-radius: 4px; margin-bottom: 15px; border: 1px solid #ffc107;
        }
        .changes-indicator.visible { display: block; }
        .filter-bar { margin-bottom: 15px; display: flex; gap: 10px; flex-wrap: wrap; }
        .filter-btn {
            padding: 6px 12px; border: 1px solid #ddd; border-radius: 4px;
            background: #fff; cursor: pointer; font-size: 12px;
        }
        .filter-btn.active { background: #2196f3; color: #fff; border-color: #2196f3; }
        .btn-danger { background: #f44336; color: #fff; }
        .btn-danger:hover { background: #d32f2f; }
        .btn-danger:disabled, .btn-success:disabled { background: #ccc; cursor: not-allowed; }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-left">
            <h1>PHP 8.4 Extension Manager</h1>
HTMLHEAD

echo "            <p class=\"stats\"><span id=\"enabled-count\">${enabled}</span> / ${total} extensions activ&eacute;es</p>"

cat << 'HTMLMID'
        </div>
        <div class="header-right">
            <input type="text" class="search-box" id="search" placeholder="Rechercher..." oninput="filterExtensions()">
            <button class="btn btn-primary" id="restart-btn" onclick="restartService()">Appliquer &amp; Recharger</button>
        </div>
    </div>

    <div class="changes-indicator" id="changes-indicator">
        Des modifications ont &eacute;t&eacute; effectu&eacute;es. Cliquez sur "Appliquer &amp; Recharger" pour les activer.
    </div>

    <div class="filter-bar">
        <button class="filter-btn active" onclick="setFilter('all', this)">Toutes</button>
        <button class="filter-btn" onclick="setFilter('enabled', this)">Activ&eacute;es</button>
        <button class="filter-btn" onclick="setFilter('disabled', this)">D&eacute;sactiv&eacute;es</button>
        <span style="flex:1"></span>
        <button class="btn btn-success" id="enable-all-btn" onclick="enableAllExtensions()">Tout activer</button>
        <button class="btn btn-danger" id="disable-all-btn" onclick="disableAllExtensions()">Tout d&eacute;sactiver</button>
    </div>

    <div class="grid" id="extensions-grid">
HTMLMID

# List extensions
for so in "${EXT_DIR}"/*.so; do
    [ -f "$so" ] || continue
    name=$(basename "$so" .so)

    if is_enabled "$name"; then
        echo "        <div class=\"ext enabled\" data-ext=\"${name}\" onclick=\"toggleExt(this)\">"
        echo "            <span class=\"ext-name\">${name}</span>"
        echo "            <div class=\"toggle\"></div>"
        echo "        </div>"
    else
        echo "        <div class=\"ext disabled\" data-ext=\"${name}\" onclick=\"toggleExt(this)\">"
        echo "            <span class=\"ext-name\">${name}</span>"
        echo "            <div class=\"toggle\"></div>"
        echo "        </div>"
    fi
done

cat << 'HTMLFOOT'
    </div>

    <script>
        var pendingChanges = false;
        var currentFilter = 'all';

        // Dependency map: extension -> array of required extensions
        var dependencies = {
            'ev': ['sockets'],
            'event': ['sockets'],
            'msgpack': ['session'],
            'mysqli': ['mysqlnd'],
            'pdo_mysql': ['mysqlnd', 'pdo'],
            'pdo_sqlite': ['pdo'],
            'pdo_pgsql': ['pdo'],
            'redis': ['igbinary'],
            'memcached': ['igbinary', 'msgpack']
        };

        // Reverse map: extension -> array of extensions that depend on it
        var dependents = {
            'sockets': ['ev', 'event'],
            'session': ['msgpack'],
            'mysqlnd': ['mysqli', 'pdo_mysql'],
            'pdo': ['pdo_mysql', 'pdo_sqlite', 'pdo_pgsql'],
            'igbinary': ['redis', 'memcached'],
            'msgpack': ['memcached']
        };

        // Get element for extension name
        function getExtElement(extName) {
            return document.querySelector('.ext[data-ext="' + extName + '"]');
        }

        // Check if extension is enabled
        function isExtEnabled(extName) {
            var el = getExtElement(extName);
            return el && el.classList.contains('enabled');
        }

        function showMessage(text, type) {
            var existing = document.querySelector('.message');
            if (existing) existing.remove();

            var msg = document.createElement('div');
            msg.className = 'message ' + type;
            msg.textContent = text;
            document.body.appendChild(msg);

            setTimeout(function() { msg.remove(); }, 3000);
        }

        function updateChangesIndicator() {
            var indicator = document.getElementById('changes-indicator');
            indicator.className = 'changes-indicator' + (pendingChanges ? ' visible' : '');
        }

        function updateEnabledCount() {
            var count = document.querySelectorAll('.ext.enabled').length;
            document.getElementById('enabled-count').textContent = count;
        }

        // Core toggle function (no dependency handling)
        function toggleExtCore(el) {
            return new Promise(function(resolve) {
                var ext = el.getAttribute('data-ext');
                el.classList.add('pending');

                var xhr = new XMLHttpRequest();
                xhr.open('POST', 'index.cgi', true);
                xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
                xhr.onreadystatechange = function() {
                    if (xhr.readyState === 4) {
                        el.classList.remove('pending');
                        if (xhr.status === 200) {
                            try {
                                var resp = JSON.parse(xhr.responseText);
                                if (resp.success) {
                                    if (resp.enabled) {
                                        el.classList.remove('disabled');
                                        el.classList.add('enabled');
                                    } else {
                                        el.classList.remove('enabled');
                                        el.classList.add('disabled');
                                    }
                                    pendingChanges = true;
                                    updateChangesIndicator();
                                    updateEnabledCount();
                                    filterExtensions();
                                }
                                resolve(resp);
                            } catch(e) {
                                resolve({success: false, error: 'Parse error'});
                            }
                        } else {
                            resolve({success: false, error: 'Server error'});
                        }
                    }
                };
                xhr.send('action=toggle&ext=' + encodeURIComponent(ext));
            });
        }

        // Main toggle function with dependency handling
        async function toggleExt(el) {
            var ext = el.getAttribute('data-ext');
            var isEnabled = el.classList.contains('enabled');

            if (!isEnabled) {
                // ENABLING: First enable dependencies
                var deps = dependencies[ext] || [];
                for (var i = 0; i < deps.length; i++) {
                    var depEl = getExtElement(deps[i]);
                    if (depEl && !depEl.classList.contains('enabled')) {
                        showMessage('Activation de ' + deps[i] + ' (dependance)', 'info');
                        var result = await toggleExtCore(depEl);
                        if (!result.success) {
                            showMessage('Erreur activation ' + deps[i], 'error');
                            return;
                        }
                    }
                }
                // Then enable the extension itself
                var result = await toggleExtCore(el);
                if (result.success) {
                    if (deps.length > 0) {
                        showMessage(ext + ' active (avec ' + deps.join(', ') + ')', 'success');
                    }
                } else {
                    showMessage('Erreur: ' + (result.error || 'Unknown'), 'error');
                }
            } else {
                // DISABLING: First disable dependents
                var deps = dependents[ext] || [];
                for (var i = 0; i < deps.length; i++) {
                    var depEl = getExtElement(deps[i]);
                    if (depEl && depEl.classList.contains('enabled')) {
                        showMessage('Desactivation de ' + deps[i] + ' (dependant)', 'info');
                        var result = await toggleExtCore(depEl);
                        if (!result.success) {
                            showMessage('Erreur desactivation ' + deps[i], 'error');
                            return;
                        }
                    }
                }
                // Then disable the extension itself
                var result = await toggleExtCore(el);
                if (result.success) {
                    if (deps.length > 0) {
                        showMessage(ext + ' desactive (avec ' + deps.join(', ') + ')', 'success');
                    }
                } else {
                    showMessage('Erreur: ' + (result.error || 'Unknown'), 'error');
                }
            }
        }

        function restartService() {
            var btn = document.getElementById('restart-btn');
            btn.disabled = true;
            btn.textContent = 'Rechargement...';
            showMessage('Demande de rechargement...', 'info');

            // Request reload via flag file (watcher will send USR2 to PHP-FPM)
            var xhr = new XMLHttpRequest();
            xhr.open('POST', 'index.cgi', true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4) {
                    if (xhr.status === 200) {
                        try {
                            var resp = JSON.parse(xhr.responseText);
                            if (resp.success) {
                                showMessage('Configuration rechargee (USR2)', 'success');
                                pendingChanges = false;
                                updateChangesIndicator();
                                setTimeout(function() {
                                    btn.disabled = false;
                                    btn.textContent = 'Appliquer & Recharger';
                                }, 2000);
                            } else {
                                throw new Error(resp.error || 'Unknown error');
                            }
                        } catch(e) {
                            btn.disabled = false;
                            btn.textContent = 'Appliquer & Recharger';
                            showMessage('Erreur: ' + e.message, 'error');
                        }
                    } else {
                        btn.disabled = false;
                        btn.textContent = 'Appliquer & Recharger';
                        showMessage('Erreur serveur', 'error');
                    }
                }
            };
            xhr.send('action=reload');
        }

        function filterExtensions() {
            var search = document.getElementById('search').value.toLowerCase();
            var exts = document.querySelectorAll('.ext');

            exts.forEach(function(el) {
                var name = el.getAttribute('data-ext').toLowerCase();
                var matchSearch = name.indexOf(search) !== -1;
                var matchFilter = currentFilter === 'all' ||
                    (currentFilter === 'enabled' && el.classList.contains('enabled')) ||
                    (currentFilter === 'disabled' && el.classList.contains('disabled'));

                el.style.display = (matchSearch && matchFilter) ? '' : 'none';
            });
        }

        function setFilter(filter, btn) {
            currentFilter = filter;
            document.querySelectorAll('.filter-btn').forEach(function(b) {
                b.classList.remove('active');
            });
            btn.classList.add('active');
            filterExtensions();
        }

        // Activer toutes les extensions (avec ordre de dépendances)
        async function enableAllExtensions() {
            var btn = document.getElementById('enable-all-btn');
            var btnDisable = document.getElementById('disable-all-btn');
            btn.disabled = true;
            btnDisable.disabled = true;
            btn.textContent = 'En cours...';

            // Get all disabled extensions
            var allDisabled = Array.from(document.querySelectorAll('.ext.disabled'));
            var errors = [];

            // Sort: core dependencies first (session, sockets), then others, then dependents (ev, msgpack) last
            var coreExts = [];
            var dependentExts = [];
            var normalExts = [];

            allDisabled.forEach(function(el) {
                var name = el.getAttribute('data-ext');
                if (dependencies[name]) {
                    dependentExts.push(el);
                } else if (dependents[name]) {
                    coreExts.push(el);
                } else {
                    normalExts.push(el);
                }
            });

            // Enable in order: core first, normal, dependent last
            var orderedExts = coreExts.concat(normalExts).concat(dependentExts);

            for (var i = 0; i < orderedExts.length; i++) {
                var el = orderedExts[i];
                if (el.classList.contains('disabled')) {
                    var result = await toggleExtCore(el);
                    if (result && !result.success) {
                        errors.push(el.getAttribute('data-ext'));
                    }
                }
            }

            pendingChanges = true;
            updateChangesIndicator();

            btn.disabled = false;
            btnDisable.disabled = false;
            btn.textContent = 'Tout activer';

            if (errors.length > 0) {
                showMessage('Termine avec ' + errors.length + ' erreur(s)', 'error');
            } else {
                showMessage('Toutes les extensions activees', 'success');
            }
        }

        // Désactiver toutes les extensions (avec ordre de dépendances)
        async function disableAllExtensions() {
            var btn = document.getElementById('disable-all-btn');
            var btnEnable = document.getElementById('enable-all-btn');
            btn.disabled = true;
            btnEnable.disabled = true;
            btn.textContent = 'En cours...';

            // Get all enabled extensions
            var allEnabled = Array.from(document.querySelectorAll('.ext.enabled'));
            var errors = [];

            // Sort: dependents first (ev, msgpack), then others, then core (session, sockets) last
            var coreExts = [];
            var dependentExts = [];
            var normalExts = [];

            allEnabled.forEach(function(el) {
                var name = el.getAttribute('data-ext');
                if (dependencies[name]) {
                    dependentExts.push(el);
                } else if (dependents[name]) {
                    coreExts.push(el);
                } else {
                    normalExts.push(el);
                }
            });

            // Disable in order: dependents first, normal, core last
            var orderedExts = dependentExts.concat(normalExts).concat(coreExts);

            for (var i = 0; i < orderedExts.length; i++) {
                var el = orderedExts[i];
                if (el.classList.contains('enabled')) {
                    var result = await toggleExtCore(el);
                    if (result && !result.success) {
                        errors.push(el.getAttribute('data-ext'));
                    }
                }
            }

            pendingChanges = true;
            updateChangesIndicator();

            btn.disabled = false;
            btnEnable.disabled = false;
            btn.textContent = 'Tout desactiver';

            if (errors.length > 0) {
                showMessage('Termine avec ' + errors.length + ' erreur(s)', 'error');
            } else {
                showMessage('Toutes les extensions desactivees', 'success');
            }
        }
    </script>
</body>
</html>
HTMLFOOT

exit 0
