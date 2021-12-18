
CFG_FILE="${SYNOPKG_PKGVAR}/sockd.conf"
SOCKD="${SYNOPKG_PKGDEST}/sbin/sockd"

SC_GROUP="sockd-users"
SC_GROUP_DESC="Users with access to SOCKS proxy server"

SERVICE_COMMAND="${SOCKD} -f ${CFG_FILE} -p ${PID_FILE} -D"

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
}

service_preinst ()
{
	# set service port from wizard variable
    SERVICE_CONFIGURE_FILE="${SYNOPKG_PKGINST_TEMP_DIR}/app/${SYNOPKG_PKGNAME}.sc"
    sed -e "s|@socks_port@|${wizard_proxy_port}|g" -i ${SERVICE_CONFIGURE_FILE}
}

service_postinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        auth_method=$([ "${wizard_proxy_auth}" == "true" ] && echo "username" || echo "none")
        auth_method_group=$([ "${wizard_proxy_auth}" == "true" ] && echo "    socksmethod: username\n    group: ${SC_GROUP}" || echo "")

        sed -e "s|@socks_port@|${wizard_proxy_port}|g" \
            -e "s|@socks_block@|${wizard_proxy_block}|g" \
            -e "s|@socks_log@|${LOG_FILE}|g" \
            -e "s|@socks_auth@|${auth_method}|g" \
            -e "s|@socks_auth_group@|${auth_method_group}|g" \
            -i ${CFG_FILE}

        synogroup --add ${SC_GROUP}
        synogroup --descset ${SC_GROUP} "${SC_GROUP_DESC}"
    fi
}

service_preuninst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
        synogroup --del ${SC_GROUP}
    fi
}
