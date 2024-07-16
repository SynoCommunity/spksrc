# shellcheck disable=SC2148
SERVERPORT=51820
NETWORK=172.23.0.1/24 # why 172.23 ? because Synology SRM uses 172.22 and 172.21 for OpenVPN and L2TP/IPsec
INTERFACE=eth0

WG="$SYNOPKG_PKGDEST/bin/wg"
WG_QUICK="$SYNOPKG_PKGDEST/bin/wg-quick"
CONFIG="$SYNOPKG_PKGVAR/wg0.conf"

config() {
    # if the config does not exist make one
    if [ ! -f "${CONFIG}" ]; then
        echo "Creating config file"
        DDNS=$(grep -m 1 hostname= /etc/ddns.conf | cut -d = -f 2)
        if [ -z "$DDNS" ]; then
            DDNS=$(nslookup myip.opendns.com resolver1.opendns.com | tail -n +3 | grep 'Address' | awk -F ':' '{print $2}') || DDNS=$(wget -qO- https://checkip.amazonaws.com)
        fi
        echo "Endpoint = $DDNS"
        server_privkey=$($WG genkey)
        client_privkey=$($WG genkey)
cat<<EOF > "${CONFIG}"
[Interface]
Address = $NETWORK
ListenPort = $SERVERPORT
PrivateKey = $server_privkey
PostUp = iptables -A SYNO_FORWARD_ACCEPT -i %i -j ACCEPT; iptables -t nat -A POSTROUTING -o $INTERFACE -j MASQUERADE
PostDown = iptables -D SYNO_FORWARD_ACCEPT -i %i -j ACCEPT; iptables -t nat -D POSTROUTING -o $INTERFACE -j MASQUERADE

[Peer]
PublicKey = $(echo "$client_privkey" | $WG pubkey)
AllowedIPs = 172.23.0.2/32 # select a unique ip inside of $NETWORK

## Sample Client Configuration ##
## [Interface]
## PrivateKey = $client_privkey
## Address = 172.23.0.2/32 # select a unique ip inside of $NETWORK
## DNS = 1.1.1.1
##
## [Peer]
## PublicKey = $(echo "$server_privkey" | $WG pubkey)
## Endpoint = $DDNS:$SERVERPORT
## AllowedIPs = 0.0.0.0/0, ::/0
## # This is for if you're behind a NAT and
## # want the connection to be kept alive.
## PersistentKeepalive = 25
## # Optional
## # MTU = 1432
EOF
        echo "$server_privkey" | $WG pubkey > "${SYNOPKG_PKGVAR}/publickey"
    fi
}

service_postinst () {
    if [ ! -x /bin/bash ]; then # SRM
        # change shebang to packaged bash
        sed -i 's/#!\/bin\/bash/#!\/var\/packages\/wireguard\/target\/bin\/bash/' "$WG_QUICK"
    fi
    # load kernel module and verify that is is loaded
    insmod "${SYNOPKG_PKGDEST}/wireguard.ko"
    lsmod | grep '^wireguard'
    config
}

service_postuninst () {
    rmmod "${SYNOPKG_PKGDEST}/wireguard.ko"
    # remove interface
    ip link del wg0 2>/dev/null || true
}
