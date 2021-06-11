# domoticz service definition

DOMOTICZ="${SYNOPKG_PKGDEST}/bin/domoticz"
DB_FILE="${SYNOPKG_PKGVAR}/domoticz.db"
WWW_PORT="-www ${SERVICE_PORT}"
WWW_ROOT="-wwwroot ${SYNOPKG_PKGDEST}/www"
WWW_DISABLE_HTTPS="-sslwww 0"
WWW_OPTIONS="${WWW_PORT} ${WWW_ROOT} ${WWW_DISABLE_HTTPS}"

SERVICE_COMMAND="${DOMOTICZ} -daemon ${WWW_OPTIONS} -dbase ${DB_FILE} -userdata ${SYNOPKG_PKGVAR} -pidfile ${PID_FILE} -noupdates -log ${LOG_FILE}"

