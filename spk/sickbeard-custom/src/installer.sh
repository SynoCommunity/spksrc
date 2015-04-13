#!/bin/sh

# Package
PACKAGE="sickbeard-custom"
DNAME="SickBeard Custom"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PYTHON_DIR="/usr/local/python"
GIT_DIR="/usr/local/git"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:${GIT_DIR}/bin:${PATH}"
USER="sickbeard-custom"
GROUP="users"
GIT="${GIT_DIR}/bin/git"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"

SERVICETOOL="/usr/syno/bin/servicetool"
FWPORTS="/var/packages/${PACKAGE}/scripts/${PACKAGE}.sc"

SYNO_GROUP="sc-media"
SYNO_GROUP_DESC="SynoCommunity's media related group"

syno_group_create ()
{
    # Create sync group (Does nothing when sync group already exists)
    synogroup --add ${SYNO_GROUP} ${USER} > /dev/null
    # Set description of the sync group
    synogroup --descset ${SYNO_GROUP} "${SYNO_GROUP_DESC}"

    # Add user to sync group (Does nothing when user already in the group)
    addgroup ${USER} ${SYNO_GROUP}
}

syno_group_remove ()
{
    # Remove user from sync group
    delgroup ${USER} ${SYNO_GROUP}

    # Check if sync group is empty
    if ! synogroup --get ${SYNO_GROUP} | grep -q "0:"; then
        # Remove sync group
        synogroup --del ${SYNO_GROUP} > /dev/null
    fi
}

preinst ()
{
    # Check fork
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ] && ! ${GIT} ls-remote --heads --exit-code ${wizard_fork_url:=git://github.com/mr-orange/Sick-Beard.git} ${wizard_fork_branch:=Pistachitos} > /dev/null 2>&1; then
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

    # Clone the repository and configure autoProcessTV
    ${GIT} clone -q -b ${wizard_fork_branch:=Pistachitos} ${wizard_fork_url:=git://github.com/mr-orange/Sick-Beard.git} ${INSTALL_DIR}/var/SickBeard
    cp ${INSTALL_DIR}/var/SickBeard/autoProcessTV/autoProcessTV.cfg.sample ${INSTALL_DIR}/var/SickBeard/autoProcessTV/autoProcessTV.cfg
    chmod 777 ${INSTALL_DIR}/var/SickBeard/autoProcessTV
    chmod 600 ${INSTALL_DIR}/var/SickBeard/autoProcessTV/autoProcessTV.cfg

    # Create user
    adduser -h ${INSTALL_DIR}/var -g "${DNAME} User" -G ${GROUP} -s /bin/sh -S -D ${USER}

    syno_group_create

    # Correct the files ownership
    chown -R ${USER}:root ${SYNOPKG_PKGDEST}

    # Add firewall config
    ${SERVICETOOL} --install-configure-file --package ${FWPORTS} >> /dev/null

    exit 0
}

preuninst ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    # Remove the user if uninstalling
    if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" ]; then
        syno_group_remove

        delgroup ${USER} ${GROUP}
        deluser ${USER}
    fi

    # Remove firewall config
    if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" ]; then
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

    syno_group_create

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
