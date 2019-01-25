
service_postinst ()
{
    # Put rhash in the PATH
    mkdir -p /usr/local/bin
    ln -s /var/packages/${SYNOPKG_PKGNAME}/target/bin/rhash /usr/local/bin/rhash
}

service_postuninst ()
{
    # Remove link
    rm -f /usr/local/bin/rhash
}
