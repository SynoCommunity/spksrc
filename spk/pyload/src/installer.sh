#!/bin/sh

# Package
PACKAGE="pyload"
DNAME="pyLoad"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PYTHON_DIR="/usr/local/python"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:${PATH}"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
CFG_FILE="${INSTALL_DIR}/etc/pyload.conf"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"
SERVICETOOL="/usr/syno/bin/servicetool"
BUILDNUMBER="$(/bin/get_key_value /etc.defaults/VERSION buildnumber)"
FWPORTS="/var/packages/${PACKAGE}/scripts/${PACKAGE}.sc"

DSM6_UPGRADE="${INSTALL_DIR}/var/.dsm6_upgrade"
SC_USER="sc-pyload"
SC_GROUP="sc-download"
SC_GROUP_DESC="SynoCommunity's download related group"
LEGACY_USER="pyload"
LEGACY_GROUP="users"
USER="$([ "${BUILDNUMBER}" -ge "7321" ] && echo -n ${SC_USER} || echo -n ${LEGACY_USER})"


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
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        # Check directory
        if [ ! -d ${wizard_download_dir:=/volume1/downloads} ]; then
            echo "Download directory ${wizard_download_dir:=/volume1/downloads} does not exist."
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

    # Create legacy user
    if [ "${BUILDNUMBER}" -lt "7321" ]; then
        adduser -h ${INSTALL_DIR}/var -g "${DNAME} User" -G ${LEGACY_GROUP} -s /bin/sh -S -D ${LEGACY_USER}
    fi

    syno_group_create

    # Set cfg location
    echo "${INSTALL_DIR}/etc" > "${INSTALL_DIR}/share/pyload/module/config/configdir"

    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        # Permissions handling
        if [ "${BUILDNUMBER}" -ge "7321" ]; then
            set_syno_permissions "${wizard_download_dir:=/volume1/downloads}"
        else
            chgrp users ${wizard_download_dir:=/volume1/downloads}
            chmod g+rwx ${wizard_download_dir:=/volume1/downloads}
        fi

        # Edit the configuration according to the wizard
        sed -i -e "s|@W_DOWNLOAD_DIR@|${wizard_download_dir:=/volume1/downloads}|" \
               -e "s|@LNG@|$(lng2iso ${SYNOPKG_DSM_LANGUAGE})|" \
               "${CFG_FILE}"

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

    if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
        # Remove the user (if not upgrading)
        syno_group_remove
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
