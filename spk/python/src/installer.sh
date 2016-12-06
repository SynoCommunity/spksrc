#!/bin/sh

# Package
PACKAGE="python"
DNAME="Python"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:${PATH}"


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

    # Install the wheels
    ${INSTALL_DIR}/bin/pip install --no-deps --no-index -U --force-reinstall -f ${INSTALL_DIR}/share/wheelhouse ${INSTALL_DIR}/share/wheelhouse/*.whl > /dev/null 2>&1

    # Log installation informations
    ${INSTALL_DIR}/bin/python --version > ${INSTALL_DIR}/install.log 2>&1
    echo "" >> ${INSTALL_DIR}/install.log
    echo "System installed modules:" >> ${INSTALL_DIR}/install.log
    ${INSTALL_DIR}/bin/pip freeze >> ${INSTALL_DIR}/install.log

    # Byte-compile in background
    ${INSTALL_DIR}/bin/python -m compileall -q -f ${INSTALL_DIR}/lib/python2.7 > /dev/null &
    ${INSTALL_DIR}/bin/python -OO -m compileall -q -f ${INSTALL_DIR}/lib/python2.7 > /dev/null &

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

