#!/bin/bash
# Uptime Kuma service setup
#
# Environment variables provided by the framework:
#   SYNOPKG_PKGDEST  - Install directory (/var/packages/uptime-kuma/target)
#   SYNOPKG_PKGVAR   - Data directory (/var/packages/uptime-kuma/var)
#   SERVICE_PORT     - Configured service port (default 3001)
#
# Note: SYNOPKG_PKGVAR is automatically preserved during upgrades by DSM7.

# Node.js from the Node.js_v22 dependency package
NODE="/var/packages/Node.js_v22/target/usr/local/bin/node"

# Application paths
UPTIME_KUMA_DIR="${SYNOPKG_PKGDEST}/share/uptime-kuma"
SERVER_JS="${UPTIME_KUMA_DIR}/server/server.js"

# Service command configuration
SERVICE_COMMAND="${NODE} ${SERVER_JS}"
SVC_CWD="${UPTIME_KUMA_DIR}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y
SVC_KEEP_LOG=y

# Environment variables for Uptime Kuma
# See: https://github.com/louislam/uptime-kuma/wiki/Environment-Variables
export UPTIME_KUMA_HOST=0.0.0.0
export UPTIME_KUMA_PORT="${SERVICE_PORT:-3001}"
export DATA_DIR="${SYNOPKG_PKGVAR}"
export NODE_ENV=production
export PATH="/var/packages/Node.js_v22/target/usr/local/bin:${PATH}"

service_postinst() {
    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        # Create upload subdirectory for user-uploaded assets
        mkdir -p "${SYNOPKG_PKGVAR}/upload" 2>/dev/null
    fi
}

service_prestart() {
    if [ ! -x "${NODE}" ]; then
        echo "Node.js_v22 is not installed" >&2
        return 1
    fi
    if [ ! -f "${SERVER_JS}" ]; then
        echo "server.js not found - reinstall package" >&2
        return 1
    fi
    return 0
}
