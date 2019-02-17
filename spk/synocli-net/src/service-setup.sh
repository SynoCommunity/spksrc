
COMMANDS="nmap nping sshfs fusermount screen mosh mosh-client mosh-server socat procan filan fritzctl"

service_postinst ()
{
    ln -s "${SYNOPKG_PKGDEST}/bin/tmux-utf8" /usr/local/bin/tmux
    for cmd in $COMMANDS
    do
        if [ -e "${SYNOPKG_PKGDEST}/bin/$cmd" ]; then
            ln -s "${SYNOPKG_PKGDEST}/bin/$cmd" "/usr/local/bin/$cmd"
        fi
    done
}

service_postuninst ()
{
    rm /usr/local/bin/tmux
    for cmd in $COMMANDS
        do
        if [ -e "/usr/local/bin/$cmd" ]; then
            rm -f "/usr/local/bin/$cmd"
        fi
    done
}
