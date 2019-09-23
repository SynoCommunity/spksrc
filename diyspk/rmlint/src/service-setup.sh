
service_postinst ()
{
    # Put less in the PATH
    mkdir -p /usr/local/bin
    ln -s /var/packages/${SYNOPKG_PKGNAME}/target/bin/rmlint /usr/local/bin/rmlint
}

service_postuninst ()
{
    # Remove link
    rm -f /usr/local/bin/rmlint
}
