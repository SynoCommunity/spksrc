service_postinst ()
{
    # Use the mc-utf8 command for mc
    ln -s ${SYNOPKG_PKGDEST}/bin/mc-utf8 /usr/local/bin/mc
}