#!/bin/sh

# Package
PACKAGE="znc"
DNAME="ZNC"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
RUNAS="znc"
ZNC="${INSTALL_DIR}/bin/znc"


preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Install busybox stuff
    ${INSTALL_DIR}/bin/busybox --install ${INSTALL_DIR}/bin

    # Create user
    adduser -h ${INSTALL_DIR}/var -g "${DNAME} User" -G nobody -s /bin/sh -S -D ${RUNAS}

    # Edit the configuration according to the wizzard
    sed -i -e "s/@username@/${wizard_username:=admin}/g" ${INSTALL_DIR}/var/configs/znc.conf
    sed -i -e "s/@password@/${wizard_password:=admin}/g" ${INSTALL_DIR}/var/configs/znc.conf

    # Generate certificate
    su - ${RUNAS} -c "${ZNC} -d ${INSTALL_DIR}/var -p" > /dev/null

    # Correct the files ownership
    chown -R ${RUNAS}:root ${SYNOPKG_PKGDEST}

    exit 0
}

preuninst ()
{
    # Remove the user (if not upgrading)
    if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
        deluser ${RUNAS}
    fi

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
    mv ${INSTALL_DIR}/var /tmp/${PACKAGE}/

    exit 0
}

postupgrade ()
{
    # Restore some stuff
    rm -fr ${INSTALL_DIR}/var
    mv  /tmp/${PACKAGE}/var ${INSTALL_DIR}/
    rm -fr /tmp/${PACKAGE}

    exit 0
}
