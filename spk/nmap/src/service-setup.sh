service_postinst ()
{
    mkdir -p /usr/local/bin
    ln -s /var/packages/"${SYNOPKG_PKGNAME}"/target/bin/nmap /usr/local/bin/nmap
}

service_postuninst ()
{
    rm -f /usr/local/bin/nmap
}
