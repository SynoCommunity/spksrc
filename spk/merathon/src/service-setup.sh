# Merathon service (see packaging/spksrc/README.md). Variables provided by spksrc: SYNOPKG_PKGDEST, SYNOPKG_PKGVAR,
# SHARE_PATH (the shared folder chosen in the wizard), and the wizard_* values at install time.

CONFIG_FILE="${SYNOPKG_PKGVAR}/config.env"

SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/merathon-server"
SVC_BACKGROUND=yes
SVC_WRITE_PID=yes

# Settings written at install time (access token, folders, terminal): exported to the service, read again at each start.
if [ -f "${CONFIG_FILE}" ]; then
    set -a
    . "${CONFIG_FILE}"
    set +a
fi
export MERATHON_DATA_DIR="${SYNOPKG_PKGVAR}/data"
export MERATHON_WEB_DIR="${SYNOPKG_PKGDEST}/web"

# Only http(s) and URL characters: the address ends up in a web page (app/address.js)
valid_public_url ()
{
    case "$1" in
        http://?* | https://?*)
            case "$1" in *[!A-Za-z0-9._~:/?#@!\$\&\(\)*+,\;=%-]*) return 1 ;; esac
            return 0 ;;
    esac
    return 1
}

# Address opened by the DSM menu icon (see src/app/open.js): rewritten at each start, since an upgrade replaces the
# package folder and the address can be changed in config.env (MERATHON_PUBLIC_URL)
service_prestart ()
{
    url="${MERATHON_PUBLIC_URL}"
    valid_public_url "${url}" || url=""
    port="${MERATHON_BIND##*:}"
    case "${port}" in "" | *[!0-9]*) port=8765 ;; esac
    printf 'window.MERATHON_URL = "%s";\nwindow.MERATHON_PORT = "%s";\n' "${url}" "${port}" > "${SYNOPKG_PKGDEST}/app/address.js" \
        || echo "Could not write ${SYNOPKG_PKGDEST}/app/address.js"
}

service_postinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        # First release: token sign-in only (the server's "DSM session" mode stays experimental, out of the wizard)
        auth=token
        if [ "${#wizard_token}" -lt 16 ]; then
            echo "The access token needs 16 characters or more. / Le jeton d'accès doit faire 16 caractères au moins." >> "${SYNOPKG_TEMP_LOGFILE}"
            exit 1
        fi
        if [ -n "${wizard_public_url}" ] && ! valid_public_url "${wizard_public_url}"; then
            echo "Invalid Merathon address: it must start with http:// or https://. / Adresse de Merathon invalide." >> "${SYNOPKG_TEMP_LOGFILE}"
            exit 1
        fi
        terminal=0
        [ "${wizard_terminal}" = "true" ] && terminal=1

        mkdir -p "${SYNOPKG_PKGVAR}/data"
        # Values between single quotes: the file is sourced, and a token with a space, ';', '$' or a quote would otherwise be cut
        quote() { printf "'"; printf '%s' "$1" | sed -e "s/'/'\"'\"'/g"; printf "'"; }
        # Holds the access token: readable by the service user only
        umask 077
        {
            echo "MERATHON_BIND=0.0.0.0:${SERVICE_PORT:-8765}"
            echo "MERATHON_AUTH=$(quote "${auth}")"
            echo "MERATHON_TOKEN=$(quote "${wizard_token}")"
            echo "MERATHON_ALLOWED_ROOTS=$(quote "${SHARE_PATH}")"
            echo "MERATHON_TERMINAL=${terminal}"
            echo "MERATHON_PUBLIC_URL=$(quote "${wizard_public_url}")"
        } > "${CONFIG_FILE}"
    fi
}
