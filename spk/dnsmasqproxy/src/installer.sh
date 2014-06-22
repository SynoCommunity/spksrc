#!/bin/sh

# Package
PACKAGE="dnsmasqproxy"
DNAME="DnsMasq Proxy"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PATH="${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
USER="root"
CFG_FILE="${INSTALL_DIR}/etc/dnsmasq.conf"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"

preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}
    ln -s /usr/syno/sbin/dnsmasq ${INSTALL_DIR}/sbin/dnsmasq

    # Setup pxe folder
    synoshare --get TFTP_PXE
    if [ $? != 0 ]; then
    su -c 'synoshare --add TFTP_PXE "TFTP_PXE shared folder" /volume1/TFTP_PXE "" "admin" "" 1 0' - ${USER}
    else
    echo "Directory already exist"
    exit 1
    fi
	
    cp -R ${INSTALL_DIR}/share/* /volume1/TFTP_PXE

    # Setup config file
    sed -i -e "s|@server-ip@|${syno_server_ip}|g" ${CFG_FILE}

    # Correct the files ownership
    chown -R ${USER}:root ${SYNOPKG_PKGDEST}

    exit 0
}

preuninst ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    exit 0
}

postuninst ()
{
    # Remove link
    rm -f ${INSTALL_DIR}

    exit 0
}

preupgrade ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    # Save some stuff
    rm -fr ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}
    mv ${INSTALL_DIR}/etc ${TMP_DIR}/${PACKAGE}/

    exit 0
}

postupgrade ()
{
    # Restore some stuff
    rm -fr ${INSTALL_DIR}/etc
    mv ${TMP_DIR}/${PACKAGE}/etc ${INSTALL_DIR}/
    rm -fr ${TMP_DIR}/${PACKAGE}

    exit 0
}
