
# domoticz service definition
DOMOTICZ="${SYNOPKG_PKGDEST}/domoticz"
WWW_PORT="-www ${SERVICE_PORT}"
WWW_ROOT="-wwwroot ${SYNOPKG_PKGDEST}/www"
WWW_DISABLE_HTTPS="-sslwww 0"
WWW_OPTIONS="${WWW_PORT} ${WWW_ROOT} ${WWW_DISABLE_HTTPS}"

# -loglevel (combination of: normal,status,error,debug)
# -debuglevel (combination of: normal,hardware,received,webserver,eventsystem,python,thread_id)
LOG_OPTIONS="-log ${LOG_FILE} -loglevel status,error -debuglevel normal"

DB_FILE="${SYNOPKG_PKGVAR}/domoticz.db"
DATA_OPTIONS="-dbase ${DB_FILE} -userdata ${SYNOPKG_PKGVAR}"

DAEMON_OPTIONS="-daemon -pidfile ${PID_FILE} -noupdates"

SERVICE_COMMAND="${DOMOTICZ} ${DAEMON_OPTIONS} ${WWW_OPTIONS} ${DATA_OPTIONS} ${LOG_OPTIONS}"
