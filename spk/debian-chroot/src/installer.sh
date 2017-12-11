#!/bin/sh

# Package
PACKAGE="debian-chroot"
DNAME="Debian Chroot"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PYTHON_DIR="/usr/local/python"
CHROOTTARGET="${INSTALL_DIR}/var/chroottarget"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:${PATH}"
CHROOT_PATH="/usr/local/bin:/usr/bin:/bin"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"

preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${INSTALL_DIR}/env > /dev/null

    # Install the wheels
    ${INSTALL_DIR}/env/bin/pip install --no-deps --no-index -U --force-reinstall -f ${INSTALL_DIR}/share/wheelhouse ${INSTALL_DIR}/share/wheelhouse/*.whl > /dev/null 2>&1

    # Setup the database
    ${INSTALL_DIR}/env/bin/python ${INSTALL_DIR}/app/setup.py

    # Debootstrap second stage in the background and configure the chroot environment
    if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
        chroot ${CHROOTTARGET}/ /debootstrap/debootstrap --second-stage > /dev/null 2>&1 && \
            mv ${CHROOTTARGET}/etc/apt/sources.list.default ${CHROOTTARGET}/etc/apt/sources.list && \
            mv ${CHROOTTARGET}/etc/apt/preferences.default ${CHROOTTARGET}/etc/apt/preferences && \
            touch ${INSTALL_DIR}/var/installed &
        chmod 666 ${CHROOTTARGET}/dev/null
        chmod 666 ${CHROOTTARGET}/dev/tty
        chmod 777 ${CHROOTTARGET}/tmp
        cp /etc/hosts /etc/hostname /etc/resolv.conf ${CHROOTTARGET}/etc/
    fi

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

