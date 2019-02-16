
service_postinst ()
{
    ln -s ${SYNOPKG_PKGDEST}/bin/comskip /usr/local/bin/comskip
}

service_postuninst ()
{
    rm /usr/local/bin/comskip
}
