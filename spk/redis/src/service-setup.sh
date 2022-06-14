
# redis service setup
CFG_FILE="${SYNOPKG_PKGVAR}/redis.conf"
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/redis-server ${CFG_FILE}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

service_postinst ()
{
    # Use 15% of total physical memory with maximum of 64MB
    MEMORY=`awk '/MemTotal/{memory=$2/1024*0.15; if (memory > 64) memory=64; printf "%0.f", memory}' /proc/meminfo`

    # Set the maximum memory to use in configuration file
    sed -i -e "s/@maxmemory@/${MEMORY}mb/g" ${CFG_FILE}
}


# service_restore is called by post_upgrade before restoring files from ${TMP_DIR}
service_restore ()
{
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        # make a copy of the new config files before those are overwritten by restore
        # overwrite existing *.new files in ${TMP_DIR}/ as all files in ${TMP_DIR}/
        # are restored to ${SYNOPKG_PKGVAR}/
        [ -f "${SYNOPKG_PKGVAR}/redis.conf" ] && cp -f ${SYNOPKG_PKGVAR}/redis.conf ${TMP_DIR}/redis.conf.new
        [ -f "${SYNOPKG_PKGVAR}/sentinel.conf" ] && cp -f ${SYNOPKG_PKGVAR}/sentinel.conf ${TMP_DIR}/sentinel.conf.new
    fi
}