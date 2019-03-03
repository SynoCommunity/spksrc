SERVERPORT=51820
NETWORK=172.23.0.0/24 # why 172.23 ? because Synology SRM uses 172.22 and 172.21 for OpenVPN and L2TP/IPsec
PID_FILE="${SYNOPKG_PKGDEST}/var/wireguard.pid"

# Todo: survive a restart (help needed)
start() {
    # generate keys
    [ -f /var/packages/${SYNOPKG_PKGNAME}/target/etc/privatekey ] || umask 077 && wg genkey | tee /var/packages/${SYNOPKG_PKGNAME}/target/etc/privatekey | wg pubkey > /var/packages/${SYNOPKG_PKGNAME}/target/etc/publickey && umask 022
    # allow synoeditor to read the publickey
    chmod 644 /var/packages/${SYNOPKG_PKGNAME}/target/etc/publickey
    # delete and make a new wg0 interface
    ip link del dev wg0 2>/dev/null || true
    ip link add dev wg0 type wireguard

    # if the config does not exist make one
    if [ ! -f /var/packages/${SYNOPKG_PKGNAME}/target/etc/wg0.conf ]; then
cat<<EOF > /var/packages/${SYNOPKG_PKGNAME}/target/etc/wg0.conf
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
ListenPort = $SERVERPORT

# [Peer]
# PublicKey = {{ client public key }}
# AllowedIPs = 0.0.0.0/0


## Client Configuration ##
## [Interface]
## PrivateKey ="{{client privatekey (wg genkey)}}"
## Address = 192.168.2.10/32
## DNS = 192.168.0.1
##
## [Peer]
## PublicKey = {{server public key}}
## Endpoint = {{server ip}}:$SERVERPORT
## AllowedIPs = 0.0.0.0/0
## # This is for if you're behind a NAT and
## # want the connection to be kept alive.
## PersistentKeepalive = 25
EOF
    fi
    # load config
    wg setconf wg0 /var/packages/${SYNOPKG_PKGNAME}/target/etc/wg0.conf
    # load private key
    wg set wg0 private-key /var/packages/${SYNOPKG_PKGNAME}/target/etc/privatekey
    # give clients an address space
    ip address add dev wg0 ${NETWORK}
    # set a listening port (already set in config file)
    #wg set wg0 listen-port $SERVERPORT
    # start interface
    ip link set up dev wg0
}

stop {
    ip link set down dev wg0
}

service_postinst () {
    # Put wg in the PATH
    mkdir -p /usr/local/bin /var/packages/${SYNOPKG_PKGNAME}/target/etc/ >> "${INST_LOG}" 2>&1
    ln -fs /var/packages/${SYNOPKG_PKGNAME}/target/bin/wg /usr/local/bin/wg >> "${INST_LOG}" 2>&1
    # load kernel module and verify that is is loaded
    insmod /var/packages/${SYNOPKG_PKGNAME}/target/wireguard.ko >> "${INST_LOG}" 2>&1
    lsmod | grep wireguard >> "${INST_LOG}" 2>&1
}

service_prestart() {
    start
}
service_poststop () {
    stop
}

service_postuninst () {
    # Remove links
    rm -f /usr/local/bin/wg
    rm -rf /usr/local/etc/wireguard
    # remove interface
    ip link del wg0 2>/dev/null || true
}
