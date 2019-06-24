# shellcheck disable=SC2148
SVC_CWD="${SYNOPKG_PKGDEST}"
DNSCRYPT_PROXY="${SYNOPKG_PKGDEST}/bin/dnscrypt-proxy"
PID_FILE="${SYNOPKG_PKGDEST}/var/dnscrypt-proxy.pid"
CFG_FILE="${SYNOPKG_PKGDEST}/var/dnscrypt-proxy.toml"
EXAMPLE_FILES="${SYNOPKG_PKGDEST}/example-*"
BACKUP_PORT="10053"
## I need root to bind to port 53 see `service_prestart()` below
#SERVICE_COMMAND="${DNSCRYPT_PROXY} --config ${CFG_FILE} --pidfile ${PID_FILE} &"

echo "DSM Version: $SYNOPKG_DSM_VERSION_MAJOR.$SYNOPKG_DSM_VERSION_MINOR-$SYNOPKG_DSM_VERSION_BUILD" >> "${INST_LOG}" 2>&1
# SRM 1.2 example: DSM Version: 5.2-7915
# DSM 6.2 example: DSM Version: 6.2-23739
UNAME=$(uname -a)
echo "uname: $UNAME" >> "${INST_LOG}" 2>&1
# SRM example: Linux {some-name} 4.4.60 #7779 SMP Mon Jan 28 04:30:39 CST 2019 armv7l GNU/Linux synology_ipq806x_rt2600ac
# DSM example: Linux {some-name} 3.10.105 #23739 SMP Tue Jul 3 19:47:13 CST 2018 x86_64 GNU/Linux synology_bromolow_3615xs
OS="dsm"
if echo "$UNAME" | grep -q -i 'rt1900ac\|rt2600ac\|mr2200ac'; then
    OS="srm"
fi
echo "OS detected: $OS" >> "${INST_LOG}" 2>&1

blocklist_setup () {
    ## https://github.com/jedisct1/dnscrypt-proxy/wiki/Public-blacklists
    ## https://github.com/jedisct1/dnscrypt-proxy/tree/master/utils/generate-domains-blacklists
    echo "Install/Upgrade generate-domains-blacklist.py (requires python)" >> "${INST_LOG}"
    mkdir -p "${SYNOPKG_PKGDEST}/var"
    touch "${SYNOPKG_PKGDEST}"/var/ip-blocklist.txt
    if [ ! -e "${SYNOPKG_PKGDEST}/var/domains-blacklist.conf" ]; then
        wget -t 3 -O "${SYNOPKG_PKGDEST}/var/domains-blacklist.conf" \
            --https-only https://raw.githubusercontent.com/jedisct1/dnscrypt-proxy/master/utils/generate-domains-blacklists/domains-blacklist.conf
    fi
}

blocklist_cron_uninstall () {
    # remove cron job
    sed -i '/.*update-blocklist.sh/d' /etc/crontab
    synoservicectl --restart crond >> "${INST_LOG}" 2>&1
}

pgrep () {
    if [ "$OS" == 'dsm' ]; then
        # shellcheck disable=SC2009,SC2153
        ps aux | grep "$1" >> "${LOG_FILE}" 2>&1
    else
        # shellcheck disable=SC2009,SC2153
        ps -w | grep "[^]]$1" >> "${LOG_FILE}" 2>&1
    fi
}

restart_dhcpd () {
    /etc/rc.network nat-restart-dhcp >> "${LOG_FILE}" 2>&1
}

