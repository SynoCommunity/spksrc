#!/bin/sh

# Package
PACKAGE="rutorrent"
DNAME="ruTorrent"
PACKAGE_NAME="com.synocommunity.packages.${PACKAGE}"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
WEB_DIR="/var/services/web"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/usr/bin:${PATH}"
APACHE_USER="$([ $(grep buildnumber /etc.defaults/VERSION | cut -d"\"" -f2) -ge 4418 ] && echo -n http || echo -n nobody)"
BUILDNUMBER="$(/bin/get_key_value /etc.defaults/VERSION buildnumber)"

GROUP="sc-download"
GROUP_DESC="SynoCommunity's download related group"
LEGACY_USER="rutorrent"
LEGACY_GROUP="users"

PYTHON_DIR="/usr/local/python3"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"

# Sets recursive read / execute permissions for ${KEY} on specified directory
# Usage: grant_basic_permissions "${SHARE_FOLDER}" "user:<user>"
# Usage: grant_basic_permissions "${SHARE_FOLDER}" "group:<group>"
grant_basic_permissions ()
{
    DIRNAME=`realpath "${1}"`
    KEY="${2}"

    VOLUME=$(echo "${DIRNAME}" | awk -F/ '{print "/"$2}')

    # Ensure directory resides in /volumeX before setting GROUP permissions
    if [ "`echo ${VOLUME} | cut -c2-7`" = "volume" ]; then
        # Set read & execute permissions for KEY for folder and subfolders
        if [ ! "`synoacltool -get \"${DIRNAME}\"| grep \"${KEY}:allow:r.x...a.R....:fd..\"`" ]; then
            # First Unix permissions, but only if it's in Linux mode
            if [ "`synoacltool -get \"${DIRNAME}\"| grep \"Linux mode\"`" ]; then
                set_unix_permissions "${DIRNAME}"
                # If it is linux mode (due to old package) we need to add "administrators"-group,
                # otherwise the folder is not accessible from File Station anymore!
                synoacltool -add "${DIRNAME}" "group:administrators:allow:rwxpdDaARWc:fd" >> ${INST_LOG} 2>&1
            fi

            # Then fix the Synology permissions
            echo "Granting '${KEY}' basic permissions on ${DIRNAME}" >> ${INST_LOG}
            synoacltool -add "${DIRNAME}" "${KEY}:allow:rxaR:fd" >> ${INST_LOG} 2>&1
            find "${DIRNAME}" -mindepth 1 -type d -exec synoacltool -enforce-inherit "{}" \; >> ${INST_LOG} 2>&1
        fi

        # Walk up the tree and set traverse execute permissions for GROUP up to VOLUME
        while [ "${DIRNAME}" != "${VOLUME}" ]; do
            if [ ! "`synoacltool -get \"${DIRNAME}\"| grep \"${KEY}:allow:r.x...a.R\"`" ]; then
                # Here we also need to make sure the admin can access data via File Station
                if [ "`synoacltool -get \"${DIRNAME}\"| grep \"Linux mode\"`" ]; then
                    synoacltool -add "${DIRNAME}" "group:administrators:allow:rwxpdDaARWc--:fd--" >> ${INST_LOG} 2>&1
                fi
                # Add the new group permissions
                echo "Granting '${KEY}' basic permissions on ${DIRNAME}" >> ${INST_LOG}
                synoacltool -add "${DIRNAME}" "${KEY}:allow:rxaR:n" >> ${INST_LOG} 2>&1
            fi
            DIRNAME="$(dirname "${DIRNAME}")"
        done
    else
        echo "Skip granting '${KEY}' basic permissions on ${DIRNAME} as the directory does not reside in '/volumeX'. Set manually if needed." >> ${INST_LOG}
    fi
}

service_preinst ()
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
    fi

    exit 0
}

fix_shared_folders_rights()
{
    local folder=$1
    echo "Fixing shared folder rights for ${folder}" >> "${INST_LOG}"
    chown -R "${APACHE_USER}:${USER}" "${folder}" >> "${INST_LOG}" 2>&1
    chmod ug+rwx "${folder}" >> "${INST_LOG}" 2>&1
    synoacltool -add "${folder}" "user:${EFF_USER}:allow:rwxpdDaARWcC:fd" >> "${INST_LOG}" 2>&1
    synoacltool -add "${folder}" "user:${APACHE_USER}:allow:rwxpdDaARWcC:fd" >> "${INST_LOG}" 2>&1
    find "${folder}" -mindepth 1 -type d -exec synoacltool -enforce-inherit "{}" \; >> ${INST_LOG} 2>&1
}

