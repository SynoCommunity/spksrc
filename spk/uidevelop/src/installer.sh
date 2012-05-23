#!/bin/sh

# Package
PACKAGE="uidevelop"
DNAME="UI Develop"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
RUNAS="root"
VIRTUALENV="/usr/local/python/bin/virtualenv"

preinst ()
{
    # Installation wizard requirements
    if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ] && [ ! -d "${wizard_install_dir}" ]; then
        exit 1
    fi

    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Install files and link the app
    mkdir ${wizard_install_dir}/uidevelop/
    mv ${INSTALL_DIR}/data/* ${wizard_install_dir}/uidevelop/
    chmod -R 777 ${wizard_install_dir}/uidevelop/
    ln -s ${wizard_install_dir}/uidevelop/ ${INSTALL_DIR}/app

    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${INSTALL_DIR}/env > /dev/null

    # Install the bundle
    ${INSTALL_DIR}/env/bin/pip install -U -b ${INSTALL_DIR}/var/build ${INSTALL_DIR}/share/requirements.pybundle > /dev/null
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

