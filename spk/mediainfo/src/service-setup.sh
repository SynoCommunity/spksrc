
service_postinst ()
{
    ln -s ${SYNOPKG_PKGDEST}/bin/mediainfo /usr/local/bin/mediainfo
}

service_postuninst ()
{
    rm /usr/local/bin/mediainfo
}
