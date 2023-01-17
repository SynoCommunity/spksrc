service_postinst ()
{
    # Sync certificate
    ${SYNOPKG_PKGDEST}/bin/cert-sync /etc/ssl/certs/ca-certificates.crt >> ${INST_LOG} 2>&1
}
