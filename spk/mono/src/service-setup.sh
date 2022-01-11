
# mono service setup

service_postinst ()
{
    # Sync ca certificates
    mkdir -p ${SYNOPKG_PKGVAR}/.config ${SYNOPKG_PKGVAR}/.mono
    HOME="${SYNOPKG_PKGVAR}" ${SYNOPKG_PKGDEST}/bin/cert-sync --user /etc/ssl/certs/ca-certificates.crt
}
