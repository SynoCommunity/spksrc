#!/bin/sh

# Package
PACKAGE="nzbconfig"
DNAME="NZB Config"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
RUNAS="root"
VIRTUALENV="/usr/local/python/bin/virtualenv"

preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${INSTALL_DIR}/env

    # Install the bundle
    ${INSTALL_DIR}/env/bin/pip install -b ${INSTALL_DIR}/var/build ${INSTALL_DIR}/share/requirements.pybundle > /dev/null
    rm -fr ${INSTALL_DIR}/var/build

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
    exit 0
}

postupgrade ()
{
    exit 0
}

