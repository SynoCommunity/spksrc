
# mono service setup

service_postinst ()
{
    # Sync ca certificates
    mkdir -p ${SYNOPKG_PKGDEST}/share/.config ${SYNOPKG_PKGDEST}/share/.mono
    HOME="${SYNOPKG_PKGDEST}/share" ${MONO_PATH}/cert-sync --user /etc/ssl/certs/ca-certificates.crt
}
