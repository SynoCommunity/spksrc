# Seerr service setup

SEERR_HOME="${SYNOPKG_PKGDEST}/share/seerr"
NODE_BIN="/usr/local/bin/node"

# Service configuration
SERVICE_COMMAND="${NODE_BIN} dist/index.js"
SVC_CWD="${SEERR_HOME}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

# Environment variables passed to the service
export NODE_ENV=production
export CONFIG_DIRECTORY="${SYNOPKG_PKGVAR}/config"
export PORT=5055

service_postinst () {
    mkdir -p "${SYNOPKG_PKGVAR}/config"
}