forward_dns_dhcpd () {
    echo "dns forwarding - $1" >> "${LOG_FILE}"
    if [ "$1" == "no" ] && [ -f /etc/dhcpd/dhcpd-dnscrypt-dnscrypt.conf ]; then
        if [ "$OS" == 'dsm' ]; then
            echo "enable=no" > /etc/dhcpd/dhcpd-dns-dns.info
        else
            echo "enable=no" > /etc/dhcpd/dhcpd-dnscrypt-dnscrypt.info
        fi
        restart_dhcpd
    elif [ "$1" == "yes" ]; then
        if pgrep "dhcpd.conf"; then  # if dhcpd (dnsmasq) is enabled and running
            if [ "$OS" == 'dsm ' ]; then
                echo "server=127.0.0.1#${BACKUP_PORT}" > /etc/dhcpd/dhcpd-dns-dns.conf
                echo "enable=yes" > /etc/dhcpd/dhcpd-dns-dns.info
                # /etc/dhcpd/dhcpd-vendor.conf
                # /etc/dhcpd/dhcpd-dns-dns.conf
            else # RSM
                echo "server=127.0.0.1#${BACKUP_PORT}" > /etc/dhcpd/dhcpd-dnscrypt-dnscrypt.conf
                echo "enable=yes" > /etc/dhcpd/dhcpd-dnscrypt-dnscrypt.info
            fi
            restart_dhcpd
        else
            echo "pgrep: no process with 'dhcpd.conf' found" >> "${LOG_FILE}"
        fi
    fi
}

service_prestart () {
    echo "service_preinst ${SYNOPKG_PKG_STATUS}" >> "${INST_LOG}"

    # Install daily cron job (3 minutes past midnight), to update the block list
    if [ "$OS" == 'dsm' ]; then
        mkdir -p /etc/cron.d
        echo "3       0       *       *       *       root    /var/packages/dnscrypt-proxy/target/var/update-blocklist.sh" >> /etc/cron.d/dnscrypt-proxy-update-blocklist
    else # RSM
        echo "3       0       *       *       *       root    /var/packages/dnscrypt-proxy/target/var/update-blocklist.sh" >> /etc/crontab
    fi
    synoservicectl --restart crond >> "${INST_LOG}"

    # This fixes https://github.com/SynoCommunity/spksrc/issues/3468
    # This can't be done at install time. see:
    #  https://github.com/SynoCommunity/spksrc/blob/e914a32600e65f80131ae09913f1b6f6a2dd8b13/mk/spksrc.service.installer#L307-L319
    chown root:root "${SYNOPKG_PKGDEST}/ui/index.cgi"
    forward_dns_dhcpd "yes"
    cd "$SVC_CWD" || exit 1

    # Limit num of processes https://golang.org/pkg/runtime/
    #
    # Fixes https://github.com/ksonnet/ksonnet/issues/298
    #  until https://github.com/golang/go/commit/3a18f0ecb5748488501c565e995ec12a29e66966
    #  is released.
    # related https://github.com/golang/go/issues/14626
    # https://github.com/golang/go/blob/release-branch.go1.11/src/os/user/lookup_stubs.go
    #
    # override community script from this point and launch the program ourselves
    env GOMAXPROCS=1 USER=root HOME=/root "${DNSCRYPT_PROXY}" --config "${CFG_FILE}" --pidfile "${PID_FILE}" &
    # su "${EFF_USER}" -s /bin/false -c "cd ${SVC_CWD}; ${DNSCRYPT_PROXY} --config ${CFG_FILE} --pidfile ${PID_FILE} --logfile ${LOG_FILE}" &
}

service_poststop () {
    echo "After stop (service_poststop)" >> "${INST_LOG}"
    blocklist_cron_uninstall
    forward_dns_dhcpd "no"
}

