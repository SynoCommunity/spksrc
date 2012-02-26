#!/bin/sh

# Package
PACKAGE="sickbeard"
DNAME="SickBeard"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PYTHON_DIR="/usr/local/python"
RUNAS="sickbeard"
PATH="${INSTALL_DIR}/bin:${PYTHON_DIR}/bin:/bin:/usr/bin:/usr/syno/bin"
CFG_FILE="${INSTALL_DIR}/var/config.ini"


preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Install the bundle
    pip install -b ${INSTALL_DIR}/var/build -U ${INSTALL_DIR}/share/requirements.pybundle > /dev/null
    rm -fr ${INSTALL_DIR}/var/build

    # Create user
    adduser -h ${INSTALL_DIR}/var -g "${DNAME} User" -G users -s /bin/sh -S -D ${RUNAS}

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
    rm -fr /tmp/${PACKAGE}
    mkdir /tmp/${PACKAGE}
    mv ${INSTALL_DIR}/var /tmp/${PACKAGE}/

    exit 0
}

postupgrade ()
{
    # Restore some stuff
    rm -fr ${INSTALL_DIR}/var
    mv /tmp/${PACKAGE}/var ${INSTALL_DIR}/
    rm -fr /tmp/${PACKAGE}

    exit 0
}
