
service_postinst ()
{
    # Put nano in the PATH
    mkdir -p /usr/local/bin
    ln -s /var/packages/${SYNOPKG_PKGNAME}/target/bin/nano /usr/local/bin/nano
}

service_postuninst ()
{
    # Remove link
    rm -f /usr/local/bin/nano
}
