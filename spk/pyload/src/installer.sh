#!/bin/sh

# Package
PACKAGE="pyload"
DNAME="pyLoad Download Manager"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PYTHON_DIR="/usr/local/python"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
RUNAS="pyload"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"
CFG_FILE="${INSTALL_DIR}/var/pyload.conf"


preinst ()
{
    # Installation wizard requirements
    if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ] && [ ! -d "${wizard_download_dir}" ]; then
        exit 1
    fi

    exit 0

}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${INSTALL_DIR}/env > /dev/null

    # Create user
    adduser -h ${INSTALL_DIR}/var -g "${DNAME} User" -G users -s /bin/sh -S -D ${RUNAS}

    # Edit the configuration according to the wizzard
    sed -i -e "s|@download_dir@|${wizard_download_dir}|g" ${CFG_FILE}

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

