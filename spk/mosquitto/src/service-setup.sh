CFG_FILE="${SYNOPKG_PKGDEST}/var/mosquitto.conf"
PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/sbin/mosquitto -d -c ${CFG_FILE}"

service_postinst ()
{
    # Discard legacy obsolete busybox user account
    BIN=${SYNOPKG_PKGDEST}/bin
    $BIN/busybox --install $BIN
    $BIN/delgroup "${USER}" "users" >> ${INST_LOG}
    $BIN/deluser "${USER}" >> ${INST_LOG}
}
