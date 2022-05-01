#!/bin/sh

# Others
# Only used for DSM 6
WEB_DIR="/var/services/web"
PATH="${SYNOPKG_PKGDEST}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
MEMCACHED="${SYNOPKG_PKGDEST}/bin/memcached"
SERVICE_COMMAND="${MEMCACHED} -d -m `awk '/MemTotal/{memory=$2/1024*0.15; if (memory > 64) memory=64; printf "%0.f", memory}' /proc/meminfo` -P ${PID_FILE}"

service_postinst ()
{

    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then

      # Install the web interface
      cp -Rp "${SYNOPKG_PKGDEST}/share/phpMemcachedAdmin" "${WEB_DIR}"
  
      chown http "${WEB_DIR}/phpMemcachedAdmin/Temp/"
  
      chown http "${WEB_DIR}/phpMemcachedAdmin/Config/"
    fi

    return 0
}

service_postuninst ()
{
    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
      # Remove the web interface
      rm -fr "${WEB_DIR}/phpMemcachedAdmin"
    fi

    return 0
}

service_preupgrade ()
{
    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
      # Remove the web interface
      rm -fr "${WEB_DIR}/phpMemcachedAdmin"
    fi

    return 0
}
