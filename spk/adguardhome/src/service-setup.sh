ADGUARDHOME="${SYNOPKG_PKGDEST}/bin/adguardhome"
CFG_FILE="${SYNOPKG_PKGVAR}/var/AdGuardHome.yml"
PID_FILE="${SYNOPKG_PKGVAR}/var/adguardhome.pid"
WEB_UI="0.0.0.0:${SYNOPKG_PKGPORT}"
SERVICE_COMMAND="${ADGUARDHOME} --web-addr ${WEB_UI} -c ${CFG_FILE} --pidfile ${PID_FILE} -l ${LOG_FILE}"
SVC_BACKGROUND=y

# service_postinst() {
#     setcap 'CAP_NET_BIND_SERVICE=+eip CAP_NET_RAW=+eip' $(ADGUARDHOME)
# }