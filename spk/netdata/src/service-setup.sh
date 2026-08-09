SVC_BACKGROUND=y

SERVICE_COMMAND="${SYNOPKG_PKGDEST}/usr/sbin/netdata -D -P ${PID_FILE}"

service_postinst ()
{
    mkdir -p "${SYNOPKG_PKGVAR}/lib/netdata" \
             "${SYNOPKG_PKGVAR}/log/netdata" \
             "${SYNOPKG_PKGVAR}/cache/netdata" \
             "${SYNOPKG_PKGVAR}/etc/netdata"
    # ensure the shipped default config is writable by the service user
    if [ -f "${SYNOPKG_PKGVAR}/etc/netdata/netdata.conf" ]; then
        chown "${EFF_USER}:synocommunity" "${SYNOPKG_PKGVAR}/etc/netdata/netdata.conf"
    fi
}

service_postupgrade () { service_postinst; }
