#!/bin/sh

# Package
PACKAGE="duplicity"
DNAME="Duplicity"

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
    ${VIRTUALENV} --system-site-packages ${INSTALL_DIR}/env > /dev/null

    # Install the wheels
    ${INSTALL_DIR}/env/bin/pip install --no-deps --no-index -U --force-reinstall -f ${INSTALL_DIR}/share/wheelhouse ${INSTALL_DIR}/share/wheelhouse/*.whl > /dev/null 2>&1

    # fix monotonic python library missing synology ld utils
    sed -i -e "s/ctypes.util.find_library('c')/'\/lib\/libc.so.6'/" /usr/local/duplicity/env/lib/python2.7/site-packages/monotonic.py
    sed -i -e "s/ctypes.util.find_library('rt')/'\/lib\/librt.so.1'/" /usr/local/duplicity/env/lib/python2.7/site-packages/monotonic.py

    # Add symlink
    mkdir -p /usr/local/bin
    ln -s ${INSTALL_DIR}/env/bin/duplicity /usr/local/bin/duplicity
    ln -s ${INSTALL_DIR}/share/duply/duply /usr/local/bin/duply

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
    rm -f /usr/local/bin/duplicity
    rm -f /usr/local/bin/duply
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
