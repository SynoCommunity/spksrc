
CONFIG_FILE=${SYNOPKG_PKGVAR}/config.toml

SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/autobrr --config ${SYNOPKG_PKGVAR}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

# avoid error "open /sys/fs/cgroup/cpu/autobrr.slice/cpu.cfs_quota_us: no such file or directory"
NPROCS=$(nproc 2>/dev/null)
export GOMAXPROCS=${NPROCS:-1}


service_postinst ()
{
   # initialize random session secret
   SECRET=$(head -c 16 /dev/urandom | xxd -p)
   sed -e s/@@session_secret@@/${SECRET}/g  -i ${CONFIG_FILE}
}
