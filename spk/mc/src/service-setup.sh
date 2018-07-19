service_postinst ()
{
    # Use the mc-utf8 command for mc
    ln -s ${SYNOPKG_PKGDEST}/bin/mc-utf8 /usr/local/bin/mc
    ln -s ${SYNOPKG_PKGDEST}/bin/mc-utf8 /usr/local/bin/mcedit
    ln -s ${SYNOPKG_PKGDEST}/bin/mc-utf8 /usr/local/bin/mcdiff
    ln -s ${SYNOPKG_PKGDEST}/bin/mc-utf8 /usr/local/bin/mcview
}

service_postuninst ()
{
     # Remove symlinks
     rm -f /usr/local/bin/mc
     rm -f /usr/local/bin/mcedit
     rm -f /usr/local/bin/mcdiff
     rm -f /usr/local/bin/mcview
}
