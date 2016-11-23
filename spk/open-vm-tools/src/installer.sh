#!/bin/sh

# Package
PACKAGE="open-vm-tools"
DNAME="open-vm-tools"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PATH="${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"

preinst ()
{
    SYNOVersion=$(get_key_value /etc/VERSION majorversion)

#    if [ ${SYNOVersion} -gt 4 ]; then
#        echo "Your DSM version is not supported."
#        exit 1
#    fi

    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # create some /var directory - just for us...
    mkdir ${INSTALL_DIR}/var

    # remove network script, because it will stop the poweroff script
    rm -f ${SYNOPKG_PKGDEST}/etc/vmware-tools/scripts/vmware/network

    # create link for etc and lib
    [ -e /etc/vmware-tools ] || ln -s ${SYNOPKG_PKGDEST}/etc/vmware-tools /etc/vmware-tools
    [ -e /lib/open-vm-tools ] || ln -s ${SYNOPKG_PKGDEST}/lib/open-vm-tools /lib/open-vm-tools

cat > /etc/vmware-tools/tools.conf << EOF
bindir = "${SYNOPKG_PKGDEST}/bin"	
libdir = "${SYNOPKG_PKGDEST}/lib"
EOF

# cat > /etc/xpe-release << EOF
# XPEnology DSM
# EOF

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

    # Remove link for etc and lib
    [ -L /etc/vmware-tools ] && rm -f /etc/vmware-tools
    [ -L /lib/open-vm-tools ] && rm -f /lib/open-vm-tools
    # [ -e /etc/xpe-release ]  && rm -f /etc/xpe-release

    exit 0
}

preupgrade ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    # Save some stuff
    rm -fr ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}
    mv ${INSTALL_DIR}/var ${TMP_DIR}/${PACKAGE}/

    exit 0
}

postupgrade ()
{
    # Restore some stuff
    rm -fr ${INSTALL_DIR}/var
    mv ${TMP_DIR}/${PACKAGE}/var ${INSTALL_DIR}/
    rm -fr ${TMP_DIR}/${PACKAGE}

    exit 0
}
