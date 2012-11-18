#!/bin/sh

# Package
PACKAGE="bitlbee"
DNAME="BitlBee"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/sbin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
RUNAS="bitlbee"
BITLBEE="${INSTALL_DIR}/sbin/bitlbee"
CFG_FILE="${INSTALL_DIR}/var/bitlbee.conf"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"


preinst ()
{
    # Installation wizard requirements
    if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ] && [ -z "${wizard_oper_password}" ]; then
        exit 1
    fi

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
    sed -i -e "s|@auth_password@|`${BITLBEE} -x hash ${wizard_auth_password}`|g" ${CFG_FILE}
    sed -i -e "s|@oper_password@|`${BITLBEE} -x hash ${wizard_oper_password}`|g" ${CFG_FILE}

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
