# shellcheck disable=SC2129
SERVERPORT=51820
NETWORK=172.23.0.1/24 # why 172.23 ? because Synology SRM uses 172.22 and 172.21 for OpenVPN and L2TP/IPsec
INTERFACE=eth0
# PID_FILE="${SYNOPKG_PKGDEST}/var/wireguard.pid"

config() {
    # if the config does not exist make one
    if [ ! -f "${SYNOPKG_PKGDEST}/var/wg0.conf" ]; then
        echo "Creating config file" >> "${LOG_FILE}" 2>&1
        DDNS=$(grep -m 1 hostname= /etc/ddns.conf | cut -d = -f 2)
        if [ -z "$DDNS" ]; then
            DDNS=$(nslookup myip.opendns.com resolver1.opendns.com | tail -n +3 | sed -n 's/Address .:\s*//p') || DDNS=$(wget -qO- https://checkip.amazonaws.com)
        fi
        echo "Endpoint = $DDNS" >> "${LOG_FILE}" 2>&1
        server_privkey=$(wg genkey)
        client_privkey=$(wg genkey)
cat<<EOF > "${SYNOPKG_PKGDEST}/var/wg0.conf"
# NOTICE - Work in Progress
# WireGuard is not yet complete. You should not rely on this code.
# It has not undergone proper degrees of security auditing and the protocol
# is still subject to change. We're working toward a stable 1.0 release,
# but that time has not yet come. There are experimental snapshots tagged
# with "0.0.YYYYMMDD", but these should not be considered real releases and
# they may contain security vulnerabilities (which would not be eligible for CVEs,
# since this is pre-release snapshot software).
# However, if you're interested in helping out, we could really use your help
# and we readily welcome any form of feedback and review.
# There's currently quite a bit of work to do on the project todo list,
# and the more folks testing this out, the better.

[Interface]
Address = $NETWORK
ListenPort = $SERVERPORT
PrivateKey = $server_privkey
SaveConfig = false
PostUp = iptables -A SYNO_FORWARD_ACCEPT -i %i -j ACCEPT; iptables -t nat -A POSTROUTING -o $INTERFACE -j MASQUERADE
PostDown = iptables -D SYNO_FORWARD_ACCEPT -i %i -j ACCEPT; iptables -t nat -D POSTROUTING -o $INTERFACE -j MASQUERADE

[Peer]
PublicKey = $(echo "$client_privkey" | wg pubkey)
AllowedIPs = 172.23.0.2/32 # select a unique ip inside of $NETWORK

## Sample Client Configuration ##
## [Interface]
## PrivateKey = $client_privkey
## Address = 172.23.0.2/32 # select a unique ip inside of $NETWORK
## DNS = 1.1.1.1
##
## [Peer]
## PublicKey = $(echo "$server_privkey" | wg pubkey)
## Endpoint = $DDNS:$SERVERPORT
## AllowedIPs = 0.0.0.0/0, ::/0
## # This is for if you're behind a NAT and
## # want the connection to be kept alive.
## PersistentKeepalive = 25
## # Optional
## # MTU = 1432
EOF
        echo "$server_privkey" | wg pubkey > "${SYNOPKG_PKGDEST}/var/publickey"
        # Allow synoedit to edit these files
        # chmod 775 "${SYNOPKG_PKGDEST}/var/" >> "${LOG_FILE}" 2>&1
        # chown :system "${SYNOPKG_PKGDEST}/var/" >> "${LOG_FILE}" 2>&1
    fi
}

service_postinst () {
    mkdir -p "${SYNOPKG_PKGDEST}/etc/" >> "${INST_LOG}" 2>&1
    # load kernel module and verify that is is loaded
    insmod "${SYNOPKG_PKGDEST}/wireguard.ko" >> "${INST_LOG}" 2>&1
    lsmod | grep ^wireguard >> "${INST_LOG}" 2>&1

    # if [ -x "/bin/bash" ]; then
    #     # change shebang to packaged bash
    #     sed -i 's/#!\/bin\/bash/#!\/var\/packages\/wireguard\/target\/bin\/bash/' /usr/local/bin/wg-quick
    # fi

}

service_prestart() {
    echo "service_prestart" >> "${LOG_FILE}" 2>&1
    config
    wg-quick up "${SYNOPKG_PKGDEST}/var/wg0.conf" >> "${LOG_FILE}" 2>&1
}
service_poststop () {
    echo "service_poststop" >> "${LOG_FILE}" 2>&1
    wg-quick down "${SYNOPKG_PKGDEST}/var/wg0.conf" >> "${LOG_FILE}" 2>&1
    chmod 744 "${SYNOPKG_PKGDEST}/var/wg0.conf"  >> "${LOG_FILE}" 2>&1
}

service_postuninst () {
    # remove interface
    ip link del wg0 2>/dev/null || true
}
