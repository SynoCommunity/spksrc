service_postinst ()
{
    mkdir -p ${SYNOPKG_PKGDEST}/etc/
    echo "include ${SYNOPKG_PKGDEST}/share/nano/*.nanorc" > ${SYNOPKG_PKGDEST}/etc/nanorc
}
