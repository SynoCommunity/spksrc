#!/bin/sh

# Package
PACKAGE="deluge"
DNAME="Deluge"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PYTHON_DIR="/usr/local/python"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:${PATH}"
USER="deluge"
GROUP="users"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
CFG_FILE="${INSTALL_DIR}/var/core.conf"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"

SERVICETOOL="/usr/syno/bin/servicetool"
FWPORTS="/var/packages/${PACKAGE}/scripts/${PACKAGE}.sc"

SYNO_GROUP="sc-download"
SYNO_GROUP_DESC="SynoCommunity's download related group"

syno_group_create ()
{
    # Create syno group (Does nothing when group already exists)
    synogroup --add ${SYNO_GROUP} ${USER} > /dev/null
    # Set description of the syno group
    synogroup --descset ${SYNO_GROUP} "${SYNO_GROUP_DESC}"

    # Add user to syno group (Does nothing when user already in the group)
    addgroup ${USER} ${SYNO_GROUP}
}

syno_group_remove ()
{
    # Remove user from syno group
    delgroup ${USER} ${SYNO_GROUP}

    # Check if syno group is empty
    if ! synogroup --get ${SYNO_GROUP} | grep -q "0:"; then
        # Remove syno group
        synogroup --del ${SYNO_GROUP} > /dev/null
    fi
}

preinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        if [ ! -d "${wizard_download_dir}" ]; then
            echo "Download directory ${wizard_download_dir} does not exist."
            exit 1
        fi
        if [ -n "${wizard_watch_dir}" -a ! -d "${wizard_watch_dir}" ]; then
            echo "Watch directory ${wizard_watch_dir} does not exist."
            exit 1
        fi
        if [ -n "${wizard_complete_dir}" -a ! -d "${wizard_complete_dir}" ]; then
            echo "Complete directory ${wizard_complete_dir} does not exist."
            exit 1
        fi
    fi

    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${INSTALL_DIR}/env > /dev/null

    # Install the wheels/requirements
    ${INSTALL_DIR}/env/bin/pip install --use-wheel --no-deps --no-index -U --force-reinstall -f ${INSTALL_DIR}/share/wheelhouse -r ${INSTALL_DIR}/share/wheelhouse/requirements.txt > /dev/null 2>&1

    # Install Deluge
    export PYTHON_EGG_CACHE=${INSTALL_DIR}/env/cache && cd ${INSTALL_DIR}/share/deluge && ${INSTALL_DIR}/env/bin/python setup.py build > /dev/null 2>&1 && ${INSTALL_DIR}/env/bin/python setup.py install > /dev/null 2>&1

    # Create user
    adduser -h ${INSTALL_DIR}/var -g "${DNAME} User" -G ${GROUP} -s /bin/sh -S -D ${USER}

    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        # Edit the configuration according to the wizard
        sed -i -e "s|@download_dir@|${wizard_download_dir:=/volume1/downloads}|g" ${CFG_FILE}
        if [ -d "${wizard_watch_dir}" ]; then
            sed -i -e "s|@watch_dir_enabled@|true|g" ${CFG_FILE}
            sed -i -e "s|@watch_dir@|${wizard_watch_dir}|g" ${CFG_FILE}
        else
            sed -i -e "s|@watch_dir_enabled@|false|g" ${CFG_FILE}
            sed -i -e "s|@watch_dir@|${wizard_download_dir:=/volume1/downloads}|g" ${CFG_FILE}
        fi
        if [ -d "${wizard_complete_dir}" ]; then
            sed -i -e "s|@complete_dir_enabled@|true|g" ${CFG_FILE}
            sed -i -e "s|@complete_dir@|${wizard_complete_dir}|g" ${CFG_FILE}
        else
            sed -i -e "s|@complete_dir_enabled@|false|g" ${CFG_FILE}
            sed -i -e "s|@complete_dir@|${wizard_download_dir:=/volume1/downloads}|g" ${CFG_FILE}
        fi

        # Set group and permissions on download- and watch dir for DSM5
        if [ `/bin/get_key_value /etc.defaults/VERSION buildnumber` -ge "4418" ]; then
            chgrp users ${wizard_download_dir:=/volume1/downloads}
            chmod g+rwx ${wizard_download_dir:=/volume1/downloads}
            if [ -d "${wizard_watch_dir}" ]; then
                chgrp users ${wizard_watch_dir}
                chmod g+rwx ${wizard_watch_dir}
            fi
            if [ -d "${wizard_complete_dir}" ]; then
                chgrp users ${wizard_complete_dir}
                chmod g+rwx ${wizard_complete_dir}
            fi
        fi
    fi

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

    # Remove the user (if not upgrading)
    if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
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
