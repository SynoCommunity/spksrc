
# mono service setup

service_postinst ()
{
    # Sync ca certificates
    curl -Lko ${SYNOPKG_PKGDEST}/ca-certificates.crt https://curl.se/ca/cacert.pem
    ${SYNOPKG_PKGDEST}/bin/cert-sync ${SYNOPKG_PKGDEST}/ca-certificates.crt
}
