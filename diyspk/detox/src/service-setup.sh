
service_postinst ()
{
    # Put less in the PATH
    mkdir -p /usr/local/bin
    ln -s /var/packages/${SYNOPKG_PKGNAME}/target/bin/detox /usr/local/bin/detox
}

service_postuninst ()
{
    # Remove link
    rm -f /usr/local/bin/detox
}
