COMMANDS="fidentify photorec testdisk"

service_postinst ()
{
    for cmd in $COMMANDS
    do
        if [ -e "${SYNOPKG_PKGDEST}/bin/$cmd" ]; then
            ln -s "${SYNOPKG_PKGDEST}/bin/$cmd" "/usr/local/bin/$cmd"
        fi
    done
}

service_postuninst ()
{
    for cmd in $COMMANDS
    do
        if [ -L "/usr/local/bin/$cmd" ]; then
            rm -f "/usr/local/bin/$cmd"
        fi
    done
}
