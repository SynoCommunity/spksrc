CFG_FILE="${SYNOPKG_PKGDEST}/var/ps3netsrv.conf"
BIN="${SYNOPKG_PKGDEST}/bin/ps3netsrv"

if [ -r "${CFG_FILE}" ]; then
    . "${CFG_FILE}"
fi

SERVICE_COMMAND="/bin/stdbuf -o L -e L ${BIN} ${PS3_DIR}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

service_postinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        sed -i -e "s|@wizard_dir@|${wizard_dir:=/volume1/PS3}|g" ${CFG_FILE}
    fi
}
