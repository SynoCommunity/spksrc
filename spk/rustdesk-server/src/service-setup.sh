# RustDesk Server service setup

HBBS="${SYNOPKG_PKGDEST}/bin/hbbs"
HBBR="${SYNOPKG_PKGDEST}/bin/hbbr"

# Both services run from data directory so keys are stored there
SVC_CWD="${SYNOPKG_PKGVAR}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

# SERVICE_COMMAND supports multiple commands (newline separated)
# Start relay server first, then ID server
SERVICE_COMMAND=$(printf "${HBBR}\n${HBBS}")

service_postinst()
{
    # Get NAS IP for display
    INTERNAL_IP=$(ip -4 route get 8.8.8.8 2>/dev/null | awk '/8.8.8.8/ {for (i=1; i<NF; i++) if ($i=="src") print $(i+1)}')
    INTERNAL_IP=${INTERNAL_IP:-<NAS_IP>}

    echo "RustDesk Server installed successfully."
    echo "ID/Rendezvous server will run on ports 21115-21116"
    echo "Relay server will run on port 21117"
    echo ""
    echo "After starting the service, find your public key in:"
    echo "  ${SYNOPKG_PKGVAR}/id_ed25519.pub"
    echo ""
    echo "Configure RustDesk clients with:"
    echo "  ID Server: ${INTERNAL_IP}:21116"
    echo "  Relay Server: ${INTERNAL_IP}:21117"
    echo "  Key: (contents of id_ed25519.pub)"
}
