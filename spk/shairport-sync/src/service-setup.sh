
service_postinst ()
{
    echo "Install busybox" >> "${INST_LOG}"
    ${SYNOPKG_PKGDEST}/bin/busybox --install -s ${SYNOPKG_PKGDEST}/bin >> ${INST_LOG}
}
