service_postinst ()
{
    ln -s ${SYNOPKG_PKGDEST}/bin/imapfilter /usr/local/bin/imapfilter
    ln -s ${SYNOPKG_PKGDEST}/share/imapfilter /usr/local/share/
}

service_postuninst ()
{
    rm /usr/local/bin/imapfilter
    rm /usr/local/share/imapfilter
}