service_postinst ()
{

    # Install busybox stuff
    ${INSTALL_DIR}/bin/busybox --install ${INSTALL_DIR}/bin

    syno_user_add_to_legacy_group "${EFF_USER}" "${LEGACY_USER}" "${LEGACY_GROUP}"

    # Install the web interface
    cp -pR ${INSTALL_DIR}/share/${PACKAGE} ${WEB_DIR} >>"${INST_LOG}" 2>&1

    # Configure open_basedir
    if [ "${APACHE_USER}" == "nobody" ]; then
        echo -e "<Directory \"${WEB_DIR}/${PACKAGE}\">\nphp_admin_value open_basedir none\n</Directory>" > /usr/syno/etc/sites-enabled-user/${PACKAGE}.conf
    else
        if [ -d "/etc/php/conf.d/" ]; then
            echo -e "[PATH=${WEB_DIR}/${PACKAGE}]\nopen_basedir = Null" > /etc/php/conf.d/${PACKAGE_NAME}.ini
        fi
    fi

    # Configure files
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        TOP_DIR=`echo "${wizard_download_dir:=/volume1/downloads}" | cut -d "/" -f 2`
        MAX_MEMORY=`awk '/MemTotal/{memory=$2*1024*0.25; if (memory > 512*1024*1024) memory=512*1024*1024; printf "%0.f", memory}' /proc/meminfo`

        sed -i -e "s|scgi_port = 5000;|scgi_port = 8050;|g" \
               -e "s|topDirectory = '/';|topDirectory = '/${TOP_DIR}/';|g" \
               -e "s|tempDirectory = null;|tempDirectory = '${INSTALL_DIR}/tmp/';|g" \
               -e "s|\"python\"\(\\s*\)=>\(\\s*\)'.*'\(\\s*\),\(\\s*\)|\"python\"\1=>\2'${INSTALL_DIR}/env/bin/python3'\3,\4|g" \
               -e "s|\"pgrep\"\(\\s*\)=>\(\\s*\)'.*'\(\\s*\),\(\\s*\)|\"pgrep\"\1=>\2'${INSTALL_DIR}/bin/pgrep'\3,\4|g" \
               -e "s|\"sox\"\(\\s*\)=>\(\\s*\)'.*'\(\\s*\),\(\\s*\)|\"sox\"\1=>\2'${INSTALL_DIR}/bin/sox'\3,\4|g" \
               -e "s|\"mediainfo\"\(\\s*\)=>\(\\s*\)'.*'\(\\s*\),\(\\s*\)|\"mediainfo\"\1=>\2'${INSTALL_DIR}/bin/mediainfo'\3,\4|g" \
               -e "s|\"stat\"\(\\s*\)=>\(\\s*\)'.*'\(\\s*\),\(\\s*\)|\"stat\"\1=>\2'/bin/stat'\3,\4|g" \
               -e "s|\"curl\"\(\\s*\)=>\(\\s*\)'.*'\(\\s*\),\(\\s*\)|\"curl\"\1=>\2'${INSTALL_DIR}/bin/curl'\3,\4|g" \
               -e "s|\"id\"\(\\s*\)=>\(\\s*\)'.*'\(\\s*\),\(\\s*\)|\"id\"\1=>\2'/bin/id'\3,\4|g" \
               -e "s|\"gzip\"\(\\s*\)=>\(\\s*\)'.*'\(\\s*\),\(\\s*\)|\"gzip\"\1=>\2'/bin/gzip'\3,\4|g" \
               -e "s|\"php\"\(\\s*\)=>\(\\s*\)'.*'\(\\s*\),\(\\s*\)|\"php\"\1=>\2'/bin/php'\3,\4|g" \
               ${WEB_DIR}/${PACKAGE}/conf/config.php >>"${INST_LOG}" 2>&1

        sed -i -e "s|@download_dir@|${wizard_download_dir:=/volume1/downloads}|g" \
               -e "s|@max_memory@|$MAX_MEMORY|g" \
               -e "s|@port_range@|${wizard_port_range:=6881-6999}|g" \
               ${INSTALL_DIR}/var/.rtorrent.rc >>"${INST_LOG}" 2>&1

        if [ -d "${wizard_watch_dir}" ]; then
            sed -i -e "s|@watch_dir@|${wizard_watch_dir}|g" ${INSTALL_DIR}/var/.rtorrent.rc >>"${INST_LOG}" 2>&1
        else
            sed -i -e "/@watch_dir@/d" ${INSTALL_DIR}/var/.rtorrent.rc >>"${INST_LOG}" 2>&1
        fi

        if [ "${wizard_disable_openbasedir}" == "true" ] && [ "${APACHE_USER}" == "http" ]; then
            if [ -f "/etc/php/conf.d/user-settings.ini" ]; then
                sed -i -e "s|^open_basedir.*|open_basedir = none|g" /etc/php/conf.d/user-settings.ini >>"${INST_LOG}" 2>&1
                initctl restart php-fpm > /dev/null 2>&1
            fi
        fi
        # Permissions handling
        if [ "${BUILDNUMBER}" -ge "4418" ]; then
            set_syno_permissions "${wizard_download_dir:=/volume1/downloads}" "${GROUP}"
            if [ -d "${wizard_watch_dir}" ]; then
                set_syno_permissions "${wizard_watch_dir}" "${GROUP}"
            fi
        fi
    fi


    #If python3 is available setup a virtual environment with cloudscraper
    if [ -f "${PYTHON_DIR}/bin/python3" ]; then
        # Create a Python virtualenv
        ${VIRTUALENV} --system-site-packages ${INSTALL_DIR}/env >> "${INST_LOG}" 2>&1
        # Install the cloudscraper wheels
        ${INSTALL_DIR}/env/bin/pip install -U cloudscraper==1.2.48 >> "${INST_LOG}" 2>&1
    fi

    # Ensure that the rutorrent group still owns the installation directory
    set_syno_permissions "${INSTALL_DIR}" "rutorrent"

    # Ensure that the web user has read access to var/.session directory
    grant_basic_permissions "${INSTALL_DIR}/var/.session" "user:${APACHE_USER}"

    # Ensure that the apache user has full rights on the web directory
    set_syno_permissions "${WEB_DIR}/${PACKAGE}" "${APACHE_USER}"

    grant_basic_permissions "${INSTALL_DIR}/bin" "user:${APACHE_USER}"
    grant_basic_permissions "${INSTALL_DIR}/lib" "user:${APACHE_USER}"
    grant_basic_permissions "${INSTALL_DIR}/env" "user:${APACHE_USER}"
    grant_basic_permissions "${WEB_DIR}/${PACKAGE}" "user:${EFF_USER}"
    grant_basic_permissions "${WEB_DIR}/${PACKAGE}/php/test.sh" "user:${EFF_USER}"

    fix_shared_folders_rights "${INSTALL_DIR}/tmp"
    fix_shared_folders_rights "${WEB_DIR}/${PACKAGE}/share"

    exit 0
}

