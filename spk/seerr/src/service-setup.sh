# Seerr service setup

SEERR_HOME="${SYNOPKG_PKGDEST}/share/seerr"
NODE_BIN="/var/packages/Node.js_v22/target/usr/local/bin/node"

# Service configuration
SERVICE_COMMAND="${NODE_BIN} dist/index.js"
SVC_CWD="${SEERR_HOME}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

# Environment variables passed to the service
export NODE_ENV=production
export CONFIG_DIRECTORY="${SYNOPKG_PKGVAR}/config"
export PORT=${SERVICE_PORT}

service_postinst () {
    mkdir -p "${SYNOPKG_PKGVAR}/config"
}
