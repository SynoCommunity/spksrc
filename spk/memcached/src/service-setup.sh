
if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
    # for DSM < 7
    CONFIG_DIR="${SYNOPKG_PKGVAR}/phpmemcachedadmin.config"
    # for owner of var folder
    GROUP=http
    WEB_DIR="/var/services/web"
    INSTALL_DIR="/usr/local/${PACKAGE}"
    LEGACY_USER="memcached"
    LEGACY_GROUP="nobody"
    SERVICETOOL="/usr/syno/bin/servicetool"
fi

PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"
MEMCACHED="${SYNOPKG_PKGDEST}/bin/memcached"
MEMORY=$(awk '/MemTotal/{memory=$2/1024*0.15; if (memory > 64) memory=64; printf "%0.f", memory}' /proc/meminfo)
SERVICE_COMMAND="${MEMCACHED} -d -m ${MEMORY} -P ${PID_FILE}"

service_postinst ()
{
    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
        # Link
        ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}
    
        # Install the web interface
        cp -R "${SYNOPKG_PKGDEST}/share/phpMemcachedAdmin" ${WEB_DIR}
    
        # Install busybox stuff
        "${SYNOPKG_PKGDEST}/bin/busybox" --install "${SYNOPKG_PKGDEST}/bin"
    
        # Create legacy user
        if [ "${BUILDNUMBER}" -lt "7321" ]; then
            adduser -h "${SYNOPKG_PKGVAR}" -g "${DNAME} User" -G ${LEGACY_GROUP} -s /bin/sh -S -D ${LEGACY_USER}
        fi
    fi

    # create Memcache.php on demand
    if [ ! -e "${SYNOPKG_PKGVAR}/phpmemcachedadmin.config/Memcache.php" ]; then
        echo "Create default config file Memcache.php"
        cp -f ${SYNOPKG_PKGVAR}/phpmemcachedadmin.config/Memcache.sample.php ${SYNOPKG_PKGVAR}/phpmemcachedadmin.config/Memcache.php
    fi

    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
        # make config writable by http group
        chmod -R g+w ${CONFIG_DIR}
        chown -R :http ${WEB_DIR}/phpMemcachedAdmin
        # make Temp and other folders writable by http group
        chmod -R g+w ${WEB_DIR}/phpMemcachedAdmin
    fi
}

service_preuninst ()
{
      if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
        if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
            # Remove the user (if not upgrading)
            delgroup ${LEGACY_USER} ${LEGACY_GROUP}
            deluser ${USER}
    
            # Remove firewall configuration
            ${SERVICETOOL} --remove-configure-file --package ${PACKAGE}.sc >> /dev/null
        fi
      fi
}

service_postuninst ()
{
    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
      # Remove the web interface
      rm -fr ${WEB_DIR}/phpMemcachedAdmin
  
      # Remove link
      rm -f ${INSTALL_DIR}
    
    fi
}

service_preupgrade ()
{

    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
      # DSM6 Upgrade handling
      if [ "${BUILDNUMBER}" -ge "7321" ] && [ ! -f ${DSM6_UPGRADE} ]; then
          echo "Deleting legacy user" > ${DSM6_UPGRADE}
          delgroup ${LEGACY_USER} ${LEGACY_GROUP}
          deluser ${LEGACY_USER}
      fi
    fi
}
