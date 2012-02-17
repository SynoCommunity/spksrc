#!/bin/sh

# Package
PACKAGE="umurmur"
DNAME="uMurmur"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
RUNAS="root"
UPGRADE="/tmp/${PACKAGE}.upgrade"
GEN_CERT="${INSTALL_DIR}/sbin/gencert.sh"
LOG_FILE="${INSTALL_DIR}/var/umurmurd.log"


preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Create empty log file with full permissions (for nobody)
    touch ${LOG_FILE}
    chmod 777 ${LOG_FILE}

    # Certificate generation
    ${GEN_CERT} > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        exit 1
    fi

    # Correct the files ownership
    chown -R ${RUNAS}:root ${SYNOPKG_PKGDEST}

    exit 0
}

preuninst ()
{
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
    # Save some stuff
    rm -fr /tmp/${PACKAGE}
    mkdir /tmp/${PACKAGE}
    cp ${INSTALL_DIR}/etc/umurmur.conf /tmp/${PACKAGE}/
    cp ${INSTALL_DIR}/etc/umurmur.key /tmp/${PACKAGE}/
    cp ${INSTALL_DIR}/etc/umurmur.crt /tmp/${PACKAGE}/

    # Create the upgrade flag
    touch ${UPGRADE}

    exit 0
}

postupgrade ()
{
    # Restore some stuff
    mv /tmp/${PACKAGE}/umurmur.conf ${INSTALL_DIR}/etc/
    mv /tmp/${PACKAGE}/umurmur.crt ${INSTALL_DIR}/etc/
    mv /tmp/${PACKAGE}/umurmur.key ${INSTALL_DIR}/etc/
    rm -fr /tmp/${PACKAGE}

    # Remove the upgrade flag
    rm  ${UPGRADE}

    exit 0
}
