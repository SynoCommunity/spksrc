
COMMANDS="nmap nping sshfs fusermount"

service_postinst ()
{
    ln -s ${SYNOPKG_PKGDEST}/bin/tmux-utf8 /usr/local/bin/tmux
    for cmd in $COMMANDS; do ln -s ${SYNOPKG_PKGDEST}/bin/$cmd /usr/local/bin/$cmd; done
}

service_postuninst ()
{
    rm /usr/local/bin/tmux
    for cmd in $COMMANDS; do rm -f /usr/local/bin/$cmd; done
}
