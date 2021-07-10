
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

