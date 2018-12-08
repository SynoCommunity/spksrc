
service_postinst ()
{
    ln -s ${SYNOPKG_PKGDEST}/bin/temacs /usr/local/bin/temacs
}

service_postuninst ()
{
    rm -f /usr/local/bin/temacs
}
