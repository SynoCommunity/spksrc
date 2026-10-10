# Actual Budget service setup
#
# Environment variables provided by the framework:
#   SYNOPKG_PKGDEST  - Install directory (/var/packages/actual-budget/target)
#   SYNOPKG_PKGVAR   - Data directory (/var/packages/actual-budget/var)
#   SERVICE_PORT     - Configured service port
#
# Note: SYNOPKG_PKGVAR is automatically preserved during upgrades by DSM7.

# Node.js from the Node.js_v22 dependency package
NODE="/var/packages/Node.js_v22/target/usr/local/bin/node"

# Application paths
ACTUAL_DIR="${SYNOPKG_PKGDEST}/share/actual-budget"
SERVER_JS="${ACTUAL_DIR}/build/bin/actual-server.js"

# Service command configuration
SERVICE_COMMAND="${NODE} ${SERVER_JS}"
SVC_CWD="${ACTUAL_DIR}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y
SVC_KEEP_LOG=y

# Environment variables for Actual Budget
# See: https://github.com/actualbudget/actual/tree/master/packages/sync-server
export PORT="${SERVICE_PORT}"
export ACTUAL_DATA_DIR="${SYNOPKG_PKGVAR}/data"
export NODE_ENV=production

service_prestart() {
    if [ ! -x "${NODE}" ]; then
        echo "Node.js_v22 is not installed" >&2
        return 1
    fi
    if [ ! -f "${SERVER_JS}" ]; then
        echo "actual-server.js not found - reinstall package" >&2
        return 1
    fi
    mkdir -p "${ACTUAL_DATA_DIR}" 2>/dev/null
    return 0
}
