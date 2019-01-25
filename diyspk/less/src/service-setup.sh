
service_postinst ()
{
    # Put less in the PATH
    mkdir -p /usr/local/bin
    ln -s /var/packages/${SYNOPKG_PKGNAME}/target/bin/less /usr/local/bin/less
}

service_postuninst ()
{
    # Remove link
    rm -f /usr/local/bin/less
}
