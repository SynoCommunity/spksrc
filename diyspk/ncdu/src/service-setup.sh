
service_postinst ()
{
    # Put ncdu in the PATH
    mkdir -p /usr/local/bin
    ln -s /var/packages/${SYNOPKG_PKGNAME}/target/bin/ncdu /usr/local/bin/ncdu
}

service_postuninst ()
{
    # Remove link
    rm -f /usr/local/bin/ncdu
}
