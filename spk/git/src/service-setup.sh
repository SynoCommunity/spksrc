
service_postinst ()
{
    if [ -e "${SYNOPKG_PKGDEST}/bin/git" ]; then
        ln -s "${SYNOPKG_PKGDEST}/bin/git" "/usr/local/bin/git"
    fi
}

service_postuninst ()
{
    if [ -L "/usr/local/bin/git" ]; then
        rm -f "/usr/local/bin/git"
    fi
}
