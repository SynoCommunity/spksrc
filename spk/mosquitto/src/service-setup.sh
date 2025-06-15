# mosquitto service definition

CFG_FILE="${SYNOPKG_PKGVAR}/mosquitto.conf"
PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/sbin/mosquitto -d -c ${CFG_FILE}"

# service_restore is called by post_upgrade before restoring files from ${TMP_DIR}
service_restore ()
{
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        OLD_SPK_REV="${SYNOPKG_OLD_PKGVER##*-}"
        if [ -n "${OLD_SPK_REV}" ] && [ ${OLD_SPK_REV} -lt 13 ]; then
            # make a copy of the new config file before it is overwritten by restore
            # copy new config file to ${TMP_DIR}/ as all files in ${TMP_DIR}/
            # are restored to ${SYNOPKG_PKGVAR}/
            [ -f "${CFG_FILE}" ] && cp -f ${CFG_FILE} ${TMP_DIR}/mosquitto.conf.new
        fi
    fi
}
