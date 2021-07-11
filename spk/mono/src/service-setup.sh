
# mono service setup

service_postinst ()
{
    # Sync ca certificates
    ${SYNOPKG_PKGDEST}/bin/cert-sync /etc/ssl/certs/ca-certificates.crt
}
