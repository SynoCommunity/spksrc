
CFG_FILE="${SYNOPKG_PKGVAR}/sockd.conf"
SOCKD="${SYNOPKG_PKGDEST}/sbin/sockd"

SC_GROUP="sockd-users"
SC_GROUP_DESC="Users with access to SOCKS proxy server"

SERVICE_COMMAND="${SOCKD} -f ${CFG_FILE} -p ${PID_FILE} -D"

PORT_CONFIG_FILE="${SYNOPKG_PKGVAR}/port_config"
port=""

socks_privileged_user=${USER}
socks_unprivileged_user=${USER}
if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ]; then
    socks_privileged_user=root
    socks_unprivileged_user=nobody
fi

validate_preinst ()
{
	# validate whether the service port from wizard variable is not in use

    # take the first found only, as when multiple services are found, we get multiple "true"
    conflict=$(servicetool --conf-port-conflict-check --tcp ${wizard_proxy_port} | grep -oP -m 1 "IsConflict:\s\K[^\s]*")

    if [[ "${conflict}" == "true" ]]; then
        echo "ERROR:"
        echo "Port ${wizard_proxy_port}/tcp is in use by: $(servicetool --conf-port-conflict-check --tcp ${wizard_proxy_port} | grep -oP  'ServiceName:\s\K.*')."
        exit 1
    fi

    if [ $SYNOPKG_DSM_VERSION_MAJOR -ge 7 ] && [ ${wizard_proxy_port} -lt 1024 ]; then
        echo "ERROR:"
        echo "Port ${wizard_proxy_port} is privileged, try a port above 1024 instead."
        exit 1
    fi
}

service_postinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        auth_method=$([ "${wizard_proxy_auth}" == "true" ] && echo "username" || echo "none")
        auth_method_group=$([ "${wizard_proxy_auth}" == "true" ] && echo "    socksmethod: username\n    group: ${SC_GROUP}" || echo "")

        sed -e "s|@socks_port@|${wizard_proxy_port}|g" \
            -e "s|@socks_interface@|${wizard_interface}|g" \
            -e "s|@socks_block@|${wizard_proxy_block}|g" \
            -e "s|@socks_log@|${LOG_FILE}|g" \
            -e "s|@socks_auth@|${auth_method}|g" \
            -e "s|@socks_auth_group@|${auth_method_group}|g" \
            -e "s|@socks_privileged_user@|${socks_privileged_user}|g" \
            -e "s|@socks_unprivileged_user@|${socks_unprivileged_user}|g" \
            -i ${CFG_FILE}

        synogroup --add ${SC_GROUP}
        synogroup --descset ${SC_GROUP} "${SC_GROUP_DESC}"
    fi


    if [ -n "${wizard_proxy_port}" ]; then # new install
        port="${wizard_proxy_port}"
    elif [ -f "${PORT_CONFIG_FILE}" ]; then # upgrade
        port=$(get_key_value "${PORT_CONFIG_FILE}" port)
    fi
    echo "port=${port}" > ${PORT_CONFIG_FILE}
    sed -e "s/@socks_port@/${port}/g" -i "${SYNOPKG_PKGDEST}/app/${SYNOPKG_PKGNAME}.sc"
}

service_preuninst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
        synogroup --del ${SC_GROUP}
    fi
}
