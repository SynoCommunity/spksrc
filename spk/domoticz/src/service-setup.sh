
# domoticz service definition
DOMOTICZ="${SYNOPKG_PKGDEST}/bin/domoticz"
WWW_PORT="-www ${SERVICE_PORT}"
WWW_ROOT="-wwwroot ${SYNOPKG_PKGDEST}/www"
WWW_DISABLE_HTTPS="-sslwww 0"
WWW_OPTIONS="${WWW_PORT} ${WWW_ROOT} ${WWW_DISABLE_HTTPS}"

# -loglevel (combination of: normal,status,error,debug)
# -debuglevel (combination of: normal,hardware,received,webserver,eventsystem,python,thread_id)
LOG_OPTIONS="-log ${LOG_FILE} -loglevel status,error -debuglevel normal,webserver"

DB_FILE="${SYNOPKG_PKGVAR}/domoticz.db"
DATA_OPTIONS="-dbase ${DB_FILE} -userdata ${SYNOPKG_PKGVAR}"

DAEMON_OPTIONS="-daemon -pidfile ${PID_FILE} -noupdates"

SERVICE_COMMAND="${DOMOTICZ} ${DAEMON_OPTIONS} ${WWW_OPTIONS} ${DATA_OPTIONS} ${LOG_OPTIONS}"

UDEV_RULES=/usr/lib/udev/rules.d/70-sc-domoticz.rules

service_postinst ()
{
    if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ]; then
        > ${UDEV_RULES}
        echo "#author: SynoCommunity Team"  >> ${UDEV_RULES}
        echo "" >> ${UDEV_RULES}
        echo "KERNEL==\"ttyUSB*\", ACTION==\"add\", USER=\"${EFF_USER}\", MODE=\"0600\"" >> ${UDEV_RULES}
        echo "KERNEL==\"ttyACM*\", ACTION==\"add\", USER=\"${EFF_USER}\", MODE=\"0600\"" >> ${UDEV_RULES}
        udevadm control --reload-rules
    fi
}


service_postuninst ()
{
    if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ]; then
        if [ -w ${UDEV_RULES} ]; then
            rm -f ${UDEV_RULES}
            udevadm control --reload-rules
        fi
    fi
}
