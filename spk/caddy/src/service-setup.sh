PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"

CADDY_BIN="${SYNOPKG_PKGDEST}/bin/caddy"
CADDY_CONFIG="${SYNOPKG_PKGVAR}/Caddyfile"
CADDY_DATA_DIR="${SYNOPKG_PKGVAR}/data"
CADDY_CONFIG_DIR="${SYNOPKG_PKGVAR}/config"

# Caddy keeps its ACME/TLS state and autosaved config under these; point
# them at the package's own var directory instead of $HOME.
export XDG_DATA_HOME="${CADDY_DATA_DIR}"
export XDG_CONFIG_HOME="${CADDY_CONFIG_DIR}"
export HOME="${SYNOPKG_PKGVAR}"

SERVICE_COMMAND="${CADDY_BIN} run --environ --config ${CADDY_CONFIG} --adapter caddyfile"
SVC_BACKGROUND=yes
SVC_WRITE_PID=yes

service_postinst ()
{
    mkdir -p "${CADDY_DATA_DIR}" "${CADDY_CONFIG_DIR}"
    if [ ! -f "${CADDY_CONFIG}" ]; then
        cp "${SYNOPKG_PKGVAR}/Caddyfile.default" "${CADDY_CONFIG}"
    fi
}

service_prestart ()
{
    mkdir -p "${CADDY_DATA_DIR}" "${CADDY_CONFIG_DIR}"
    if [ ! -f "${CADDY_CONFIG}" ]; then
        echo "Configuration file ${CADDY_CONFIG} missing" >&2
        return 1
    fi
}
