CFG_FILE="${SYNOPKG_PKGDEST}/var/ps3netsrv.conf"
BIN="${SYNOPKG_PKGDEST}/bin/ps3netsrv"

if [ -r "${CFG_FILE}" ]; then
    . "${CFG_FILE}"
fi

SERVICE_COMMAND="${BIN} ${PS3_DIR} ${PS3_PORT}"

service_postinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        sed -i -e "s|@wizard_dir@|${wizard_dir:=/volume1/PS3}|g" ${CFG_FILE}
        sed -i -e "s|@wizard_port@|${wizard_port:=38008}|g" ${CFG_FILE}
    fi
}

service_prestart ()
{
    # Replace generic service startup, fork process in background
    # TODO: remove debug log
    echo "EFF_USER:  ${EFF_USER}; SYNOPKG_PKGDEST: ${SYNOPKG_PKGDEST}; SERVICE_COMMAND: ${SERVICE_COMMAND}; PID_FILE: ${PID_FILE}" >> ${LOG_FILE}
    if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 6 ]; then
        echo "First run" >> ${LOG_FILE}
        su ${EFF_USER} -s /bin/sh -c "cd ${SYNOPKG_PKGDEST}; ${SERVICE_COMMAND}" >> ${LOG_FILE} 2>&1 &
    else
        echo "Second run" >> ${LOG_FILE}
        cd ${SYNOPKG_PKGDEST};
        ${SERVICE_COMMAND} >> ${LOG_FILE} 2>&1 &
    fi
    echo "$!" > "${PID_FILE}"
}
