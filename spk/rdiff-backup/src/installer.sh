#!/bin/sh

# Package
PACKAGE="rdiff-backup"
DNAME="rdiff-backup"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PYTHON_DIR="/usr/local/python"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
PATH="${INSTALL_DIR}/env/bin:${INSTALL_DIR}/bin:${PYTHON_DIR}/bin:${PATH}"

preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Create a Python virtualenv
    ${VIRTUALENV} ${INSTALL_DIR}/env > /dev/null

    # Install the wheels
    ${INSTALL_DIR}/env/bin/pip install --no-deps --no-index -U --force-reinstall -f ${INSTALL_DIR}/share/wheelhouse ${INSTALL_DIR}/share/wheelhouse/*.whl > /dev/null 2>&1

    # Fix shebang
    sed -i -e "s|^#!.*$|#!${INSTALL_DIR}/env/bin/python|g" ${INSTALL_DIR}/env/bin/rdiff-backup

    # Add symlink
    mkdir -p /usr/local/bin
    ln -s ${INSTALL_DIR}/env/bin/rdiff-backup /usr/local/bin/rdiff-backup

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
    rm -f /usr/local/bin/rdiff-backup

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
