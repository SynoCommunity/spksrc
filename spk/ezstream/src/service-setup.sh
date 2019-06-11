service_postinst ()
{
    ln -s ${SYNOPKG_PKGDEST}/bin/ezstream /usr/local/bin/ezstream
}

service_postuninst ()
{
    rm /usr/local/bin/ezstream
}
