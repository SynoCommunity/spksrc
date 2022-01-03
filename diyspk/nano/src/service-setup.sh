service_postinst ()
{
    mkdir -p /var/packages/${SYNOPKG_PKGNAME}/target/etc/
    echo "include /var/packages/${SYNOPKG_PKGNAME}/target/share/nano/*.nanorc" > /var/packages/${SYNOPKG_PKGNAME}/target/etc/nanorc
}
