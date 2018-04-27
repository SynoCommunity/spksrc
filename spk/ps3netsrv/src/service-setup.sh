CFG_FILE="${SYNOPKG_PKGDEST}/var/ps3netsrv.conf"
BIN="${SYNOPKG_PKGDEST}/bin/ps3netsrv"

if [ -r "${CFG_FILE}" ]; then
    . "${CFG_FILE}"
fi

service_postinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        sed -i -e "s|@wizard_dir@|${wizard_dir:=/volume1/PS3}|g" ${CFG_FILE}
        sed -i -e "s|@wizard_port@|${wizard_port:=38008}|g" ${CFG_FILE}
    fi
}

service_prestart ()
{
    COMMAND="${BIN} ${PS3_DIR} ${PS3_PORT}"
    cd ${SYNOPKG_PKGDEST};
    stdbuf -o L -e L ${COMMAND} >> ${LOG_FILE} 2>&1 &
    echo "$!" > "${PID_FILE}"
}
