
if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
    # Only used for DSM 6
    WEB_DIR="/var/services/web"
    CONFIG_DIR="${WEB_DIR}/phpMemcachedAdmin/Config"
    CONFIG_FILE="${CONFIG_DIR}/Memcache.php"
    CONFIG_BACKUP="${TMP_DIR}/Config"
fi

PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"
MEMCACHED="${SYNOPKG_PKGDEST}/bin/memcached"
MEMORY=$(awk '/MemTotal/{memory=$2/1024*0.15; if (memory > 64) memory=64; printf "%0.f", memory}' /proc/meminfo)
SERVICE_COMMAND="${MEMCACHED} -d -m ${MEMORY} -P ${PID_FILE}"

service_postinst ()
{
    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
    
        # Install the web interface
        cp -Rpv "${SYNOPKG_PKGDEST}/share/phpMemcachedAdmin" "${WEB_DIR}"

        if [ -d "${CONFIG_BACKUP}" ]; then
            tar -cf - -C "${CONFIG_BACKUP}" --exclude="Memcache.sample.php" . | tar -xvf - -C "${CONFIG_DIR}"
        fi

        chown http "${WEB_DIR}/phpMemcachedAdmin/Temp/"
        chown http "${CONFIG_DIR}"
        chown http "${CONFIG_FILE}"
    fi
}

service_preuninst ()
{
    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
        if [ "${SYNOPKG_PKG_STATUS}" == "UPGRADE" ]; then
            if [ -d "${TMP_DIR}/Config/" ]; then
                cp -pRv "${TMP_DIR}/Config" "${TMP_DIR}"
            fi
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
