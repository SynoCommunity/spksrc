#!/bin/sh

# Others
# Only used for DSM 6
WEB_DIR="/var/services/web_packages"
DSM6_WEB_DIR="/var/services/web"
DSM7_WEB_DIR="/var/services/web_packages"
if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
WEB_DIR="${DSM6_WEB_DIR}"
else
WEB_DIR="${DSM7_WEB_DIR}"
fi

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
}

service_postuninst ()
{
    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
      # Remove the web interface
      rm -fr "${WEB_DIR}/phpMemcachedAdmin"
    fi
}

service_restore () 
{
    tar -cf - -C "${CONFIG_BACKUP}" . | tar -xvf - -C "${CONFIG_DIR}"
    rm -rvf "${CONFIG_BACKUP}"
}

service_preupgrade ()
{
    if [ -d "${CONFIG_DIR}" ]; then
      mkdir -p "${CONFIG_BACKUP}"
      tar -cf - -C "${CONFIG_DIR}" --exclude="Memcache.sample.php" . | tar -xvf - -C "${CONFIG_BACKUP}"
    fi
    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
      # Remove the web interface
      rm -fr "${WEB_DIR}/phpMemcachedAdmin"
    fi
}

