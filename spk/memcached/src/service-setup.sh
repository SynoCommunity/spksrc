
if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
    # for DSM < 7
    CONFIG_DIR="${SYNOPKG_PKGVAR}/phpmemcachedadmin.config"
    # for owner of var folder
    GROUP=http
fi

PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"
MEMCACHED="${SYNOPKG_PKGDEST}/bin/memcached"
MEMORY=$(awk '/MemTotal/{memory=$2/1024*0.15; if (memory > 64) memory=64; printf "%0.f", memory}' /proc/meminfo)
SERVICE_COMMAND="${MEMCACHED} -d -m ${MEMORY} -P ${PID_FILE}"

service_postinst ()
{
    # create Memcache.php on demand
    if [ ! -e "${SYNOPKG_PKGVAR}/phpmemcachedadmin.config/Memcache.php" ]; then
        echo "Create default config file Memcache.php"
        cp -f ${SYNOPKG_PKGVAR}/phpmemcachedadmin.config/Memcache.sample.php ${SYNOPKG_PKGVAR}/phpmemcachedadmin.config/Memcache.php
    fi

    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
        # make config writable by http group
        chmod -R g+w ${CONFIG_DIR}
        chown -R :http ${SYNOPKG_PKGDEST}/share
        # make Temp and other folders writable by http group
        chmod -R g+w ${SYNOPKG_PKGDEST}/share
    fi
}
