SVC_BACKGROUND=y
SVC_WRITE_PID=y

SERVICE_COMMAND="${SYNOPKG_PKGDEST}/usr/sbin/netdata -D -P ${PID_FILE}"

_setup_runtime_dirs ()
{
    ln -sf "${SYNOPKG_PKGVAR}" "${SYNOPKG_PKGDEST}/var"
    mkdir -p "${SYNOPKG_PKGVAR}/lib/netdata" \
             "${SYNOPKG_PKGVAR}/log/netdata" \
             "${SYNOPKG_PKGVAR}/cache/netdata"
}

service_postinst () { _setup_runtime_dirs; }
service_postupgrade () { _setup_runtime_dirs; }
