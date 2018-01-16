
# Package specific behaviors
# Sourced script by generic installer and start-stop-status scripts

service_prestart ()
{
    # Replace generic service startup, fork process in background
    echo "Starting python -m SimpleHTTPServer ${SERVICE_PORT} at ${SYNOPKG_PKGDEST}" >> ${LOG_FILE}
    COMMAND="python -m SimpleHTTPServer ${SERVICE_PORT}"
    if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 6 ]; then
        su ${EFF_USER} -s /bin/sh -c "cd ${SYNOPKG_PKGDEST}; ${COMMAND}" >> ${LOG_FILE} 2>&1 &
    else
        cd ${SYNOPKG_PKGDEST}
        ${COMMAND} >> ${LOG_FILE} 2>&1 &
    fi
    echo "$!" > "${PID_FILE}"
}


# These functions are for demonstration purpose of DSM sequence call.
# Only provide useful ones for your own package, logging may be removed.
service_preinst ()
{
    echo "service_preinst ${SYNOPKG_PKG_STATUS}" >> $INST_LOG
}

service_postinst ()
{
    echo "service_postinst ${SYNOPKG_PKG_STATUS}" >> $INST_LOG
}

service_preuninst ()
{
    echo "service_preuninst ${SYNOPKG_PKG_STATUS}" >> $INST_LOG
}

service_postinst ()
{
    echo "service_postuninst ${SYNOPKG_PKG_STATUS}" >> $INST_LOG
}

service_preupgrade ()
{
    echo "service_preupgrade ${SYNOPKG_PKG_STATUS}" >> $INST_LOG
}

service_postupgrade ()
{
    echo "service_postupgrade ${SYNOPKG_PKG_STATUS}" >> $INST_LOG
}

service_poststop ()
{
    echo "After stop" >> $LOG_FILE
}
