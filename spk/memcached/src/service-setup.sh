#!/bin/sh

# Others
# Only used for DSM 6
WEB_DIR="/var/services/web"
PATH="${SYNOPKG_PKGDEST}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
MEMCACHED="${SYNOPKG_PKGDEST}/bin/memcached"
SERVICE_COMMAND="${MEMCACHED} -d -m `awk '/MemTotal/{memory=$2/1024*0.15; if (memory > 64) memory=64; printf "%0.f", memory}' /proc/meminfo` -P ${PID_FILE}"
CONFIG_DIR="${WEB_DIR}/phpMemcachedAdmin/Config"
CONFIG_BACKUP="${TMP_DIR}/Config"

service_postinst ()
{
    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then

      # Install the web interface
      cp -Rpv "${SYNOPKG_PKGDEST}/share/phpMemcachedAdmin" "${WEB_DIR}"
  
      chown http "${WEB_DIR}/phpMemcachedAdmin/Temp/"
  
      chown http "${WEB_DIR}/phpMemcachedAdmin/Config/"
    fi

    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
      cp -pv "${CONFIG_DIR}/Memcache.sample.php" "${CONFIG_DIR}/Memcache.php"
      chgrp http "${CONFIG_FILE}"
      chmod g+w "${CONFIG_FILE}"
    elif [ -d "${CONFIG_BACKUP}" ]; then
      tar -cf - -C "${CONFIG_BACKUP}" --exclude="Memcache.sample.php" . | tar -xvf - -C "${CONFIG_DIR}"
    else
      cp -pv "${CONFIG_DIR}/Memcache.sample.php" "${CONFIG_DIR}/Memcache.php"
      chgrp http "${CONFIG_FILE}"
      chmod g+w "${CONFIG_FILE}"
    fi
}

service_preuninst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "UPGRADE" ]; then
        if [ -d "${TMP_DIR}/Config/" ]; then
           cp -pRv "${TMP_DIR}/Config" "${TMP_DIR}"
        fi
    fi
}

service_postuninst ()
{
    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
      # Remove the web interface
      rm -fr "${WEB_DIR}/phpMemcachedAdmin"
    fi
}

service_preupgrade ()
{
    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
      # Remove the web interface
      rm -fr "${WEB_DIR}/phpMemcachedAdmin"
    fi
}
