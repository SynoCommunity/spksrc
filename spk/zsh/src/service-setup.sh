service_postinst ()
{
    # Put zsh in the PATH
    mkdir -p /usr/local/bin
    ln -s /var/packages/${SYNOPKG_PKGNAME}/target/bin/zsh /usr/local/bin/zsh
}

service_postuninst ()
{
    # Remove link
    rm -f /usr/local/bin/zsh
}
