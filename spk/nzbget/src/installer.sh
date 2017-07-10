#!/bin/sh

# Package
PACKAGE="nzbget"
DNAME="NZBGet"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PATH="${INSTALL_DIR}/bin:${PATH}"
CFG_FILE="${INSTALL_DIR}/var/nzbget.conf"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"
SERVICETOOL="/usr/syno/bin/servicetool"
BUILDNUMBER="$(/bin/get_key_value /etc.defaults/VERSION buildnumber)"
FWPORTS="/var/packages/${PACKAGE}/scripts/${PACKAGE}.sc"

DSM6_UPGRADE="${INSTALL_DIR}/var/.dsm6_upgrade"
SC_USER="sc-nzbget"
SC_GROUP="sc-download"
SC_GROUP_DESC="SynoCommunity's download related group"
LEGACY_USER="nzbget"
LEGACY_GROUP="users"
USER="$([ "${BUILDNUMBER}" -ge "7321" ] && echo -n ${SC_USER} || echo -n ${LEGACY_USER})"


syno_group_create ()
{
    # Create syno group
    synogroup --add ${SC_GROUP} ${USER} > /dev/null
    # Set description of the syno group
    synogroup --descset ${SC_GROUP} "${SC_GROUP_DESC}"
    # Add user to syno group
    addgroup ${USER} ${SC_GROUP}
}

syno_group_remove ()
{
    # Remove user from syno group
    delgroup ${USER} ${SC_GROUP}
    # Check if syno group is empty
    if ! synogroup --get ${SC_GROUP} | grep -q "0:"; then
        # Remove syno group
        synogroup --del ${SC_GROUP} > /dev/null
    fi
}

set_syno_permissions ()
{
    # Sets recursive permissions for ${SC_GROUP} on specified directory
    # Usage: set_syno_permissions "${wizard_download_dir}"
    DIRNAME=$1
    VOLUME=`echo $1 | awk -F/ '{print "/"$2}'`
    # Set read/write permissions for SC_GROUP on target directory
    if [ ! "`synoacltool -get "${DIRNAME}"| grep "group:${SC_GROUP}:allow:rwxpdDaARWc--:fd--"`" ]; then
        synoacltool -add "${DIRNAME}" "group:${SC_GROUP}:allow:rwxpdDaARWc--:fd--" > /dev/null 2>&1
    fi
    # Walk up the tree and set traverse permissions up to VOLUME
    DIRNAME="$(dirname "${DIRNAME}")"
    while [ "${DIRNAME}" != "${VOLUME}" ]; do
        if [ ! "`synoacltool -get "${DIRNAME}"| grep "group:${SC_GROUP}:allow:..x"`" ]; then
            synoacltool -add "${DIRNAME}" "group:${SC_GROUP}:allow:--x----------:---n" > /dev/null 2>&1
        fi
        DIRNAME="$(dirname "${DIRNAME}")"
    done
}


preinst ()
{
    # Check directory
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        if [ ! -d ${wizard_download_dir:=/volume1/downloads} ]; then
            echo "Download directory ${wizard_download_dir} does not exist."
            exit 1
        fi
    fi

    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Install busybox stuff
    ${INSTALL_DIR}/bin/busybox --install ${INSTALL_DIR}/bin

    # Create legacy user
    if [ "${BUILDNUMBER}" -lt "7321" ]; then
        adduser -h ${INSTALL_DIR}/var -g "${DNAME} User" -G ${LEGACY_GROUP} -s /bin/sh -S -D ${LEGACY_USER}
    fi

    syno_group_create

    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        # Edit the configuration according to the wizard
        sed -i -e "s|@download_dir@|${wizard_download_dir:=/volume1/downloads}|g" \
               -e "s/@control_username@/${wizard_control_username:=nzbget}/g" \
               -e "s/@control_password@/${wizard_control_password:=nzbget}/g" \
               ${CFG_FILE}
        # Permissions handling
        if [ "${BUILDNUMBER}" -ge "7321" ]; then
            set_syno_permissions "${wizard_download_dir:=/volume1/downloads}"
        else
            chgrp users ${wizard_download_dir:=/volume1/downloads}
            chmod g+rw ${wizard_download_dir:=/volume1/downloads}
        fi
    fi

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

    # Remove the user (if not upgrading)
    if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
        syno_group_remove
        delgroup ${LEGACY_USER} ${LEGACY_GROUP}
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

    # DSM6 Upgrade handling
    if [ "${BUILDNUMBER}" -ge "7321" ] && [ ! -f ${DSM6_UPGRADE} ]; then
        echo "Deleting legacy user" > ${DSM6_UPGRADE}
        delgroup ${LEGACY_USER} ${LEGACY_GROUP}
        deluser ${LEGACY_USER}
    fi

    # Revision 9 introduces backward incompatible changes
    if [ `echo ${SYNOPKG_OLD_PKGVER} | sed -r "s/^.*-([0-9]+)$/\1/"` -lt 9 ]; then
        echo "Please uninstall previous version, no update possible"
        exit 1
    fi

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

    # Ensure file ownership is correct after upgrade
    chown -R ${USER}:root ${SYNOPKG_PKGDEST}

    exit 0
}
