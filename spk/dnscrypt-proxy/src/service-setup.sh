# shellcheck disable=SC2148
SVC_CWD="${SYNOPKG_PKGDEST}"
DNSCRYPT_PROXY="${SYNOPKG_PKGDEST}/bin/dnscrypt-proxy"
PID_FILE="${SYNOPKG_PKGDEST}/var/dnscrypt-proxy.pid"
CFG_FILE="${SYNOPKG_PKGDEST}/var/dnscrypt-proxy.toml"
EXAMPLE_FILES="${SYNOPKG_PKGDEST}/example-*"

blocklist_setup () {
    ## https://github.com/jedisct1/dnscrypt-proxy/wiki/Public-blacklists
    ## https://github.com/jedisct1/dnscrypt-proxy/tree/master/utils/generate-domains-blacklists
    echo "Install/Upgrade generate-domains-blacklist.py (requires python)" >> "${INST_LOG}"
    mkdir -p "${SYNOPKG_PKGDEST}/var"
    chmod 0777 "${SYNOPKG_PKGDEST}"/var/ >> "${INST_LOG}" 2>&1
    wget -t 3 -O "${SYNOPKG_PKGDEST}/var/generate-domains-blacklist.py" \
        --https-only https://raw.githubusercontent.com/jedisct1/dnscrypt-proxy/master/utils/generate-domains-blacklists/generate-domains-blacklist.py \
        >> "${INST_LOG}" 2>&1
    touch "${SYNOPKG_PKGDEST}"/var/domains-whitelist.txt
    touch "${SYNOPKG_PKGDEST}"/var/domains-time-restricted.txt
    touch "${SYNOPKG_PKGDEST}"/var/domains-blacklist-local-additions.txt
    if [ ! -e "${SYNOPKG_PKGDEST}/var/domains-blacklist.conf" ]; then
        wget -t 3 -O "${SYNOPKG_PKGDEST}/var/domains-blacklist.conf" \
            --https-only https://raw.githubusercontent.com/jedisct1/dnscrypt-proxy/master/utils/generate-domains-blacklists/domains-blacklist.conf
    fi
}

pgrep () {
    # shellcheck disable=SC2009,SC2153
    ps -w | grep "[^]]$1" >> "${LOG_FILE}" 2>&1
}

disable_dhcpd_dns_port () {
    if [ "$1" == "no" ] && [ -f /etc/dhcpd/dhcpd-custom-custom.conf ]; then
        echo "Port 0 - dhcpd (dnsmasq) enabled: $1" >> "${LOG_FILE}"
        echo "enable=\"$1\"" > /etc/dhcpd/dhcpd-custom-custom.info
        /etc/rc.network nat-restart-dhcp >> "${LOG_FILE}" 2>&1
    elif [ "$1" == "yes" ] && netstat -na | grep ":53 " >> "${LOG_FILE}" 2>&1; then
        echo "Port 53 is in use" >> "${LOG_FILE}"
        if pgrep "dhcpd.conf"; then  # if dhcpd (dnsmasq) is enabled and running
            echo "Port 0 - dhcpd (dnsmasq) enabled: $1" >> "${LOG_FILE}"
            echo "port=0" > /etc/dhcpd/dhcpd-custom-custom.conf
            echo "enable=\"$1\"" > /etc/dhcpd/dhcpd-custom-custom.info
            /etc/rc.network nat-restart-dhcp >> "${LOG_FILE}" 2>&1
        else
            echo "pgrep: no process with 'dhcpd.conf' found" >> "${LOG_FILE}"
        fi
    else
        echo "Port 53 is free" >> "${LOG_FILE}"
        rm -f /etc/dhcpd/dhcpd-custom-custom.conf
    fi
}

service_prestart () {
    disable_dhcpd_dns_port "yes"
    cd "$SVC_CWD" || exit 1
    ${DNSCRYPT_PROXY} --config "${CFG_FILE}" --pidfile "${PID_FILE}" --logfile "${LOG_FILE}" &
    # su "${EFF_USER}" -s /bin/false -c "cd ${SVC_CWD}; ${DNSCRYPT_PROXY} --config ${CFG_FILE} --pidfile ${PID_FILE} --logfile ${LOG_FILE}" &
}

