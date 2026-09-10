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

# Let the (non-root) service user bind ports <1024, so the default
# Caddyfile can be switched to :80/:443 without running Caddy as root.
# Upgrades replace the binary, which drops any previously granted
# capability, so this needs to run again on every postinst/postupgrade.
# Non-fatal: a filesystem without xattr support just means the Caddyfile
# has to stick to ports >1024.
grant_low_port_capability ()
{
    if command -v setcap >/dev/null 2>&1; then
        setcap 'cap_net_bind_service=+ep' "${CADDY_BIN}" || \
            echo "WARNING: setcap failed on ${CADDY_BIN}; binding ports <1024 (80/443) will require editing ${CADDY_CONFIG} to use a port >1024 instead."
    fi
}

service_postinst ()
{
    mkdir -p "${CADDY_DATA_DIR}" "${CADDY_CONFIG_DIR}"
    if [ ! -f "${CADDY_CONFIG}" ]; then
        cp "${SYNOPKG_PKGVAR}/Caddyfile.default" "${CADDY_CONFIG}"
    fi
    grant_low_port_capability
}

service_postupgrade ()
{
    grant_low_port_capability
}

service_prestart ()
{
    mkdir -p "${CADDY_DATA_DIR}" "${CADDY_CONFIG_DIR}"
    if [ ! -f "${CADDY_CONFIG}" ]; then
        echo "Configuration file ${CADDY_CONFIG} missing" >&2
        return 1
    fi
}
