SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/serve"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

service_postinst()
{
    (umask 077 && mkdir -p "${SYNOPKG_PKGVAR}/store" "/var/packages/${SYNOPKG_PKGNAME}/etc/private")
}
