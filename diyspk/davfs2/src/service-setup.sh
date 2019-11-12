
COMMANDS="mount.davfs umount.davfs"

service_postinst ()
{
    for cmd in $COMMANDS
    do
        if [ -e "${SYNOPKG_PKGDEST}/sbin/$cmd" ]; then
            ln -s "${SYNOPKG_PKGDEST}/sbin/$cmd" "/usr/local/sbin/$cmd"
        fi
    done
}

service_postuninst ()
{
    for cmd in $COMMANDS
    do
        if [ -L "/usr/local/sbin/$cmd" ]; then
            rm -f "/usr/local/sbin/$cmd"
        fi
    done
}
