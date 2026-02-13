ADGUARDHOME="${SYNOPKG_PKGDEST}/bin/adguardhome"
CFG_FILE="${SYNOPKG_PKGVAR}/AdGuardHome.yml"
PID_FILE="${SYNOPKG_PKGVAR}/adguardhome.pid"
WEB_UI="0.0.0.0:${SYNOPKG_PKGPORT}"
SERVICE_COMMAND="${ADGUARDHOME} --web-addr ${WEB_UI} --config ${CFG_FILE} --pidfile ${PID_FILE} --logfile ${LOG_FILE} --work-dir ${SYNOPKG_PKGVAR}"
SVC_BACKGROUND=y

service_postinst () {
    mkdir -p "${SYNOPKG_PKGVAR}/data/"
}