
service_postinst ()
{
    # Put jdupes in the PATH
    mkdir -p /usr/local/bin
    ln -s /var/packages/${SYNOPKG_PKGNAME}/target/bin/jdupes /usr/local/bin/jdupes
}

service_postuninst ()
{
    # Remove link
    rm -f /usr/local/bin/jdupes
}
