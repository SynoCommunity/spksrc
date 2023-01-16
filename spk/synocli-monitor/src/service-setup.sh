
service_postinst ()
{
    echo "Install busybox"
    ${SYNOPKG_PKGDEST}/bin/busybox --install -s ${SYNOPKG_PKGDEST}/bin
}

