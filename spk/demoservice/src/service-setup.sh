
# Package specific behaviors
# Sourced script by generic installer and start-stop-status scripts

SERVICE_COMMAND="python -m SimpleHTTPServer ${SERVICE_PORT}"
SVC_CWD="${SYNOPKG_PKGDEST}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y
DEMOSERVICE_INI=${SYNOPKG_PKGDEST}/var/demoservice.ini

# These functions are for demonstration purpose of DSM sequence call.
# Only provide useful ones for your own package, logging may be removed.
service_preinst ()
{
    echo "service_preinst ${SYNOPKG_PKG_STATUS}" >> $INST_LOG
}

service_postinst ()
{
    echo "service_postinst ${SYNOPKG_PKG_STATUS}"   >> $INST_LOG
    echo "# Database created with random password:"     > ${DEMOSERVICE_INI}
    echo "${SYNOPKG_DB_USER_RAND_PW}"                   >> ${DEMOSERVICE_INI}
    echo "ini file created: ${DEMOSERVICE_INI}"     >> $INST_LOG
}

service_preuninst ()
{
    echo "service_preuninst ${SYNOPKG_PKG_STATUS}" >> $INST_LOG
    echo "wizard_mysql_drop_database = ${wizard_mysql_drop_database}"   >> $INST_LOG
    echo "wizard_mysql_drop_db_user = ${wizard_mysql_drop_db_user}"     >> $INST_LOG
}

service_postuninst ()
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
