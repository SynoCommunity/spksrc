PATH=${SYNOPKG_PKGDEST}/bin:${PATH}
INTERFACE=$(ip r | awk '/^default/{print $5}')
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/sbin/darkstat -i ${INTERFACE} -p ${SERVICE_PORT} --chroot ${SYNOPKG_PKGVAR} --pidfile ${PID_FILE} --import darkstat.data --export darkstat.data"
