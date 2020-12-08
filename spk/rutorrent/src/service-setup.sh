#!/bin/sh

# Package
PACKAGE="rutorrent"
DNAME="ruTorrent"
PACKAGE_NAME="com.synocommunity.packages.${PACKAGE}"

# Others
WEB_DIR="/var/services/web"
PATH="${SYNOPKG_PKGDEST}/bin:${SYNOPKG_PKGDEST}/usr/bin:${PATH}"
APACHE_USER="$([ $(grep buildnumber /etc.defaults/VERSION | cut -d"\"" -f2) -ge 4418 ] && echo -n http || echo -n nobody)"
BUILDNUMBER="$(/bin/get_key_value /etc.defaults/VERSION buildnumber)"

GROUP="sc-download"
GROUP_DESC="SynoCommunity's download related group"
LEGACY_USER="rutorrent"
LEGACY_GROUP="users"

PYTHON_DIR="/usr/local/python3"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"

SVC_BACKGROUND=y
PID_FILE="${SYNOPKG_PKGDEST}/var/rtorrent.pid"
LOG_FILE="${SYNOPKG_PKGDEST}/var/rtorrent.log"
SVC_WRITE_PID=y

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

    return 0
}

fix_shared_folders_rights()
{
    local folder=$1
    echo "Fixing shared folder rights for ${folder}" >> "${INST_LOG}"
    chown -R "${EFF_USER}:${APACHE_USER}" "${folder}" >> "${INST_LOG}" 2>&1
    synoacltool -add "${folder}" "everyone::allow:r-x----------:fd--" >> "${INST_LOG}" 2>&1
    synoacltool -add "${folder}" "user:${EFF_USER}:allow:rwxpdDaARWc--:fd" >> "${INST_LOG}" 2>&1
    synoacltool -add "${folder}" "group:${USER}:allow:rwxpdDaARWc--:fd" >> "${INST_LOG}" 2>&1
    synoacltool -add "${folder}" "user:${APACHE_USER}:allow:rwxp-D------:fd" >> "${INST_LOG}" 2>&1
    synoacltool -add "${folder}" "group:${APACHE_USER}:allow:rwxp-D------:fd--" >> "${INST_LOG}" 2>&1
    find "${folder}" -mindepth 1 -type d -exec synoacltool -enforce-inherit "{}" \; >> ${INST_LOG} 2>&1
}

service_postinst ()
{

    # Install busybox stuff
    ${SYNOPKG_PKGDEST}/bin/busybox --install ${SYNOPKG_PKGDEST}/bin

    syno_user_add_to_legacy_group "${EFF_USER}" "${LEGACY_USER}" "${LEGACY_GROUP}"

    # Install the web interface
    cp -pR ${SYNOPKG_PKGDEST}/share/${PACKAGE} ${WEB_DIR} >>"${INST_LOG}" 2>&1

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
               -e "s|tempDirectory = null;|tempDirectory = '${SYNOPKG_PKGDEST}/tmp/';|g" \
               -e "s|\"python\"\(\\s*\)=>\(\\s*\)'.*'\(\\s*\),\(\\s*\)|\"python\"\1=>\2'${SYNOPKG_PKGDEST}/env/bin/python3'\3,\4|g" \
               -e "s|\"pgrep\"\(\\s*\)=>\(\\s*\)'.*'\(\\s*\),\(\\s*\)|\"pgrep\"\1=>\2'${SYNOPKG_PKGDEST}/bin/pgrep'\3,\4|g" \
               -e "s|\"sox\"\(\\s*\)=>\(\\s*\)'.*'\(\\s*\),\(\\s*\)|\"sox\"\1=>\2'${SYNOPKG_PKGDEST}/bin/sox'\3,\4|g" \
               -e "s|\"mediainfo\"\(\\s*\)=>\(\\s*\)'.*'\(\\s*\),\(\\s*\)|\"mediainfo\"\1=>\2'${SYNOPKG_PKGDEST}/bin/mediainfo'\3,\4|g" \
               -e "s|\"stat\"\(\\s*\)=>\(\\s*\)'.*'\(\\s*\),\(\\s*\)|\"stat\"\1=>\2'/bin/stat'\3,\4|g" \
               -e "s|\"curl\"\(\\s*\)=>\(\\s*\)'.*'\(\\s*\),\(\\s*\)|\"curl\"\1=>\2'${SYNOPKG_PKGDEST}/bin/curl'\3,\4|g" \
               -e "s|\"id\"\(\\s*\)=>\(\\s*\)'.*'\(\\s*\),\(\\s*\)|\"id\"\1=>\2'/bin/id'\3,\4|g" \
               -e "s|\"gzip\"\(\\s*\)=>\(\\s*\)'.*'\(\\s*\),\(\\s*\)|\"gzip\"\1=>\2'/bin/gzip'\3,\4|g" \
               -e "s|\"php\"\(\\s*\)=>\(\\s*\)'.*'\(\\s*\),\(\\s*\)|\"php\"\1=>\2'/bin/php'\3,\4|g" \
               ${WEB_DIR}/${PACKAGE}/conf/config.php >>"${INST_LOG}" 2>&1

        sed -i -e "s|@download_dir@|${wizard_download_dir:=/volume1/downloads}|g" \
               -e "s|@max_memory@|$MAX_MEMORY|g" \
               -e "s|@port_range@|${wizard_port_range:=6881-6999}|g" \
               ${SYNOPKG_PKGDEST}/var/.rtorrent.rc >>"${INST_LOG}" 2>&1

        if [ -d "${wizard_watch_dir}" ]; then
            sed -i -e "s|@watch_dir@|${wizard_watch_dir}|g" ${SYNOPKG_PKGDEST}/var/.rtorrent.rc >>"${INST_LOG}" 2>&1
        else
            sed -i -e "/@watch_dir@/d" ${SYNOPKG_PKGDEST}/var/.rtorrent.rc >>"${INST_LOG}" 2>&1
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
        ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env >> "${INST_LOG}" 2>&1
        # Install the cloudscraper wheels
        ${SYNOPKG_PKGDEST}/env/bin/pip install -U cloudscraper==1.2.48 >> "${INST_LOG}" 2>&1
    fi

    fix_shared_folders_rights "${SYNOPKG_PKGDEST}/tmp"
    fix_shared_folders_rights "${WEB_DIR}/${PACKAGE}/share"

    return 0
}

