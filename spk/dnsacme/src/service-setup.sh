umask 077

ETC="/var/packages/${SYNOPKG_PKGNAME}/etc"
CONFIG="${ETC}/config.yaml"

SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/dnsacme synology daemon --config ${CONFIG}"
SVC_BACKGROUND=y
SVC_KEEP_LOG=y
SVC_WRITE_PID=y

service_postinst ()
{
    mkdir -p "${ETC}"
}
