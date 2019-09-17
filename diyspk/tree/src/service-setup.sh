
service_postinst ()
{
    # Put tree in the PATH
    mkdir -p /usr/local/bin
    ln -s /var/packages/${SYNOPKG_PKGNAME}/target/bin/tree /usr/local/bin/tree
}

service_postuninst ()
{
    # Remove link
    rm -f /usr/local/bin/tree
}