service_preuninst ()
{
    exit 0
}

service_postuninst ()
{
    # Remove the web interface
    log_step "Removing web interface"
    rm -fr "${WEB_DIR}/${PACKAGE}" >>"${INST_LOG}" 2>&1

    exit 0
}

service_save ()
{
    # Revision 8 introduces backward incompatible changes
    if [ `echo ${SYNOPKG_OLD_PKGVER} | sed -r "s/^.*-([0-9]+)$/\1/"` -le 8 ]; then
        sed -i -e "s|http_cacert = .*|http_cacert = /etc/ssl/certs/ca-certificates.crt|g" ${INSTALL_DIR}/var/.rtorrent.rc
    fi

    # Save the configuration file
    mv ${WEB_DIR}/${PACKAGE}/conf/config.php ${TMP_DIR}/ >>"${INST_LOG}" 2>&1
    if [ -f "${WEB_DIR}/${PACKAGE}/.htaccess" ]; then
        mv "${WEB_DIR}/${PACKAGE}/.htaccess" "${TMP_DIR}/" >>"${INST_LOG}" 2>&1
    fi
    cp -pr ${WEB_DIR}/${PACKAGE}/share/ ${TMP_DIR}/ >>"${INST_LOG}" 2>&1
    mv ${INSTALL_DIR}/var/.rtorrent.rc ${TMP_DIR}/ >>"${INST_LOG}" 2>&1
    mv ${INSTALL_DIR}/var/.session ${TMP_DIR}/ >>"${INST_LOG}" 2>&1

    exit 0
}

