
MEMCACHED="${SYNOPKG_PKGDEST}/bin/memcached"
MEMORY=$(awk '/MemTotal/{memory=$2/1024*0.15; if (memory > 64) memory=64; printf "%0.f", memory}' /proc/meminfo)
SERVICE_COMMAND="${MEMCACHED} -d -m ${MEMORY} -P ${PID_FILE}"
