#!/bin/sh

# Package
PACKAGE="debian-chroot"
DNAME="Debian Chroot"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PYTHON_DIR="/usr/local/python"
CHROOTTARGET="${INSTALL_DIR}/var/chroottarget"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/syno/sbin:/usr/syno/bin"
CHROOT_PATH="/usr/local/bin:/usr/bin:/bin"
RUNAS="root"
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

    # Install the bundle
    ${INSTALL_DIR}/env/bin/pip install -U -b ${INSTALL_DIR}/var/build ${INSTALL_DIR}/share/requirements.pybundle > /dev/null
    rm -fr ${INSTALL_DIR}/var/build

    # Setup the database
    ${INSTALL_DIR}/env/bin/python ${INSTALL_DIR}/app/setup.py

    # Correct the files ownership
    chown -R ${RUNAS}:root ${SYNOPKG_PKGDEST}

    # Debootstrap second stage in the background and configure the chroot environment
    if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
        chroot ${CHROOTTARGET}/ /debootstrap/debootstrap --second-stage && \
            mv ${CHROOTTARGET}/etc/apt/sources.list.default ${CHROOTTARGET}/etc/apt/sources.list && \
            mv ${CHROOTTARGET}/etc/apt/preferences.default ${CHROOTTARGET}/etc/apt/preferences && \
            touch ${INSTALL_DIR}/var/installed > /dev/null 2>&1 &
        mkdir -p ${CHROOTTARGET}/proc
        mkdir -p ${CHROOTTARGET}/dev/pts
        mkdir -p ${CHROOTTARGET}/sys
        chmod 666 ${CHROOTTARGET}/dev/null
        chmod 666 ${CHROOTTARGET}/dev/tty
        chmod 777 ${CHROOTTARGET}/tmp
        cp /etc/hosts /etc/hostname /etc/resolv.conf ${CHROOTTARGET}/etc/
    fi

	# Index help files
	pkgindexer_add ${INSTALL_DIR}/app/index.conf > /dev/null
	pkgindexer_add ${INSTALL_DIR}/app/helptoc.conf > /dev/null

    exit 0
}

preuninst ()
{
	# Remove help files
	pkgindexer_del ${INSTALL_DIR}/app/index.conf > /dev/null
	pkgindexer_del ${INSTALL_DIR}/app/helptoc.conf > /dev/null

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

