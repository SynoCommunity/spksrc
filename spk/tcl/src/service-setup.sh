service_postinst ()
{
    ln -s $(find ${SYNOPKG_PKGDEST}/bin/ -name tclsh* -type f -executable) /usr/local/bin/tclsh
}

service_postuninst ()
{
    rm /usr/local/bin/tclsh
}
