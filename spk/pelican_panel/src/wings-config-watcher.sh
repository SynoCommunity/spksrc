#!/bin/sh
#
# Wings Config Watcher - Automatically fixes Wings config for Docker-in-Docker
# Runs as a background daemon, watching for config changes from the Panel
#

PACKAGE="pelican_panel"
VAR_DIR="/var/packages/${PACKAGE}/var"
DATA_DIR="${VAR_DIR}/data"
WINGS_CONFIG="${DATA_DIR}/wings/config.yml"
LOG_FILE="${VAR_DIR}/${PACKAGE}.log"
PID_FILE="${VAR_DIR}/wings-watcher.pid"
CHECK_INTERVAL=5  # Check every 5 seconds

log() {
    printf '%s [watcher] %s\n' "$(date '+%Y-%m-%dT%H:%M:%S%z')" "$1" >> "${LOG_FILE}" 2>/dev/null
}

# Check if config needs fixing (returns 0 if fixes needed)
config_needs_fix() {
    [ ! -f "${WINGS_CONFIG}" ] && return 1

    # Check for any of the incorrect default values
    if grep -q "root_directory: /var/lib/pelican" "${WINGS_CONFIG}" 2>/dev/null || \
       grep -q "/var/lib/pelican/archives" "${WINGS_CONFIG}" 2>/dev/null || \
       grep -q "/var/lib/pelican/backups" "${WINGS_CONFIG}" 2>/dev/null || \
       grep -q "/var/log/pelican" "${WINGS_CONFIG}" 2>/dev/null || \
       grep -q "tmp_directory: /tmp/pelican" "${WINGS_CONFIG}" 2>/dev/null || \
       grep -q "mount_passwd: true" "${WINGS_CONFIG}" 2>/dev/null || \
       grep -q "allowed_origins: \[\]" "${WINGS_CONFIG}" 2>/dev/null || \
       grep -q "ignore_panel_config_updates: false" "${WINGS_CONFIG}" 2>/dev/null || \
       grep -q "port: 8445$" "${WINGS_CONFIG}" 2>/dev/null; then
        return 0  # Fixes needed
    fi
    return 1  # No fixes needed
}

# Apply all Docker-in-Docker fixes
apply_fixes() {
    log "Applying Docker-in-Docker fixes to Wings config..."

    # FIX 1: API Port - Panel generates 8445 (external) but container listens on 8080 (internal)
    sed -i 's/port: 8445$/port: 8080/' "${WINGS_CONFIG}"

    # FIX 2: System paths - Use host paths instead of container paths
    sed -i "s|/var/lib/pelican/volumes|${DATA_DIR}/servers|g" "${WINGS_CONFIG}"
    sed -i "s|/var/lib/pelican/backups|${DATA_DIR}/backups|g" "${WINGS_CONFIG}"
    sed -i "s|/var/lib/pelican/archives|${DATA_DIR}/archives|g" "${WINGS_CONFIG}"
    sed -i "s|/var/log/pelican|${DATA_DIR}/wings-logs|g" "${WINGS_CONFIG}"

    # Fix root_directory
    sed -i "s|root_directory: /var/lib/pelican$|root_directory: ${DATA_DIR}|" "${WINGS_CONFIG}"
    sed -i "s|root_directory: /var/lib/pelican\s*$|root_directory: ${DATA_DIR}|" "${WINGS_CONFIG}"

    # FIX 3: Disable mount_passwd - the passwd_file path doesn't exist on host
    sed -i 's/mount_passwd: true/mount_passwd: false/g' "${WINGS_CONFIG}"

    # FIX 4: tmp_directory - Must be a host path for install scripts
    sed -i "s|tmp_directory: /tmp/pelican$|tmp_directory: ${DATA_DIR}/tmp|" "${WINGS_CONFIG}"
    sed -i "s|tmp_directory: /tmp/pelican\s*$|tmp_directory: ${DATA_DIR}/tmp|" "${WINGS_CONFIG}"

    # FIX 5: Fix allowed_origins for WebSocket - replace empty array
    sed -i 's/allowed_origins: \[\]/allowed_origins:\n  - "*"/' "${WINGS_CONFIG}"

    # FIX 6: Prevent Panel from overwriting our config fixes
    sed -i 's/ignore_panel_config_updates: false/ignore_panel_config_updates: true/' "${WINGS_CONFIG}"

    # Create required directories
    mkdir -p "${DATA_DIR}/servers" "${DATA_DIR}/backups" "${DATA_DIR}/archives" "${DATA_DIR}/wings-logs" "${DATA_DIR}/tmp" 2>/dev/null || true
    chmod 777 "${DATA_DIR}/tmp" 2>/dev/null || true

    log "Wings config fixes applied successfully"
}

# Restart Wings container
restart_wings() {
    log "Restarting Wings container to apply changes..."
    docker restart pelican_panel-wings-1 >> "${LOG_FILE}" 2>&1
    if [ $? -eq 0 ]; then
        log "Wings container restarted successfully"
    else
        log "Warning: Failed to restart Wings container"
    fi
}

# Main watcher loop
watch_config() {
    log "Wings config watcher started (PID: $$)"
    echo $$ > "${PID_FILE}"

    LAST_HASH=""

    while true; do
        if [ -f "${WINGS_CONFIG}" ]; then
            # Calculate current file hash
            CURRENT_HASH=$(md5sum "${WINGS_CONFIG}" 2>/dev/null | cut -d' ' -f1)

            # Check if file changed
            if [ "${CURRENT_HASH}" != "${LAST_HASH}" ]; then
                if [ -n "${LAST_HASH}" ]; then
                    log "Wings config file changed, checking if fixes needed..."
                fi

                # Check if fixes are needed
                if config_needs_fix; then
                    apply_fixes
                    # Update hash after our changes
                    CURRENT_HASH=$(md5sum "${WINGS_CONFIG}" 2>/dev/null | cut -d' ' -f1)
                    # Restart Wings to apply
                    restart_wings
                fi

                LAST_HASH="${CURRENT_HASH}"
            fi
        fi

        sleep ${CHECK_INTERVAL}
    done
}

# Handle signals
cleanup() {
    log "Wings config watcher stopping..."
    rm -f "${PID_FILE}"
    exit 0
}

trap cleanup TERM INT QUIT

# Start watching
watch_config