service_postuninst ()
{
    # Remove the web interface
    log_step "Removing web interface"
    rm -fr "${WEB_DIR}/${PACKAGE}" >>"${INST_LOG}" 2>&1

    return 0
}

service_save ()
{
    # Revision 8 introduces backward incompatible changes
    if [ `echo ${SYNOPKG_OLD_PKGVER} | sed -r "s/^.*-([0-9]+)$/\1/"` -le 8 ]; then
        sed -i -e "s|http_cacert = .*|http_cacert = /etc/ssl/certs/ca-certificates.crt|g" ${SYNOPKG_PKGDEST}/var/.rtorrent.rc
    fi

    # Save the configuration file
    mv ${WEB_DIR}/${PACKAGE}/conf/config.php ${TMP_DIR}/ >>"${INST_LOG}" 2>&1
    if [ -f "${WEB_DIR}/${PACKAGE}/.htaccess" ]; then
        mv "${WEB_DIR}/${PACKAGE}/.htaccess" "${TMP_DIR}/" >>"${INST_LOG}" 2>&1
    fi
    cp -pr ${WEB_DIR}/${PACKAGE}/share/ ${TMP_DIR}/ >>"${INST_LOG}" 2>&1
    mv ${SYNOPKG_PKGDEST}/var/.rtorrent.rc ${TMP_DIR}/ >>"${INST_LOG}" 2>&1
    mv ${SYNOPKG_PKGDEST}/var/.session ${TMP_DIR}/ >>"${INST_LOG}" 2>&1

    return 0
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
        define_external_program 'python' "${SYNOPKG_PKGDEST}/env/bin/python3" '/usr/bin/python3'
    fi

    # In previous versions the pgrep entry had nothing defined
    if `is_not_defined_external_program 'pgrep'`; then
        define_external_program 'pgrep' "${SYNOPKG_PKGDEST}/bin/pgrep" '/usr/bin/pgrep'
    fi

    # In previous versions the sox entry had nothing defined
    if `is_not_defined_external_program 'sox'`; then
        define_external_program 'sox' "${SYNOPKG_PKGDEST}/bin/sox" '/usr/bin/sox'
    fi

    # In previous versions the mediainfo entry had nothing defined
    if `is_not_defined_external_program 'mediainfo'`; then
        define_external_program 'mediainfo' "${SYNOPKG_PKGDEST}/bin/mediainfo" '/usr/bin/mediainfo'
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
        define_external_program 'curl' "${SYNOPKG_PKGDEST}/bin/curl" '/usr/bin/curl'
    fi

    if `is_not_defined_external_program 'php'`; then
        define_external_program 'php' '/bin/php' '/usr/bin/php'
    fi

    set_syno_permissions "${WEB_DIR}/${PACKAGE}/conf/config.php" "${APACHE_USER}"

    cp -pr ${TMP_DIR}/share/*/ ${WEB_DIR}/${PACKAGE}/share/ >>"${INST_LOG}" 2>&1
    set_syno_permissions "${WEB_DIR}/${PACKAGE}/share/" "${APACHE_USER}"

    mv ${TMP_DIR}/.rtorrent.rc ${SYNOPKG_PKGDEST}/var/ >>"${INST_LOG}" 2>&1
    
    if [ ! `grep 'http_cacert = ' "${SYNOPKG_PKGDEST}/var/.rtorrent.rc" | wc -l` -eq 0 ]; then
        # http_cacert command has been moved to network.http.cacert
        sed -i -e 's|http_cacert = \(.*\)|network.http.cacert = \1|g' ${SYNOPKG_PKGDEST}/var/.rtorrent.rc >>"${INST_LOG}" 2>&1
    fi

    mv ${TMP_DIR}/.session ${SYNOPKG_PKGDEST}/var/ >>"${INST_LOG}" 2>&1

    # Restore appropriate rights on the var directory
    set_unix_permissions "${SYNOPKG_PKGDEST}/var/"

    return 0
}
