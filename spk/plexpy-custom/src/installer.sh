#!/bin/sh

# Package
PACKAGE="plexpy-custom"
DNAME="PlexPy Custom"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PYTHON_DIR="/usr/local/python"
GIT_DIR="/usr/local/git"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:${GIT_DIR}/bin:${PATH}"
GIT="${GIT_DIR}/bin/git"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"
SERVICETOOL="/usr/syno/bin/servicetool"
BUILDNUMBER="$(/bin/get_key_value /etc.defaults/VERSION buildnumber)"
FWPORTS="/var/packages/${PACKAGE}/scripts/${PACKAGE}.sc"

DSM6_UPGRADE="${INSTALL_DIR}/var/.dsm6_upgrade"
SC_USER="sc-plexpy-custom"
LEGACY_USER="plexpy-custom"
LEGACY_GROUP="users"
USER="$([ "${BUILDNUMBER}" -ge "7321" ] && echo -n ${SC_USER} || echo -n ${LEGACY_USER})"


preinst ()
{
    # Check fork
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ] && ! ${GIT} ls-remote --heads --exit-code ${wizard_fork_url:=git://github.com/JonnyWong16/plexpy/plexpy.git} ${wizard_fork_branch:=master} > /dev/null 2>&1; then
        echo "Incorrect fork"
        exit 1
    fi

    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${INSTALL_DIR}/env > /dev/null

    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        # Clone the repository
        ${GIT} clone --depth 10 --recursive -q -b ${wizard_fork_branch:=master} ${wizard_fork_url:=git://github.com/JonnyWong16/plexpy.git} ${INSTALL_DIR}/var/plexpy > /dev/null 2>&1
    fi

    # Create legacy user
    if [ "${BUILDNUMBER}" -lt "7321" ]; then
        adduser -h ${INSTALL_DIR}/var -g "${DNAME} User" -G ${LEGACY_GROUP} -s /bin/sh -S -D ${LEGACY_USER}
    fi

    # Add firewall config
    ${SERVICETOOL} --install-configure-file --package ${FWPORTS} >> /dev/null


    # Correct the files ownership
    chown -R ${USER}:root ${SYNOPKG_PKGDEST}

    exit 0
}

preuninst ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
        # Remove the user (if not upgrading)
        delgroup ${LEGACY_USER} ${LEGACY_GROUP}
        deluser ${USER}

        # Remove firewall configuration
        ${SERVICETOOL} --remove-configure-file --package ${PACKAGE}.sc >> /dev/null
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
    # Stop the package
    ${SSS} stop > /dev/null

    # DSM6 Upgrade handling
    if [ "${BUILDNUMBER}" -ge "7321" ] && [ ! -f ${DSM6_UPGRADE} ]; then
        echo "Deleting legacy user" > ${DSM6_UPGRADE}
        delgroup ${LEGACY_USER} ${LEGACY_GROUP}
        deluser ${LEGACY_USER}
    fi

    # Save config & database
    rm -fr ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}
    cp ${INSTALL_DIR}/var/config.ini ${TMP_DIR}/${PACKAGE}/config.ini
    cp ${INSTALL_DIR}/var/plexpy.db ${TMP_DIR}/${PACKAGE}/plexpy.db
    cp ${INSTALL_DIR}/var/GeoLite2-City.mmdb ${TMP_DIR}/${PACKAGE}/GeoLite2-City.mmdb

    exit 0
}

postupgrade ()
{
    # Restore config & database
    cp ${TMP_DIR}/${PACKAGE}/config.ini ${INSTALL_DIR}/var/config.ini
    cp ${TMP_DIR}/${PACKAGE}/plexpy.db ${INSTALL_DIR}/var/plexpy.db
    cp ${TMP_DIR}/${PACKAGE}/GeoLite2-City.mmdb ${INSTALL_DIR}/var/GeoLite2-City.mmdb

    rm -fr ${TMP_DIR}/${PACKAGE}

    exit 0
}
