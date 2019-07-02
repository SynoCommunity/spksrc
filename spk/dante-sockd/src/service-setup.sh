CFG_FILE="${SYNOPKG_PKGDEST}/var/sockd.conf"
BIN="${SYNOPKG_PKGDEST}/sbin/sockd"

SC_GROUP="sockd-users"
SC_GROUP_DESC="Users with access to proxy server"

SERVICE_COMMAND="${BIN} -f ${CFG_FILE} -p ${PID_FILE} -D"

service_postinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        auth_method=$([ "${wizard_proxy_auth}" == "true" ] && echo "username" || echo "none")
        auth_method_group=$([ "${wizard_proxy_auth}" == "true" ] && echo "    socksmethod: username\n    group: ${SC_GROUP}" || echo "")

        sed -i -e "s|@socks_port@|${wizard_proxy_port:=1080}|g" ${CFG_FILE}
        sed -i -e "s|@socks_block@|${wizard_proxy_block:=192.168.0.0/16}|g" ${CFG_FILE}
        sed -i -e "s|@socks_log@|${LOG_FILE}|g" ${CFG_FILE}
        sed -i -e "s|@socks_auth@|${auth_method}|g" ${CFG_FILE}
        sed -i -e "s|@socks_auth_group@|${auth_method_group}|g" ${CFG_FILE}

        synogroup --add ${SC_GROUP} > /dev/null
        synogroup --descset ${SC_GROUP} "${SC_GROUP_DESC}"
    fi
}

service_preuninst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
        synogroup --del ${SC_GROUP} > /dev/null
    fi
}
