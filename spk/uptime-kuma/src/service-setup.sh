#!/bin/bash
# service-setup.sh — Uptime Kuma service lifecycle hooks
#
# Sourced by the spksrc generic installer and start-stop-status scripts.
# Provides package-specific configuration and hook functions for:
#   - Installation (first-time and upgrade)
#   - Service start/stop
#   - Upgrade with data preservation
#
# Environment variables provided by the framework:
#   SYNOPKG_PKGNAME    — Package name ("uptime-kuma")
#   SYNOPKG_PKGDEST    — Install dir (/var/packages/uptime-kuma/target)
#   SYNOPKG_PKGVAR     — Data dir (/var/packages/uptime-kuma/var)
#   SYNOPKG_PKGHOME    — Home dir (/var/packages/uptime-kuma/home)
#   SYNOPKG_PKGDEST_VOL — Volume (/volume1, /volume2)
#   SYNOPKG_PKG_STATUS — Current operation (INSTALL, UPGRADE, UNINSTALL)
#   SERVICE_PORT       — Configured service port (default 3001)
#   LOG_FILE           — Log file path
#   TMP_DIR            — Temporary directory for upgrades
#   PID_FILE           — PID file path

# ---------------------------------------------------------------------------
# Node.js from the Node.js_v22 dependency package
# ---------------------------------------------------------------------------
NODE="/var/packages/Node.js_v22/target/usr/local/bin/node"

# ---------------------------------------------------------------------------
# Application paths
# ---------------------------------------------------------------------------
UPTIME_KUMA_DIR="${SYNOPKG_PKGDEST}/share/uptime-kuma"
SERVER_JS="${UPTIME_KUMA_DIR}/server/server.js"

# ---------------------------------------------------------------------------
# Service command configuration
# ---------------------------------------------------------------------------
SERVICE_COMMAND="${NODE} ${SERVER_JS}"
SVC_CWD="${UPTIME_KUMA_DIR}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

# Keep logs across restarts so users can review history
SVC_KEEP_LOG=y

# ---------------------------------------------------------------------------
# Environment exports for Uptime Kuma
# ---------------------------------------------------------------------------
export UPTIME_KUMA_HOST=0.0.0.0
export UPTIME_KUMA_PORT="${SERVICE_PORT:-3001}"
export DATA_DIR="${SYNOPKG_PKGVAR}"
export NODE_ENV=production

# Add Node.js_v22 to PATH for child processes
export PATH="/var/packages/Node.js_v22/target/usr/local/bin:${PATH}"

# ---------------------------------------------------------------------------
# Helper: write a timestamped message to the log file
# ---------------------------------------------------------------------------
log_msg() {
    if [ -n "${LOG_FILE}" ]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') [uptime-kuma] $1" >> "${LOG_FILE}"
    fi
}

# ---------------------------------------------------------------------------
# service_postinst — Post-installation setup
#   Runs after package files are extracted.
# ---------------------------------------------------------------------------
service_postinst() {
    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        log_msg "service_postinst: Performing first-time installation setup"

        # Ensure data directory exists
        if [ ! -d "${SYNOPKG_PKGVAR}" ]; then
            mkdir -p "${SYNOPKG_PKGVAR}"
            log_msg "service_postinst: Created data directory ${SYNOPKG_PKGVAR}"
        fi

        # Create upload subdirectory for user-uploaded assets
        mkdir -p "${SYNOPKG_PKGVAR}/upload" 2>/dev/null

        log_msg "service_postinst: Initial setup complete"
        log_msg "service_postinst: Data directory: ${SYNOPKG_PKGVAR}"
        log_msg "service_postinst: Install directory: ${SYNOPKG_PKGDEST}"
        log_msg "service_postinst: Service port: ${SERVICE_PORT:-3001}"

    elif [ "${SYNOPKG_PKG_STATUS}" = "UPGRADE" ]; then
        log_msg "service_postinst: Upgrade installation completed"
    fi
}

