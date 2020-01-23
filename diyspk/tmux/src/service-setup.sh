
service_postinst ()
{
    ln -s ${SYNOPKG_PKGDEST}/bin/tmux-utf8 /usr/local/bin/tmux
}

service_postuninst ()
{
    rm /usr/local/bin/tmux
}