is_not_defined_external_program()
{
    program=$1
    php -r "require_once('${WEB_DIR}/${PACKAGE}/conf/config.php'); if (isset(\$pathToExternals['${program}']) && !empty(\$pathToExternals['${program}'])) { exit(1); } else { exit(0); }" >>"${INST_LOG}" 2>&1
    return $?
}

define_external_program()
{
    program=$1
    value=$2
    like=$3
    echo "\$pathToExternals['${program}'] = '${value}'; // Something like $like. If empty, will be found in PATH" \
        >> "${WEB_DIR}/${PACKAGE}/conf/config.php"
}

service_restore ()
{
    # Restore the configuration file
    mv -f "${TMP_DIR}/config.php" "${WEB_DIR}/${PACKAGE}/conf/" >>"${INST_LOG}" 2>&1

    if [ -f "${TMP_DIR}/.htaccess" ]; then
        mv -f "${TMP_DIR}/.htaccess" "${WEB_DIR}/${PACKAGE}/" >>"${INST_LOG}" 2>&1
        set_syno_permissions "${WEB_DIR}/${PACKAGE}/.htaccess" "${APACHE_USER}"
    fi
    
    # In previous versions the python entry had nothing defined, 
    # here we define it if, and only if, python3 is actually installed
    if [ -f "${PYTHON_DIR}/bin/python3" ] && `is_not_defined_external_program 'python'`; then
        define_external_program 'python' "${INSTALL_DIR}/env/bin/python3" '/usr/bin/python3'
    fi

    # In previous versions the pgrep entry had nothing defined
    if `is_not_defined_external_program 'pgrep'`; then
        define_external_program 'pgrep' "${INSTALL_DIR}/bin/pgrep" '/usr/bin/pgrep'
    fi

    # In previous versions the sox entry had nothing defined
    if `is_not_defined_external_program 'sox'`; then
        define_external_program 'sox' "${INSTALL_DIR}/bin/sox" '/usr/bin/sox'
    fi

    # In previous versions the mediainfo entry had nothing defined
    if `is_not_defined_external_program 'mediainfo'`; then
        define_external_program 'mediainfo' "${INSTALL_DIR}/bin/mediainfo" '/usr/bin/mediainfo'
    fi

    # In previous versions the stat entry had nothing defined
    if `is_not_defined_external_program 'stat'`; then
        define_external_program 'stat' '/bin/stat' '/usr/bin/stat'
    fi

    if `is_not_defined_external_program 'id'`; then
        define_external_program 'id' '/bin/id' '/usr/bin/id'
    fi

    if `is_not_defined_external_program 'gzip'`; then
        define_external_program 'gzip' '/bin/gzip' '/usr/bin/gzip'
    fi

    if `is_not_defined_external_program 'curl'`; then
        define_external_program 'curl' "${INSTALL_DIR}/bin/curl" '/usr/bin/curl'
    fi

    if `is_not_defined_external_program 'php'`; then
        define_external_program 'php' '/bin/php' '/usr/bin/php'
    fi

    set_syno_permissions "${WEB_DIR}/${PACKAGE}/conf/config.php" "${APACHE_USER}"

    cp -pr ${TMP_DIR}/share/*/ ${WEB_DIR}/${PACKAGE}/share/ >>"${INST_LOG}" 2>&1
    set_syno_permissions "${WEB_DIR}/${PACKAGE}/share/" "${APACHE_USER}"

    mv ${TMP_DIR}/.rtorrent.rc ${INSTALL_DIR}/var/ >>"${INST_LOG}" 2>&1
    
    if [ ! `grep 'http_cacert = ' "${INSTALL_DIR}/var/.rtorrent.rc" | wc -l` -eq 0 ]; then
        # http_cacert command has been moved to network.http.cacert
        sed -i -e 's|http_cacert = \(.*\)|network.http.cacert = \1|g' ${INSTALL_DIR}/var/.rtorrent.rc >>"${INST_LOG}" 2>&1
    fi

    mv ${TMP_DIR}/.session ${INSTALL_DIR}/var/ >>"${INST_LOG}" 2>&1

    # Restore appropriate rights on the var directory
    set_unix_permissions "${INSTALL_DIR}/var/"

    exit 0
}
