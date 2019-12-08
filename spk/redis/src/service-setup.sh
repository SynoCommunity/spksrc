CFG_FILE="${SYNOPKG_PKGDEST}/var/redis.conf"
PATH="${SYNOPKG_PKGDEST}:${PATH}"
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/redis-server ${CFG_FILE}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y


service_postinst ()
{
    # Set the maximum memory to use in configuration file
    sed -i -e "s/@maxmemory@/${MEMORY}mb/g" ${CFG_FILE}
}


