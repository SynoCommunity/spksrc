# Setup environment
PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"

SERVER=${SYNOPKG_PKGDEST}/bin/urbackupsrv
SERVICE_COMMAND="${SERVER} run --daemon --user ${EFF_USER} --http-port ${SERVICE_PORT} --pidfile ${PID_FILE} --loglevel info --logfile ${LOG_FILE}"

service_postinst ()
{
    mkdir -p ${SYNOPKG_PKGVAR}/urbackup
    echo "tank/images" > ${SYNOPKG_PKGVAR}/urbackup/dataset  
    echo "${SHARE_PATH}" > ${SYNOPKG_PKGVAR}/urbackup/backupfolder 
}

service_prestart ()
{
    CONFIG_DIR="${SYNOPKG_PKGVAR}"

    # Required: start-stop-daemon does not set environment variables
    export HOME=${SYNOPKG_PKGVAR}
}
