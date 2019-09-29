#!/bin/sh

# Package
PACKAGE="bazarr"
DNAME="Bazarr"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PYTHON_DIR="/usr/local/python"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
PATH="${INSTALL_DIR}/env/bin:${INSTALL_DIR}/bin:${PYTHON_DIR}/bin:${PATH}"
VAR_DIR="${INSTALL_DIR}/var"
BAZARR_DIR="${INSTALL_DIR}/share/bazarr"

DATA_DIRECTORY="${BAZARR_DIR}/data"
BACKUP_DIR="/tmp/bazarr/"

SC_USER="sc-${PACKAGE}"
GROUP="sc-download"

service_postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR};

    mkdir -p "${VAR_DIR}";
    
    set_unix_permissions "${VAR_DIR}" >> "${INST_LOG}"

    echo "Setting up python installation..."  >> "${INST_LOG}"

    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${INSTALL_DIR}/env >> "${INST_LOG}"

    # Install the wheels

    echo "Installing python requirements..."  >> "${INST_LOG}"

    ${INSTALL_DIR}/env/bin/pip install \
        --no-deps --no-index -U --force-reinstall \
        -f ${INSTALL_DIR}/share/wheelhouse ${INSTALL_DIR}/share/wheelhouse/*.whl >> "${INST_LOG}"

    echo "Running busybox installation..."  >> "${INST_LOG}"

    # Install busybox
    ${INSTALL_DIR}/bin/busybox --install ${INSTALL_DIR}/bin
}

service_preupgrade ()
{
    if [ -d "${DATA_DIRECTORY}" ]
    then
        echo "Backing up data directory..." >> "${INST_LOG}"
        mkdir -p "${BACKUP_DIR}" >> "${INST_LOG}"
        mv -v "${DATA_DIRECTORY}" "${BACKUP_DIR}/data" >> "${INST_LOG}"
    fi
}

service_postupgrade ()
{
    if [ -d "${BACKUP_DIR}" ]
    then
        echo "Restoring data directory..." >> "${INST_LOG}"
        mv -v "${BACKUP_DIR}/data" "${DATA_DIRECTORY}" >> "${INST_LOG}"
        set_unix_permissions "${DATA_DIRECTORY}"
    fi
}
