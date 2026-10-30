# Seerr service setup

SEERR_HOME="${SYNOPKG_PKGDEST}/share/seerr"
NODE_BIN="/var/packages/Node.js_v22/target/usr/local/bin/node"
SEERR_CONFIG="${SYNOPKG_PKGVAR}/config"
SEERR_ENV="${SEERR_CONFIG}/seerr.env"

# Service configuration
SERVICE_COMMAND="${NODE_BIN} dist/index.js"
SVC_CWD="${SEERR_HOME}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

# Environment variables passed to the service
export NODE_ENV=production
export CONFIG_DIRECTORY="${SEERR_CONFIG}"
export PORT="${SERVICE_PORT}"

# Source custom environment variables from config file (if it exists).
# Values are captured literally so special characters (e.g. in database
# passwords) are never interpreted by the shell.
if [ -f "${SEERR_ENV}" ]; then
    while IFS= read -r line || [ -n "${line}" ]; do
        case "${line}" in
            ''|'#'*) continue ;;
            *=*) key=${line%%=*}; value=${line#*=} ;;
            *) continue ;;
        esac
        case "${key}" in
            ''|[!A-Za-z_]*|*[!A-Za-z0-9_]*) continue ;;
        esac
        case "${value}" in
            \'*\'|\"*\") value=${value#?}; value=${value%?} ;;
        esac
        export "${key}=${value}"
    done < "${SEERR_ENV}"
fi

service_postinst () {
    mkdir -p "${SEERR_CONFIG}"
    # Copy default env file if it doesn't exist (preserves user config on upgrade)
    if [ ! -f "${SEERR_ENV}" ]; then
        cp -f "${SYNOPKG_PKGDEST}/share/seerr.env" "${SEERR_ENV}"
    fi
}
