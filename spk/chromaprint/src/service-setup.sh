
service_postinst ()
{
    ln -s ${SYNOPKG_PKGDEST}/bin/fpcalc /usr/local/bin/fpcalc
}

service_postuninst ()
{
    rm /usr/local/bin/fpcalc
}
