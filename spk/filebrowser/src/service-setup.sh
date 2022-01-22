
# https://help.synology.com/developer-guide/integrate_dsm/fhs.html
if [ -z "${SYNOPKG_PKGHOME}" ]; then
    SYNOPKG_PKGHOME="${SYNOPKG_PKGVAR}"
fi

export HOME="${SYNOPKG_PKGHOME}"
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/filebrowser -a 0.0.0.0 -p ${SERVICE_PORT} -r / -l ${LOG_FILE} -d ${SYNOPKG_PKGHOME}/filebrowser.db"
SVC_BACKGROUND=y
SVC_WRITE_PID=y