service_poststop () {
    disable_dhcpd_dns_port "no"
}

service_postinst () {
    echo "Running post-install script" >> "${INST_LOG}"
    mkdir -p "${SYNOPKG_PKGDEST}"/var >> "${INST_LOG}" 2>&1
    if [ ! -e "${CFG_FILE}" ]; then
        # shellcheck disable=SC2086
        cp -f ${EXAMPLE_FILES} "${SYNOPKG_PKGDEST}/var/" >> "${INST_LOG}" 2>&1
        for file in ${SYNOPKG_PKGDEST}/var/example-*; do
            mv "${file}" "${file//example-/}" >> "${INST_LOG}" 2>&1
        done

        echo "Applying settings from Wizard..." >> "${INST_LOG}"
        ## if empty comment out server list
        wizard_servers=${wizard_servers:-""}
        if [ -z "${wizard_servers// }" ]; then
            server_names_enabled="# "
        fi

        listen_addresses=\[${wizard_listen_address:-"'0.0.0.0:$SERVICE_PORT'"}\]
        server_names=\[${wizard_servers:-"'scaleway-fr', 'google', 'yandex', 'cloudflare'"}\]

        ## change default settings
        sed -i -e "s/listen_addresses = .*/listen_addresses = ${listen_addresses}/" \
            -e "s/require_dnssec = .*/require_dnssec = true/" \
            -e "s/# server_names = .*/${server_names_enabled:-""}server_names = ${server_names}/" \
            -e "s/ipv6_servers = .*/ipv6_servers = ${wizard_ipv6:=false}/" \
            "${CFG_FILE}" >> "${INST_LOG}" 2>&1
    fi

    # shellcheck disable=SC2129
    echo "Setting up the Web GUI..." >> "${INST_LOG}"
    ln -s "${SYNOPKG_PKGDEST}/ui/" /usr/syno/synoman/webman/3rdparty/dnscrypt-proxy >> "${INST_LOG}" 2>&1

    echo "Fixing permissions for cgi GUI..." >> "${INST_LOG}"
    ## Allow cgi user to write to this file
    ## chown doesn't work as it's overwritten by the SynoCommunity install script. Also see page 104 in https://developer.synology.com/download/developer-guide.pdf
    # chown system /var/packages/dnscrypt-proxy/target/var/dnscrypt-proxy.toml
    ## Less than ideal solution, ToDo: find something better
    chmod 0666 "${SYNOPKG_PKGDEST}/var/dnscrypt-proxy.toml" >> "${INST_LOG}" 2>&1
    chmod 0666 "${SYNOPKG_PKGDEST}"/var/*.txt >> "${INST_LOG}" 2>&1
    chmod 0777 "${SYNOPKG_PKGDEST}/var/" >> "${INST_LOG}" 2>&1

    blocklist_setup

    # shellcheck disable=SC2129
    echo "Install Help files" >> "${INST_LOG}"
    pkgindexer_add "${SYNOPKG_PKGDEST}/ui/index.conf" >> "${INST_LOG}" 2>&1
    pkgindexer_add "${SYNOPKG_PKGDEST}/ui/helptoc.conf" >> "${INST_LOG}" 2>&1
    # pkgindexer_add "${SYNOPKG_PKGDEST}/ui/helptoc.conf" "${SYNOPKG_PKGDEST}/indexdb/helpindexdb" >> "${INST_LOG}" 2>&1 # DSM 6.0 ?
}

service_postuninst () {
    # shellcheck disable=SC2129
    echo "Uninstall Help files" >> "${INST_LOG}"
    pkgindexer_del "${SYNOPKG_PKGDEST}/ui/helptoc.conf" >> "${INST_LOG}" 2>&1
    pkgindexer_del "${SYNOPKG_PKGDEST}/ui/index.conf" >> "${INST_LOG}" 2>&1
    rm -f /usr/syno/synoman/webman/3rdparty/dnscrypt-proxy >> "${INST_LOG}" 2>&1
    disable_dhcpd_dns_port "no"
    rm -f /etc/dhcpd/dhcpd-custom-custom.conf
    rm -f /etc/dhcpd/dhcpd-custom-custom.info
}
## rm -drf work-ipq806x-1.1/scripts && make arch-ipq806x-1.1
