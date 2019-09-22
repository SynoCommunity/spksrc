
service_postinst ()
{
    # Put a link in /usr/local/bin to reach by PATH
    ln -s /var/packages/${SYNOPKG_PKGNAME}/target/bin/file /usr/local/bin/file
}

service_postuninst ()
{
    # Remove link
    rm -f /usr/local/bin/file
}
