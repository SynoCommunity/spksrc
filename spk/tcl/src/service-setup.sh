service_postinst ()
{
    ln -s ${SYNOPKG_PKGDEST}/bin/tclsh8.6 /usr/local/bin/tclsh
}

service_postuninst ()
{
    rm /usr/local/bin/tclsh
}
