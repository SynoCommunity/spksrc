#!/bin/sh

# Package
PACKAGE="pyload"
DNAME="pyLoad"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PYTHON_DIR="/usr/local/python"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:${PATH}"
USER="pyload"
GROUP="users"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
CFG_FILE="${INSTALL_DIR}/etc/pyload.conf"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"

SERVICETOOL="/usr/syno/bin/servicetool"
FWPORTS="/var/packages/${PACKAGE}/scripts/${PACKAGE}.sc"

lng2iso()
{
	# changes 3-character Synology language code to ISO 639-1 code.
        case $1 in
            eng|deu|fre|ita|nld|sve|rus|plk|csy)
                echo "${1%?}"
                ;;
            spn)
                echo "es"
                ;;
            *)
		echo "en"
		;;
        esac
}


preinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        test "${wizard_download_dir}" || wizard_download_dir="/volume1/downloads"

        # Check whether ${wizard_download_dir} is in existing shared folder.
        VOLUME=$(echo "${wizard_download_dir}" | cut -d/ -f2)
        WIZ_SHARE=$(echo "${wizard_download_dir}" | cut -d/ -f3)
        SHARE_EXISTS=$(synoshare --get "${WIZ_SHARE}" | sed -ne 's/^[[:space:]]*Path[[:space:]\.]*\[\(.*\)\].*$/\1/p')  # FIXME: Better variable name

        if [ -z "${SHARE_EXISTS}" ]; then
               echo "ERROR: Share '${WIZ_SHARE}' doesn't exist."
               exit 1
        fi

        if [ ! -d ${wizard_download_dir} ]; then
            echo "ERROR: Download directory ${wizard_download_dir} doesn't exist."
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

    # Install the bundle
    ${INSTALL_DIR}/env/bin/pip install --no-index -U ${INSTALL_DIR}/share/requirements.pybundle > /dev/null

    # Create user
    adduser -h ${INSTALL_DIR}/etc -g "${DNAME} User" -G ${GROUP} -s /bin/sh -S -D ${USER}

    # Set cfg location
    echo "${INSTALL_DIR}/etc" > "${INSTALL_DIR}/share/pyload/module/config/configdir"

    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        test "${wizard_download_dir}" || wizard_download_dir="/volume1/downloads"

        # Set group and permissions on download dir for DSM5
        if [ `/bin/get_key_value /etc.defaults/VERSION buildnumber` -ge "4418" ]; then
            chgrp users "${wizard_download_dir}"
            chmod g+rwx "${wizard_download_dir}"
        fi

        # Edit the configuration according to the wizard
        sed -i -e " \
            s|@W_DOWNLOAD_DIR@|${wizard_download_dir}|; \
            s|@LNG@|$(lng2iso ${SYNOPKG_DSM_LANGUAGE})| \
               " "${CFG_FILE}"

        # hash password
        SALT=$((RANDOM%99999+10000))
        SALTED_PW_HASH=${SALT}$(echo -n "${SALT}${wizard_password}" | openssl dgst -sha1 2>/dev/null | cut -d" " -f2)

        # init DB & add 'admin' user
        echo -n "4" > "${INSTALL_DIR}/etc/files.version"
        sqlite3 "${INSTALL_DIR}/etc/files.db" < "${INSTALL_DIR}/etc/pyload_init.sql" || exit 1
        sqlite3 "${INSTALL_DIR}/etc/files.db" "INSERT INTO users (name, password) VALUES ('admin', '${SALTED_PW_HASH}')" || exit 1
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
    mv ${INSTALL_DIR}/etc ${TMP_DIR}/${PACKAGE}/

    exit 0
}

postupgrade ()
{
    # Restore some stuff
    rm -fr ${INSTALL_DIR}/etc
    mv ${TMP_DIR}/${PACKAGE}/etc ${INSTALL_DIR}/
    rm -fr ${TMP_DIR}/${PACKAGE}

    exit 0
}
