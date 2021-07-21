# mosquitto service definition

CFG_FILE="${SYNOPKG_PKGVAR}/mosquitto.conf"
PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/sbin/mosquitto -d -c ${CFG_FILE}"

