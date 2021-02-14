#!/bin/sh
LOG_FILE = "${SYNOPKG_PKGDEST}/var/${SYNOPKG_PKGNAME}.log"

config() {
    SERVERPORT = 51820
    NETWORK = 172.23.0.1/24 # why 172.23 ? because Synology SRM uses 172.22 and 172.21 for OpenVPN and L2TP/IPsec
    INTERFACE = eth0
    CONFIG_FILE = "${SYNOPKG_PKGDEST}/var/wg0.conf"

    # if the config does not exist make one
    if [ ! -f "${CONFIG_FILE}" ]; then
        mkdir -p "${SYNOPKG_PKGDEST}/etc/" >> "${LOG_FILE}" 2>&1
        echo "Creating config file" >> "${LOG_FILE}" 2>&1
        DDNS=$(grep -m 1 hostname= /etc/ddns.conf | cut -d = -f 2)
        if [ -z "$DDNS" ]; then
            DDNS=$(nslookup myip.opendns.com resolver1.opendns.com | tail -n +3 | sed -n 's/Address:\s*//p')
        fi
        if [ -z "$DDNS" ]; then
            DDNS=$(wget -qO- https://checkip.amazonaws.com)
        fi
        echo "Endpoint = $DDNS" >> "${LOG_FILE}" 2>&1
        server_privkey=$(wg genkey)
        client_privkey=$(wg genkey)
cat<<EOF > "${SYNOPKG_PKGDEST}/var/wg0.conf"
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
    fi
}

start_daemon() {
    echo "start_daemon" >> "${LOG_FILE}" 2>&1
    mkdir -p "${SYNOPKG_PKGDEST}/var"
    config
    # load kernel module and verify that is is loaded
    insmod "$SYNOPKG_PKGDEST/wireguard.ko" >> "${LOG_FILE}" 2>&1
    lsmod | grep '^wireguard' >> "${LOG_FILE}" 2>&1
    # Hope no other service requires this
    sysctl -w net.ipv4.ip_forward=1  >> "${LOG_FILE}" 2>&1
    wg-quick up "${SYNOPKG_PKGDEST}/var/wg0.conf" >> "${LOG_FILE}" 2>&1
}

stop_daemon () {
    echo "stop_daemon" >> "${LOG_FILE}" 2>&1
    wg-quick down "${SYNOPKG_PKGDEST}/var/wg0.conf" >> "${LOG_FILE}" 2>&1
    rmmod "$SYNOPKG_PKGDEST/wireguard.ko"  >> "${LOG_FILE}" 2>&1
    # Hope no other service requires this
    sysctl -w net.ipv4.ip_forward=0  >> "${LOG_FILE}" 2>&1
    # ip link del wg0 2>/dev/null || true
}

case "$1" in
    start)
        start_daemon
        ;;
    stop)
        stop_daemon
        ;;
    status)
        lsmod | grep '^wireguard' && exit 0 || exit 3
        ;;
esac
exit 0
