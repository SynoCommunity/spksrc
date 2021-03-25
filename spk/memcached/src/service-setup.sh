#!/bin/sh

# Package
PACKAGE="memcached"

# Others
INSTALL_DIR="/var/packages/${PACKAGE}/target/"
WEB_DIR="/var/services/web"
PATH="${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
MEMCACHED="${INSTALL_DIR}/bin/memcached"
SERVICE_COMMAND="${MEMCACHED} -d -m `awk '/MemTotal/{memory=$2/1024*0.15; if (memory > 64) memory=64; printf "%0.f", memory}' /proc/meminfo` -P ${PID_FILE}"

service_postinst ()
{

    # Install the web interface
    cp -Rp ${INSTALL_DIR}/share/phpMemcachedAdmin ${WEB_DIR}

    chown http ${WEB_DIR}/phpMemcachedAdmin/Temp/

    chown http ${WEB_DIR}/phpMemcachedAdmin/Config/

    # Install busybox stuff
    ${INSTALL_DIR}/bin/busybox --install ${INSTALL_DIR}/bin

    return 0
}

service_postuninst ()
{
    # Remove the web interface
    rm -fr ${WEB_DIR}/phpMemcachedAdmin

    return 0
}

service_preupgrade ()
{
    # Remove the web interface
    rm -fr ${WEB_DIR}/phpMemcachedAdmin

    return 0
}
