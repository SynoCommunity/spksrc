#!/bin/sh

# Package
PACKAGE="apt-mirror"
DNAME="Apt-Mirror"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
CFG_FILE="${INSTALL_DIR}/etc/mirror.list"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"

preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    echo "${wizard_base_dir:=/usr/local/apt-mirror/var/spool/apt-mirror}" > ${INSTALL_DIR}/etc/base_dir

    base_dir=`cat ${INSTALL_DIR}/etc/base_dir`

    # Edit the configuration according to the wizard
    sed -i -e "s|@wizard_base_dir@|${base_dir}|g" ${CFG_FILE}

    # Correct the files ownership
    chown -R root:root ${SYNOPKG_PKGDEST}

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
    sleep 10

    # Save some stuff
    rm -fr ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}

    mv ${INSTALL_DIR}/var ${TMP_DIR}/${PACKAGE}/
    mv ${INSTALL_DIR}/etc ${TMP_DIR}/${PACKAGE}/

    exit 0
}

postupgrade ()
{
    # Restore some stuff
    rm -fr ${INSTALL_DIR}/var
    rm -fr ${INSTALL_DIR}/etc
    mv ${TMP_DIR}/${PACKAGE}/var ${INSTALL_DIR}/
    mv ${TMP_DIR}/${PACKAGE}/etc ${INSTALL_DIR}/
    rm -fr ${TMP_DIR}/${PACKAGE}

    exit 0
}
