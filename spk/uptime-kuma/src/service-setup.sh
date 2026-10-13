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

# Service command configuration
SERVER_JS="./server/server.js"
SERVICE_COMMAND="${NODE} ${SERVER_JS}"
SVC_CWD="${SYNOPKG_PKGDEST}/share/uptime-kuma"
SVC_BACKGROUND=y
SVC_WRITE_PID=y
SVC_KEEP_LOG=y

# Environment variables for Uptime Kuma
# See: https://github.com/louislam/uptime-kuma/wiki/Environment-Variables
export UPTIME_KUMA_HOST=0.0.0.0
export UPTIME_KUMA_PORT="${SERVICE_PORT}"
export DATA_DIR="${SYNOPKG_PKGVAR}"
export NODE_ENV=production

service_postinst() {
    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        # Create upload subdirectory for user-uploaded assets
        mkdir -p "${SYNOPKG_PKGVAR}/upload"
    fi
}
