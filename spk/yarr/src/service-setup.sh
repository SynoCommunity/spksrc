YARR_BIN="${SYNOPKG_PKGDEST}/bin/yarr"
DB_FILE="${SYNOPKG_PKGVAR}/yarr.db"
LOG_FILE="${SYNOPKG_PKGVAR}/yarr.log"

SERVICE_COMMAND="${YARR_BIN} -addr 0.0.0.0:${SERVICE_PORT} -db ${DB_FILE} -log-file ${LOG_FILE}"
SVC_BACKGROUND=y

service_postinst ()
{
    install -d -m 755 "${SYNOPKG_PKGVAR}"
}
