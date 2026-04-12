#!/bin/bash

# Get the NAS IP address for display
INTERNAL_IP=$(ip -4 route get 8.8.8.8 2>/dev/null | awk '/8.8.8.8/ {for (i=1; i<NF; i++) if ($i=="src") print $(i+1)}')
INTERNAL_IP=${INTERNAL_IP:-<NAS_IP>}

page_append ()
{
    if [ -z "$1" ]; then
        echo "$2"
    elif [ -z "$2" ]; then
        echo "$1"
    else
        echo "$1,$2"
    fi
}

PAGE_CONFIG=$(/bin/cat<<EOF
{
    "step_title": "RustDesk Server Information",
    "items": [{
        "desc": "RustDesk Server provides ID/Rendezvous and Relay services for RustDesk remote desktop clients.<br><br><b>Default Ports:</b><br>• 21115 (TCP) - NAT type test<br>• 21116 (TCP+UDP) - ID/Rendezvous server<br>• 21117 (TCP) - Relay server<br>• 21118 (TCP) - ID server WebSocket for web clients<br>• 21119 (TCP) - Relay server WebSocket for web clients<br><br>Ensure these ports are open in your firewall and forwarded on your router for remote access."
    }]
}
EOF
)

PAGE_CLIENT=$(/bin/cat<<EOF
{
    "step_title": "Client Configuration",
    "items": [{
        "desc": "After installation, configure your RustDesk clients with:<br><br><b>ID Server:</b> ${INTERNAL_IP}:21116<br><b>Relay Server:</b> ${INTERNAL_IP}:21117<br><b>Key:</b> Found in package data folder after first start<br><br>The public key file (id_ed25519.pub) will be created when the service first starts.<br>You can view it via SSH at: <code>/var/packages/rustdesk-server/var/id_ed25519.pub</code>"
    }]
}
EOF
)

main ()
{
    local install_page=""
    install_page=$(page_append "$install_page" "$PAGE_CONFIG")
    install_page=$(page_append "$install_page" "$PAGE_CLIENT")
    echo "[$install_page]" > "${SYNOPKG_TEMP_LOGFILE}"
}

main "$@"
