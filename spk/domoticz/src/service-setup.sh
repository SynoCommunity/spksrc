
# domoticz service definition
DOMOTICZ="${SYNOPKG_PKGDEST}/domoticz"
WWW_PORT="-www ${SERVICE_PORT}"
WWW_ROOT="-wwwroot ${SYNOPKG_PKGDEST}/www"
WWW_DISABLE_HTTPS="-sslwww 0"
WWW_OPTIONS="${WWW_PORT} ${WWW_ROOT} ${WWW_DISABLE_HTTPS}"

# -loglevel (combination of: normal,status,error,debug)
# -debuglevel (combination of: normal,hardware,received,webserver,eventsystem,python,thread_id)
LOG_OPTIONS="-loglevel status,error -debuglevel normal"

DB_FILE="${SYNOPKG_PKGVAR}/domoticz.db"
DATA_OPTIONS="-dbase ${DB_FILE} -userdata ${SYNOPKG_PKGVAR}"

DAEMON_OPTIONS="-noupdates"

# Run in the foreground: the framework backgrounds it, redirects stdout/stderr
# to LOG_FILE and writes PID_FILE itself (SVC_WRITE_PID). This avoids the
# duplicated startup lines from -daemon/-log both writing to the same file and
# the daemon's own pid file.
SERVICE_COMMAND="${DOMOTICZ} ${DAEMON_OPTIONS} ${WWW_OPTIONS} ${DATA_OPTIONS} ${LOG_OPTIONS}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y
