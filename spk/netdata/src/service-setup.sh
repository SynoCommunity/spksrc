SVC_BACKGROUND=y

SERVICE_COMMAND="${SYNOPKG_PKGDEST}/usr/sbin/netdata -D -P ${PID_FILE}"

service_postinst ()
{
    mkdir -p "${SYNOPKG_PKGVAR}/lib/netdata" \
             "${SYNOPKG_PKGVAR}/log/netdata" \
             "${SYNOPKG_PKGVAR}/cache/netdata" \
             "${SYNOPKG_PKGVAR}/etc/netdata"
}

service_postupgrade () { service_postinst; }
