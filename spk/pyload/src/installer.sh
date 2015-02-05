#!/bin/sh

# Package
PACKAGE="pyload"
DNAME="pyLoad"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:${PATH}"
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

        mkdir -p "${SYNOPKG_PKGINST_TEMP_DIR}/etc"

        # Check whether ${wizard_download_dir} is in existing shared folder.
        VOLUME=$(echo "${wizard_download_dir}" | cut -d/ -f2)
        WIZ_SHARE=$(echo "${wizard_download_dir}" | cut -d/ -f3)
        SHARE_EXISTS=$(synoshare --get "${WIZ_SHARE}" | sed -ne 's/^[[:space:]]*Path[[:space:]\.]*\[\(.*\)\].*$/\1/p')  # FIXME: Better variable name

        if [ -z "${SHARE_EXISTS}" ]; then
               echo "ERROR: Share '${WIZ_SHARE}' doesn't exist." > ${SYNOPKG_TEMP_LOGFILE}
               exit 1
        fi

        if [ ! -d ${wizard_download_dir} ]; then
            echo "ERROR: Folder ${wizard_download_dir} doesn't exist." > ${SYNOPKG_TEMP_LOGFILE}
            exit 1
        fi

	# TODO: Check write permissions (related to run under non-root user)

    fi
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Set cfg location
    echo "${INSTALL_DIR}/etc" > "${INSTALL_DIR}/share/pyload/module/config/configdir"

    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        test "${wizard_download_dir}" || wizard_download_dir="/volume1/downloads"

        # Setting cfg
        sed -e " \
            s|@W_DOWNLOAD_DIR@|${wizard_download_dir}|; \
            s|@LNG@|$(lng2iso ${SYNOPKG_DSM_LANGUAGE})| \
               " \
                  < "${INSTALL_DIR}/share/pyload/module/config/default_syn.conf" \
                  > "${INSTALL_DIR}/etc/pyload.conf"

        # hash password
        SALT=$((RANDOM%99999+10000))
        SALTED_PW_HASH=${SALT}$(echo -n "${SALT}${wizard_password}" | openssl dgst -sha1 2>/dev/null | cut -d" " -f2)

        # init DB & add 'admin' user
        echo -n "4" > "${INSTALL_DIR}/etc/files.version"
        sqlite3 "${INSTALL_DIR}/etc/files.db" < "${INSTALL_DIR}/share/pyload/module/config/pyload_init.sql" > ${SYNOPKG_TEMP_LOGFILE} || exit 1
        sqlite3 "${INSTALL_DIR}/etc/files.db" "INSERT INTO users (name, password) VALUES ('admin', '${SALTED_PW_HASH}')" > ${SYNOPKG_TEMP_LOGFILE} || exit 1

        # Additional (optional) config/examples
        cp -f "${INSTALL_DIR}/share/pyload/module/config/htaccess.example" "${INSTALL_DIR}/etc/"
    fi
    
    # Add firewall config
    ${SERVICETOOL} --install-configure-file --package ${FWPORTS} >> /dev/null

    exit 0
}

preuninst ()
{
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
    # Keep existing cfg while upgrading
    if [ -d "${SYNOPKG_PKGINST_TEMP_DIR}" -a -d "${INSTALL_DIR}/etc" ]; then
        cp -a "${INSTALL_DIR}/etc" "${SYNOPKG_PKGINST_TEMP_DIR}"
    else
        echo "Upgrade failed: Cannot copy existing configuration" > ${SYNOPKG_TEMP_LOGFILE}
        exit 1
    fi
    exit 0
}

postupgrade ()
{
    exit 0
}
