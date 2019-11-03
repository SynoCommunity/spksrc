
service_postinst ()
{
    # Put a link in /usr/local/bin to reach by PATH
    ln -s /var/packages/${SYNOPKG_PKGNAME}/target/bin/lsscsi /usr/local/bin/lsscsi
}

service_postuninst ()
{
    # Remove link
    rm -f /usr/local/bin/lsscsi
}
