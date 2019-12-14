
service_postinst ()
{
    ln -s ${SYNOPKG_PKGDEST}/bin/sshfs /usr/local/bin/sshfs
    ln -s ${SYNOPKG_PKGDEST}/bin/fusermount /usr/local/bin/fusermount
}

service_postuninst ()
{
    rm /usr/local/bin/sshfs
    rm /usr/local/bin/fusermount
}
