#!/bin/sh

CFG_FILE=/usr/local/etc/dnscrypt-proxy/dnscrypt-proxy.toml

preinst ()
{
    exit 0
}

postinst ()
{
    mkdir -p /usr/local/bin /usr/local/etc/dnscrypt-proxy /usr/local/run
    ln -s /var/packages/"${SYNOPKG_PKGNAME}"/target/dnscrypt-proxy /usr/local/bin/dnscrypt-proxy
    ln -s /var/packages/"${SYNOPKG_PKGNAME}"/target/example-dnscrypt-proxy.toml ${CFG_FILE}
    sed -i '/listen_addresses/s/127.0.0.1/0.0.0.0/' ${CFG_FILE} # change default address
    sed -i '/listen_addresses/s/:53/:10053/g' ${CFG_FILE} # change default port
    sed -i 's/# log_file/log_file/' ${CFG_FILE} # enable logfile
    sed -i 's@dnscrypt-proxy.log@/usr/local/etc/dnscrypt-proxy/dnscrypt-proxy.log@' ${CFG_FILE} # change logfile location
}

preuninst ()
{
    exit 0
}

postuninst ()
{
    if [ -f /usr/local/run/dnscrypt-proxy.pid ]; then
        rm -f /usr/local/run/dnscrypt-proxy.pid
    fi
    rm -f /usr/local/bin/dnscrypt-proxy
    rm -rf /usr/local/etc/dnscrypt-proxy
}

preupgrade ()
{
    mkdir -p ${TMP_DIR}
    mv ${CFG_FILE} ${TMP_DIR}/dnscrypt-proxy.toml

    exit 0
}

postupgrade ()
{
    rm -f ${CFG_FILE}
    mv ${TMP_DIR}/dnscrypt-proxy.toml ${CFG_FILE}

    exit 0
}
