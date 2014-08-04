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
    ln -s ${INSTALL_DIR}/bin/python /usr/local/bin/python
    ln -s ${INSTALL_DIR}/bin/python2 /usr/local/bin/python2
    ln -s ${INSTALL_DIR}/bin/python2.7 /usr/local/bin/python2.7
    ln -s ${INSTALL_DIR}/bin/pydoc /usr/local/bin/pydoc
    ln -s ${INSTALL_DIR}/bin/pip /usr/local/bin/pip

    # Install busybox stuff
    ${INSTALL_DIR}/bin/busybox --install ${INSTALL_DIR}/bin

    # Log installation informations
    ${INSTALL_DIR}/bin/python --version > ${INSTALL_DIR}/install.log 2>&1
    echo "" >> ${INSTALL_DIR}/install.log
    echo "System installed modules:" >> ${INSTALL_DIR}/install.log
    ${INSTALL_DIR}/bin/pip freeze >> ${INSTALL_DIR}/install.log

    # Set the permissions
    chown -hR root:root ${SYNOPKG_PKGDEST}
    chmod -R go-w ${SYNOPKG_PKGDEST}

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
    rm -f /usr/local/bin/python
    rm -f /usr/local/bin/python2
    rm -f /usr/local/bin/python2.7
    rm -f /usr/local/bin/pydoc
    rm -f /usr/local/bin/pip

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

