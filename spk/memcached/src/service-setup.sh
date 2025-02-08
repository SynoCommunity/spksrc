
PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"
CONFIG_DIR="${SYNOPKG_PKGVAR}/phpmemcachedadmin.config"

MEMCACHED="${SYNOPKG_PKGDEST}/bin/memcached"
MEMORY=$(awk '/MemTotal/{memory=$2/1024*0.15; if (memory > 64) memory=64; printf "%0.f", memory}' /proc/meminfo)
SERVICE_COMMAND="${MEMCACHED} -d -m ${MEMORY} -P ${PID_FILE}"


if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
    # for DSM < 7
    # for owner of var folder
    GROUP=http
    WEB_DIR=/var/services/web
fi

service_postinst ()
{
   # create config file on demand
   if [ ! -e ${CONFIG_DIR}/Memcache.php ]; then
      echo "Create default config file Memcache.php"
      cp -f ${CONFIG_DIR}/Memcache.sample.php ${CONFIG_DIR}/Memcache.php
   fi

   if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then

      # Install the web interface
      cp -R "${SYNOPKG_PKGDEST}/share/phpMemcachedAdmin" ${WEB_DIR}

      # make config writable by http group
      chmod -R g+w ${CONFIG_DIR}

      # make Temp and other folders writable by http group
      chown -R :http ${WEB_DIR}/phpMemcachedAdmin
      chmod -R g+w ${WEB_DIR}/phpMemcachedAdmin
   fi
}

service_postuninst ()
{
   if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
      # Remove the web interface
      rm -rf ${WEB_DIR}/phpMemcachedAdmin
   fi
}
