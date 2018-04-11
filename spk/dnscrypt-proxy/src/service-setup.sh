SVC_CWD="${SYNOPKG_PKGDEST}"
DNSCRYPT_PROXY=${SYNOPKG_PKGDEST}/bin/dnscrypt-proxy
PID_FILE=${SYNOPKG_PKGDEST}/var/dnscrypt-proxy.pid
CFG_FILE="${SYNOPKG_PKGDEST}/etc/dnscrypt-proxy.toml"
TEMPLATE_CFG_FILE="${SYNOPKG_PKGDEST}/etc/example-dnscrypt-proxy.toml"

SERVICE_COMMAND="${DNSCRYPT_PROXY} --config ${CFG_FILE} --pidfile ${PID_FILE}"
SVC_BACKGROUND=y

service_postinst ()
{
    mkdir -p "${SYNOPKG_PKGDEST}"/etc "${SYNOPKG_PKGDEST}"/var
    if [ ! -e "${CFG_FILE}" ]; then
        echo "Applying settings from Wizard..." >> "${INST_LOG}"
        cp -f "${TEMPLATE_CFG_FILE}" "${CFG_FILE}" >> "${INST_LOG}"

        # if empty comment out server list
        wizard_servers=${wizard_servers:-''}
        if [ -z "${wizard_servers// }" ]; then
            server_names_enabled='# '
        fi

        listen_addresses=\[${wizard_listen_address:-"'0.0.0.0:$SERVICE_PORT'"}\]
        server_names=\[${wizard_servers:-"'scaleway-fr', 'google', 'yandex', 'cloudflare'"}\]

        # change default settings
        sed -i -e "s/listen_addresses = .*/listen_addresses = ${listen_addresses}/" \
            -e "s/require_dnssec = .*/require_dnssec = true/" \
            -e "s/# server_names = .*/${server_names_enabled:-""}server_names = ${server_names}/" \
            -e "s/ipv6_servers = .*/ipv6_servers = ${wizard_ipv6:=false}/" \
            "${CFG_FILE}" >> "${INST_LOG}"
    fi
}
