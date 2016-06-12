#!/bin/sh

# Package
PACKAGE="sabnzbd-testing"
DNAME="SABnzbd Testing"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PYTHON_DIR="/usr/local/python"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:${PATH}"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
DELUSER="${PYTHON_DIR}/bin/deluser"
DELGROUP="${PYTHON_DIR}/bin/delgroup"
CFG_FILE="${INSTALL_DIR}/var/config.ini"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"
SERVICETOOL="/usr/syno/bin/servicetool"
FWPORTS="/var/packages/${PACKAGE}/scripts/${PACKAGE}.sc"

BUILDNUMBER="$(/bin/get_key_value /etc.defaults/VERSION buildnumber)"
USER="$([ ${BUILDNUMBER} -ge "7135" ] && echo -n sc-sabnzbd-testing || echo -n sabnzbd-testing)"
GROUP="users"
SYNO_GROUP="sc-download"
SYNO_GROUP_DESC="SynoCommunity's download related group"

. `dirname $0`/common

preinst ()
{
    # Check directory
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        check_dir_exist "${wizard_download_dir}"
    fi

    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${INSTALL_DIR}/env > /dev/null

    # Install busybox stuff
    ${INSTALL_DIR}/bin/busybox --install ${INSTALL_DIR}/bin

    create_legacy_user "${USER}" "${GROUP}"
    create_syno_group "${SYNO_GROUP}" "${SYNO_GROUP_DESC}" "${USER}"

    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        # Edit the configuration according to the wizard
        sed -i -e "s|@download_dir@|${wizard_download_dir:=/volume1/downloads}|g" ${CFG_FILE}
        set_legacy_permissions "${wizard_download_dir}"
        set_syno_permissions "${wizard_download_dir}"
    fi

    # Correct the files ownership
    chown -R ${USER}:root ${SYNOPKG_PKGDEST}

    # Add firewall config
    ${SERVICETOOL} --install-configure-file --package ${FWPORTS} > /dev/null

    exit 0
}

preuninst ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    # Uninstall
    if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
        remove_syno_group "${USER}" "${GROUP}"
        # Remove legacy user
        remove_legacy_user "sabnzbd-testing" "${GROUP}"
        # Remove DSM6 user and force refresh of interface
        remove_syno_user "${USER}"
        ${SERVICETOOL} --remove-configure-file --package ${PACKAGE}.sc > /dev/null
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

    # Removal of legacy user when migrated to DSM6
    dsm6_remove_legacy_user "sabnzbd-testing" ${GROUP}

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
