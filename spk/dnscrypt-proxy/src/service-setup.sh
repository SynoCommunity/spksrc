SVC_CWD="${SYNOPKG_PKGDEST}"
DNSCRYPT_PROXY="${SYNOPKG_PKGDEST}/bin/dnscrypt-proxy"
PID_FILE="${SYNOPKG_PKGDEST}/var/dnscrypt-proxy.pid"
CFG_FILE="${SYNOPKG_PKGDEST}/var/dnscrypt-proxy.toml"
EXAMPLE_FILES="${SYNOPKG_PKGDEST}/example-*"

blocklist_py () {
    ## https://github.com/jedisct1/dnscrypt-proxy/wiki/Public-blacklists
    ## https://github.com/jedisct1/dnscrypt-proxy/tree/master/utils/generate-domains-blacklists
    echo "Install/Upgrade generate-domains-blacklist.py (requires python)" >> "${INST_LOG}"
    mkdir -p "${SYNOPKG_PKGDEST}/var"
    chmod 0777 "${SYNOPKG_PKGDEST}"/var/ >> "${INST_LOG}" 2>&1
    wget -t 3 -O "${SYNOPKG_PKGDEST}/var/generate-domains-blacklist.py" \
        --https-only https://raw.githubusercontent.com/jedisct1/dnscrypt-proxy/master/utils/generate-domains-blacklists/generate-domains-blacklist.py \
        >> "${INST_LOG}" 2>&1
    touch ${SYNOPKG_PKGDEST}/var/domains-blacklist.conf
    touch ${SYNOPKG_PKGDEST}/var/domains-whitelist.txt
    touch ${SYNOPKG_PKGDEST}/var/domains-time-restricted.txt
    touch ${SYNOPKG_PKGDEST}/var/domains-blacklist-local-additions.txt
    if [ ! -e "${SYNOPKG_PKGDEST}/var/domains-blacklist.conf" ]; then
        wget -t 3 -O "${SYNOPKG_PKGDEST}/var/domains-blacklist.conf" \
            --https-only https://raw.githubusercontent.com/jedisct1/dnscrypt-proxy/master/utils/generate-domains-blacklists/domains-blacklist.conf
    fi
}

service_prestart () {
    echo "Free port 53 from dnsmasq" >> "${LOG_FILE}"
    echo 'enable="yes"' > /etc/dhcpd/dhcpd-custom-custom.info
    /etc/rc.network nat-restart-dhcp >> "${LOG_FILE}" 2>&1
    cd "$SVC_CWD" || exit 1
    ${DNSCRYPT_PROXY} --config "${CFG_FILE}" --pidfile "${PID_FILE}" --logfile "${LOG_FILE}" &
    # su "${EFF_USER}" -s /bin/false -c "cd ${SVC_CWD}; ${DNSCRYPT_PROXY} --config ${CFG_FILE} --pidfile ${PID_FILE} --logfile ${LOG_FILE}" &
}

service_poststop () {
    echo "Enable port 53 on dnsmasq" >> "${LOG_FILE}"
    echo 'enable="no"' > /etc/dhcpd/dhcpd-custom-custom.info
    /etc/rc.network nat-restart-dhcp >> "${LOG_FILE}" 2>&1
}

service_postinst () {
    echo "Running post-install script" >> "${INST_LOG}"
    mkdir -p "${SYNOPKG_PKGDEST}"/var >> "${INST_LOG}" 2>&1
    if [ ! -e "${CFG_FILE}" ]; then
        cp -f ${EXAMPLE_FILES} "${SYNOPKG_PKGDEST}/var/" >> "${INST_LOG}" 2>&1
        for file in ${SYNOPKG_PKGDEST}/var/example-*; do
            mv "${file}" "${file//example-/}" >> "${INST_LOG}" 2>&1
        done

        echo "Applying settings from Wizard..." >> "${INST_LOG}"
        ## if empty comment out server list
        wizard_servers=${wizard_servers:-''}
        if [ -z "${wizard_servers// }" ]; then
            server_names_enabled='# '
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

    echo "Setting up the Web GUI..." >> "${INST_LOG}"
    ln -s "${SYNOPKG_PKGDEST}/ui/" /usr/syno/synoman/webman/3rdparty/dnscrypt-proxy >> "${INST_LOG}" 2>&1

    echo "Fixing permissions for cgi GUI..." >> "${INST_LOG}"
    ## Allow cgi user to write to this file
    ## chown dosn't work as it's overwritten. see page 104 in https://developer.synology.com/download/developer-guide.pdf
    # chown system /var/packages/dnscrypt-proxy/target/var/dnscrypt-proxy.toml
    ## Less than ideal solution, ToDo: find something better
    chmod 0666 "${SYNOPKG_PKGDEST}/var/dnscrypt-proxy.toml" >> "${INST_LOG}" 2>&1
    chmod 0666 "${SYNOPKG_PKGDEST}"/var/*.txt >> "${INST_LOG}" 2>&1
    chmod 0777 "${SYNOPKG_PKGDEST}"/var/ >> "${INST_LOG}" 2>&1

    echo "Set dnsmasq settings" >> "${INST_LOG}"
    echo 'port=0' > /etc/dhcpd/dhcpd-custom-custom.conf

    blocklist_py
}

service_postuninst () {
    rm -f /usr/syno/synoman/webman/3rdparty/dnscrypt-proxy >> "${INST_LOG}" 2>&1
    echo "Enable port 53 on dnsmasq" >> "${INST_LOG}"
    rm -f /etc/dhcpd/dhcpd-custom-custom.conf
    rm -f /etc/dhcpd/dhcpd-custom-custom.info
    /etc/rc.network nat-restart-dhcp
}
## rm -drf work-ipq806x-1.1/scripts && make arch-ipq806x-1.1
