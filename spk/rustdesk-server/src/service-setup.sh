# RustDesk Server service setup

HBBS="${SYNOPKG_PKGDEST}/bin/hbbs"
HBBR="${SYNOPKG_PKGDEST}/bin/hbbr"
HBBS_ENV="${SYNOPKG_PKGVAR}/hbbs.env"

# Both services run from data directory so keys are stored there
SVC_CWD="${SYNOPKG_PKGVAR}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

# Source environment file if it exists (export all variables)
if [ -f "${HBBS_ENV}" ]; then
    set -a
    . "${HBBS_ENV}"
    set +a
fi

# SERVICE_COMMAND supports multiple commands (newline separated)
# Start relay server first, then ID server
SERVICE_COMMAND=$(printf "${HBBR}\n${HBBS}")

service_postinst()
{
    # Install default environment file if not present
    if [ ! -f "${HBBS_ENV}" ]; then
        cp "${SYNOPKG_PKGDEST}/share/hbbs.env" "${HBBS_ENV}"
    fi

    # Get NAS IP for display
    INTERNAL_IP=$(ip -4 route get 8.8.8.8 2>/dev/null | awk '/8.8.8.8/ {for (i=1; i<NF; i++) if ($i=="src") print $(i+1)}')
    INTERNAL_IP=${INTERNAL_IP:-<NAS_IP>}

    echo "RustDesk Server installed successfully."
    echo "ID/Rendezvous server will run on ports 21115-21116, 21118 (WebSocket)"
    echo "Relay server will run on port 21117, 21119 (WebSocket)"
    echo ""
    echo "After starting the service, find your public key in:"
    echo "  ${SYNOPKG_PKGVAR}/id_ed25519.pub"
    echo ""
    echo "Configure RustDesk clients with:"
    echo "  ID Server: ${INTERNAL_IP}:21116"
    echo "  Relay Server: ${INTERNAL_IP}:21117"
    echo "  Key: (contents of id_ed25519.pub)"
    echo ""
    echo "Configuration file: ${HBBS_ENV}"
    echo "Edit this file to customize server settings (e.g., ALWAYS_USE_RELAY=Y)."
}