# ---------------------------------------------------------------------------
# service_prestart — Pre-start checks
#   Runs before the service starts. Return non-zero to prevent start.
# ---------------------------------------------------------------------------
service_prestart() {
    log_msg "service_prestart: Preparing to start Uptime Kuma"

    # Verify Node.js is accessible from the dependency package
    if [ ! -x "${NODE}" ]; then
        log_msg "service_prestart: ERROR - Node.js not found at ${NODE}"
        echo "Node.js_v22 package is not available. Please ensure Node.js_v22 is installed." >&2
        return 1
    fi

    # Verify the main server script exists
    if [ ! -f "${SERVER_JS}" ]; then
        log_msg "service_prestart: ERROR - server.js not found at ${SERVER_JS}"
        echo "Uptime Kuma server.js not found. The package may be corrupted — try reinstalling." >&2
        return 1
    fi

    # Verify data directory is accessible and writable
    if [ ! -d "${SYNOPKG_PKGVAR}" ]; then
        mkdir -p "${SYNOPKG_PKGVAR}"
        log_msg "service_prestart: Created missing data directory ${SYNOPKG_PKGVAR}"
    fi

    if [ ! -w "${SYNOPKG_PKGVAR}" ]; then
        log_msg "service_prestart: ERROR - Data directory not writable: ${SYNOPKG_PKGVAR}"
        echo "Data directory is not writable: ${SYNOPKG_PKGVAR}" >&2
        return 1
    fi

    # Re-export environment variables for the service process
    export UPTIME_KUMA_HOST=0.0.0.0
    export UPTIME_KUMA_PORT="${SERVICE_PORT:-3001}"
    export DATA_DIR="${SYNOPKG_PKGVAR}"
    export NODE_ENV=production
    export PATH="/var/packages/Node.js_v22/target/usr/local/bin:${PATH}"

    log_msg "service_prestart: Environment configured — host=${UPTIME_KUMA_HOST}, port=${UPTIME_KUMA_PORT}, data=${DATA_DIR}"
    return 0
}

# ---------------------------------------------------------------------------
# service_poststop — Post-stop cleanup
#   Runs after the service has stopped.
# ---------------------------------------------------------------------------
service_poststop() {
    log_msg "service_poststop: Uptime Kuma stopped"

    # Clean up stale PID file if the process is no longer running
    if [ -n "${PID_FILE}" ] && [ -f "${PID_FILE}" ]; then
        PID=$(cat "${PID_FILE}" 2>/dev/null)
        if [ -n "${PID}" ] && ! kill -0 "${PID}" 2>/dev/null; then
            rm -f "${PID_FILE}"
            log_msg "service_poststop: Cleaned up stale PID file"
        fi
    fi
}

# ---------------------------------------------------------------------------
# service_preupgrade — Pre-upgrade: back up data
#   Runs before the old package is removed during an upgrade.
#   TMP_DIR is provided by the framework for temporary storage.
# ---------------------------------------------------------------------------
service_preupgrade() {
    log_msg "service_preupgrade: Starting data backup for upgrade"

    if [ -z "${TMP_DIR}" ]; then
        log_msg "service_preupgrade: ERROR - TMP_DIR not set by framework"
        echo "Upgrade failed: temporary directory not available."
        return 1
    fi

    # Back up the entire data directory
    if [ -d "${SYNOPKG_PKGVAR}" ]; then
        log_msg "service_preupgrade: Backing up ${SYNOPKG_PKGVAR} to ${TMP_DIR}/var_backup"
        mkdir -p "${TMP_DIR}/var_backup"

        # Use cp -a to preserve permissions, ownership, and timestamps
        if cp -a "${SYNOPKG_PKGVAR}/." "${TMP_DIR}/var_backup/" 2>/dev/null; then
            BACKUP_SIZE=$(du -sh "${TMP_DIR}/var_backup" 2>/dev/null | awk '{print $1}')
            log_msg "service_preupgrade: Data backup completed (${BACKUP_SIZE})"
        else
            log_msg "service_preupgrade: WARNING - Some files may not have been backed up"
        fi
    else
        log_msg "service_preupgrade: No data directory to back up"
    fi

    return 0
}

# ---------------------------------------------------------------------------
# service_postupgrade — Post-upgrade: restore data
#   Runs after the new package files are in place.
# ---------------------------------------------------------------------------
service_postupgrade() {
    log_msg "service_postupgrade: Starting data restoration after upgrade"

    if [ -z "${TMP_DIR}" ]; then
        log_msg "service_postupgrade: ERROR - TMP_DIR not set by framework"
        echo "Upgrade warning: temporary directory not available for restore."
        return 1
    fi

    # Restore the backed-up data directory
    if [ -d "${TMP_DIR}/var_backup" ]; then
        log_msg "service_postupgrade: Restoring data from ${TMP_DIR}/var_backup"

        # Ensure destination exists
        mkdir -p "${SYNOPKG_PKGVAR}"

        if cp -a "${TMP_DIR}/var_backup/." "${SYNOPKG_PKGVAR}/" 2>/dev/null; then
            log_msg "service_postupgrade: Data restoration completed successfully"
        else
            log_msg "service_postupgrade: WARNING - Some files may not have been restored"
        fi

        # Clean up temp backup
        rm -rf "${TMP_DIR}/var_backup"
        log_msg "service_postupgrade: Temporary backup cleaned up"
    else
        log_msg "service_postupgrade: No backup found to restore"
    fi

    log_msg "service_postupgrade: Upgrade process complete"
    return 0
}