service_postinst () {
    echo "Running service_postinst script" >> "${INST_LOG}"
    mkdir -p "${SYNOPKG_PKGDEST}"/var >> "${INST_LOG}" 2>&1
    if [ ! -e "${CFG_FILE}" ]; then
        # shellcheck disable=SC2086
        cp -f ${EXAMPLE_FILES} "${SYNOPKG_PKGDEST}/var/" >> "${INST_LOG}" 2>&1
        cp -f "${SYNOPKG_PKGDEST}"/offline-cache/* "${SYNOPKG_PKGDEST}/var/" >> "${INST_LOG}" 2>&1
        cp -f "${SYNOPKG_PKGDEST}"/blocklist/* "${SYNOPKG_PKGDEST}/var/" >> "${INST_LOG}" 2>&1
        # shellcheck disable=SC2231
        for file in ${SYNOPKG_PKGDEST}/var/example-*; do
            mv "${file}" "${file//example-/}" >> "${INST_LOG}" 2>&1
        done

        echo "Applying settings from Wizard..." >> "${INST_LOG}"
        ## if empty comment out server list
        wizard_servers=${wizard_servers:-""}
        if [ -z "${wizard_servers// }" ]; then
            server_names_enabled="# "
        fi

        # Check for dhcp
        if pgrep "dhcpd.conf" || netstat -na | grep ":${SERVICE_PORT} "; then
            echo "dhcpd is running or port ${SERVICE_PORT} is in use. Switching service port to ${BACKUP_PORT}" >> "${INST_LOG}"
            SERVICE_PORT=${BACKUP_PORT}
        fi

        ## IPv6 address errors with -> bind: address already in use
        #listen_addresses=\[${wizard_listen_address:-"'0.0.0.0:$SERVICE_PORT', '[::1]:$SERVICE_PORT'"}\]
        listen_addresses=\[${wizard_listen_address:-"'0.0.0.0:$SERVICE_PORT'"}\]
        server_names=\[${wizard_servers:-"'scaleway-fr', 'google', 'yandex', 'cloudflare'"}\]

        ## change default settings
        sed -i -e "s/# server_names = .*/${server_names_enabled:-""}server_names = ${server_names}/" \
            -e "s/listen_addresses = .*/listen_addresses = ${listen_addresses}/" \
            -e "s/# user_name = .*/user_name = '${EFF_USER:-"nobody"}'/" \
            -e "s/require_dnssec = .*/require_dnssec = true/" \
            -e "s|# log_file = 'dnscrypt-proxy.log'.*|log_file = '${LOG_FILE:-""}'|" \
            -e "s/netprobe_timeout = .*/netprobe_timeout = 2/" \
            -e "s/ipv6_servers = .*/ipv6_servers = ${wizard_ipv6:=false}/" \
            "${CFG_FILE}" >> "${INST_LOG}" 2>&1
    fi

    echo "Fixing permissions for cgi GUI... on SRM" >> "${INST_LOG}"
    # Fixes https://github.com/publicarray/spksrc/issues/3
    # https://originhelp.synology.com/developer-guide/privilege/privilege_specification.html
    chmod 0777 "${SYNOPKG_PKGDEST}/var/" >> "${INST_LOG}" 2>&1

    blocklist_setup

    # shellcheck disable=SC2129
    echo "Install Help files" >> "${INST_LOG}"
    pkgindexer_add "${SYNOPKG_PKGDEST}/ui/index.conf" >> "${INST_LOG}" 2>&1
    pkgindexer_add "${SYNOPKG_PKGDEST}/ui/helptoc.conf" >> "${INST_LOG}" 2>&1
    # pkgindexer_add "${SYNOPKG_PKGDEST}/ui/helptoc.conf" "${SYNOPKG_PKGDEST}/indexdb/helpindexdb" >> "${INST_LOG}" 2>&1 # DSM 6.0 ?
}

service_postuninst () {
    echo "service_postuninst ${SYNOPKG_PKG_STATUS}" >> "${INST_LOG}"
    blocklist_cron_uninstall

    # shellcheck disable=SC2129
    echo "Uninstall Help files" >> "${INST_LOG}"
    pkgindexer_del "${SYNOPKG_PKGDEST}/ui/helptoc.conf" >> "${INST_LOG}" 2>&1
    pkgindexer_del "${SYNOPKG_PKGDEST}/ui/index.conf" >> "${INST_LOG}" 2>&1
    disable_dhcpd_dns_port "no"
    rm -f /etc/dhcpd/dhcpd-dns-dns.conf
    rm -f /etc/dhcpd/dhcpd-dns-dns.info
    rm -f /etc/dhcpd/dhcpd-dnscrypt-dnscrypt.conf
    rm -f /etc/dhcpd/dhcpd-dnscrypt-dnscrypt.info
}

service_postupgrade () {
    # upgrade script when the offline-cache is also updated
    cp -f "${SYNOPKG_PKGDEST}"/blocklist/generate-domains-blacklist.py "${SYNOPKG_PKGDEST}/var/" >> "${INST_LOG}" 2>&1
}
