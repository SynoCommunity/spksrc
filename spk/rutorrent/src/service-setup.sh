# Package
PACKAGE="rutorrent"

# Define python310 binary path
PYTHON_DIR="/var/packages/python310/target/bin"
# Add local bin, virtualenv along with python310 to the default PATH
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${SYNOPKG_PKGDEST}/usr/bin:${PYTHON_DIR}:${PATH}"
# Others
DSM6_WEB_DIR="/var/services/web"
if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -ge 7 ]; then
  WEB_DIR="/var/services/web_packages"
else
  WEB_DIR="${DSM6_WEB_DIR}"
fi

APACHE_USER="$([ $(grep buildnumber /etc.defaults/VERSION | cut -d"\"" -f2) -ge 4418 ] && echo -n http || echo -n nobody)"
APACHE_GROUP=${APACHE_USER}
BUILDNUMBER="$(/bin/get_key_value /etc.defaults/VERSION buildnumber)"

RUTORRENT_WEB_DIR=${WEB_DIR}/${PACKAGE}
# rtorrent configuration file location
RTORRENT_RC=${RUTORRENT_WEB_DIR}/conf/rtorrent.rc

GROUP="sc-download"
GROUP_DESC="SynoCommunity's download related group"
LEGACY_USER="rutorrent"
LEGACY_GROUP="users"


SVC_BACKGROUND=y
PID_FILE="${SYNOPKG_PKGVAR}/rtorrent.pid"
LOG_FILE="${SYNOPKG_PKGVAR}/rtorrent.log"
SVC_WRITE_PID=y

SERVICE_COMMAND="env RUTORRENT_WEB_DIR=${RUTORRENT_WEB_DIR} SYNOPKG_PKGVAR=${SYNOPKG_PKGVAR} SYNOPKG_PKGDEST=${SYNOPKG_PKGDEST} ${SERVICE_COMMAND}"

check_acl()
{
    acl_path=$1
    acl_user=$2
    acl_permissions=$(synoacltool -get-perm "${acl_path}" "${acl_user}" | awk -F'Final permission: ' 'NF > 1  {print $2}' | tr -d '[] ')
    if [ -z "${acl_permissions}" -o "${acl_permissions}" = "-------------" ]; then
        return 1
    else
        synoacltool -get-perm "${acl_path}" "${acl_user}"
        return 0
    fi
}

fix_shared_folders_rights()
{
    local folder=$1
    echo "Fixing shared folder rights for ${folder}"

    # Delete any previous ACL to limit duplicates
    synoacltool -get "${folder}" >/dev/null 2>&1 && synoacltool -del "${folder}"

    # Set default user to sc-rutorrent and group to http
    chown -R "${EFF_USER}:${APACHE_USER}" "${folder}"

    echo "Fixing shared folder access for everyone"
    synoacltool -add "${folder}" "everyone:*:allow:r-x----------:fd--"

    echo "Fixing shared folder access for user:${EFF_USER}"
    synoacltool -add "${folder}" "user:${EFF_USER}:allow:rwxpdDaARWc--:fd"

    echo "Fixing shared folder access for group:${GROUP}"
    synoacltool -add "${folder}" "group:${GROUP}:allow:rwxpdDaARWc--:fd"

    echo "Fixing shared folder access for user:${APACHE_USER}"
    synoacltool -add "${folder}" "user:${APACHE_USER}:allow:rwxp-D------:fd"

    echo "Fixing shared folder access for group:${APACHE_GROUP}"
    synoacltool -add "${folder}" "group:${APACHE_GROUP}:allow:rwxp-D------:fd"

    # Enforce permissions to sub-folders
    echo "find \"${folder}\" -mindepth 1 -type d -exec synoacltool -enforce-inherit {} \\;"
    find "${folder}" -mindepth 1 -type d -exec synoacltool -enforce-inherit "{}" \;
}

service_postinst ()
{
    # Install busybox stuff
    "${SYNOPKG_PKGDEST}/bin/busybox" --install "${SYNOPKG_PKGDEST}/bin"

    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
  
      syno_user_add_to_legacy_group "${EFF_USER}" "${LEGACY_USER}" "${LEGACY_GROUP}"
  
      # Install the web interface
      cp -pR -t "${WEB_DIR}" "${SYNOPKG_PKGDEST}/share/${PACKAGE}"
    fi

    # Allow direct-user access to rtorrent configuration file
    mv "${SYNOPKG_PKGVAR}/rtorrent.rc" "${RTORRENT_RC}"
    ln -s -T -f "${RTORRENT_RC}" "${SYNOPKG_PKGVAR}/.rtorrent.rc"

    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
      # Configure open_basedir
      if [ "${APACHE_USER}" == "nobody" ]; then
          echo -e "<Directory \"${RUTORRENT_WEB_DIR}\">\nphp_admin_value open_basedir none\n</Directory>" > /usr/syno/etc/sites-enabled-user/${PACKAGE}.conf
      else
          if [ -d "/etc/php/conf.d/" ]; then
              echo -e "[PATH=${RUTORRENT_WEB_DIR}]\nopen_basedir = Null" > /etc/php/conf.d/com.synocommunity.packages.${PACKAGE}.ini
          fi
      fi
    fi

    # Configure files
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        TOP_DIR=`echo "${wizard_download_dir}" | cut -d "/" -f 2`
        MAX_MEMORY=`awk '/MemTotal/{memory=$2*1024*0.25; if (memory > 512*1024*1024) memory=512*1024*1024; printf "%0.f", memory}' /proc/meminfo`

        sed -i -e "s|scgi_port = 5000;|scgi_port = ${SERVICE_PORT};|g" \
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
               "${RUTORRENT_WEB_DIR}/conf/config.php"

        sed -i -e "s|@download_dir@|${wizard_download_dir}|g" \
               -e "s|@max_memory@|$MAX_MEMORY|g" \
               -e "s|@service_port@|${SERVICE_PORT}|g" \
               "${RTORRENT_RC}"

        if [ -n "${wizard_watch_dir}" ]; then
            local effective_watch_dir="${wizard_download_dir}${wizard_watch_dir}"
            mkdir -p "${effective_watch_dir}"
            sed -i -e "s|@watch_dir@|${effective_watch_dir}|g" ${RTORRENT_RC}
        else
            sed -i -e "/@watch_dir@/d" ${RTORRENT_RC}
        fi

        if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
          if [ "${wizard_disable_openbasedir}" == "true" ] && [ "${APACHE_USER}" == "http" ]; then
              if [ -f "/etc/php/conf.d/user-settings.ini" ]; then
                  sed -i -e "s|^open_basedir.*|open_basedir = none|g" /etc/php/conf.d/user-settings.ini
                  initctl restart php-fpm > /dev/null 2>&1
              fi
          fi
          # Permissions handling
          if [ "${BUILDNUMBER}" -ge "4418" ]; then
              set_syno_permissions "${wizard_download_volume:=/volume1}/${wizard_download_share:=downloads}" "${GROUP}"
          fi
        fi
    fi

    # Setup a virtual environment with cloudscraper
    # Create a Python virtualenv
    install_python_virtualenv

    # Install the wheels (cloudscraper)
    install_python_wheels
    
    mkdir -p "${SYNOPKG_PKGDEST}/tmp"

    fix_shared_folders_rights "${SYNOPKG_PKGDEST}/tmp"

    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
      # Allow passing through ${WEB_DIR} for sc-rutorrent user (#4295)
      echo "Fixing shared folder access for ${WEB_DIR}"
      check_acl "${WEB_DIR}" "${EFF_USER}"
      [ $? -eq 1 ] \
         && synoacltool -add "${WEB_DIR}" "user:${EFF_USER}:allow:--x----------:---n"
    fi
    
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
      mkdir -p "${RUTORRENT_WEB_DIR}/share"
  
      # Allow read/write/execute over the share web/rutorrent/share directory
      fix_shared_folders_rights "${RUTORRENT_WEB_DIR}/share"

      if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -ge 7 ]; then
        touch "${SYNOPKG_PKGVAR}/.dsm7_migrated"
      fi
    fi

    return 0
}

service_postuninst ()
{
    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
      # Remove the web interface
      log_step "Removing web interface"
      rm -fr "${RUTORRENT_WEB_DIR}"
    fi

    return 0
}

service_save ()
{
    local source_directory="${RUTORRENT_WEB_DIR}"
    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -ge 7 ] && [ ! -f "${SYNOPKG_PKGVAR}/.dsm7_migrated" ]; then
      source_directory="${DSM6_WEB_DIR}/${PACKAGE}"
    fi

    # Revision 8 introduces backward incompatible changes
    if [ `echo "${SYNOPKG_OLD_PKGVER}" | sed -r "s/^.*-([0-9]+)$/\1/"` -le 8 ]; then
        sed -i -e "s|http_cacert = .*|http_cacert = /etc/ssl/certs/ca-certificates.crt|g" ${RTORRENT_RC}
    fi

    # Save the configuration file
    cp -ap -t "${TMP_DIR}" "${source_directory}/conf/config.php"
    if [ -f "${source_directory}/.htaccess" ]; then
        cp -ap -t "${TMP_DIR}" "${source_directory}/.htaccess"
    fi

    # Save session files
    cp -ap -t "${TMP_DIR}" "${SYNOPKG_PKGVAR}/.session"

    # Save rtorrent configuration file (new location)
    if [ -L "${SYNOPKG_PKGVAR}/.rtorrent.rc" -a -f "${RTORRENT_RC}" ]; then
       mv -t "${TMP_DIR}" "${RTORRENT_RC}"
    # Save rtorrent configuration file (old location -> prior to symlink)
    elif [ ! -L "${SYNOPKG_PKGVAR}/.rtorrent.rc" -a -f "${SYNOPKG_PKGVAR}/.rtorrent.rc" ]; then
       mv "${SYNOPKG_PKGVAR}/.rtorrent.rc" "${TMP_DIR}/rtorrent.rc"
    fi

    # Save rutorrent share directory
    cp -ap -t "${TMP_DIR}" "${source_directory}/share"

    # Save plugins directory for any user-added plugins
    cp -ap -t "${TMP_DIR}" "${source_directory}/conf/plugins.ini"
    cp -ap -t "${TMP_DIR}" "${source_directory}/plugins"

    return 0
}

is_not_defined_external_program()
{
    program=$1
    php -r "require_once('${RUTORRENT_WEB_DIR}/conf/config.php'); if (isset(\$pathToExternals['${program}']) && !empty(\$pathToExternals['${program}'])) { exit(1); } else { exit(0); }"
    return $?
}

define_external_program()
{
    program=$1
    value=$2
    like=$3
    echo "\$pathToExternals['${program}'] = '${value}'; // Something like $like. If empty, will be found in PATH" \
        >> "${RUTORRENT_WEB_DIR}/conf/config.php"
}

fix_unix_permissions ()
{
    local file=$1
    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
      set_unix_permissions "${file}"
    fi
}

service_restore ()
{
    echo "Restoring http custom security file ${RUTORRENT_WEB_DIR}/.htaccess"
    if [ -f "${TMP_DIR}/.htaccess" ]; then
        cp -ap -t "${RUTORRENT_WEB_DIR}" "${TMP_DIR}/.htaccess"
        rm "${TMP_DIR}/.htaccess"
    fi

    echo "Restoring rtorrent configuration ${RTORRENT_RC}"
    cp -apf "${TMP_DIR}/rtorrent.rc" "${RTORRENT_RC}"
    rm "${TMP_DIR}/rtorrent.rc"

    # http_cacert command has been moved to network.http.cacert
    if [ ! "$(grep -c 'http_cacert = ' "${RTORRENT_RC}")" -eq 0 ]; then
        sed -i -e 's|http_cacert = \(.*\)|network.http.cacert = \1|g' ${RTORRENT_RC}
    fi

    echo "Restoring rutorrent web shared directory ${RUTORRENT_WEB_DIR}/share"
    cp -ap -t "${RUTORRENT_WEB_DIR}" -f "${TMP_DIR}/share"
    rm -rf "${TMP_DIR}/share"

    echo "Restoring rutorrent custom plugins configuration ${RUTORRENT_WEB_DIR}/conf/plugins.ini"
    cp -ap -t "${RUTORRENT_WEB_DIR}/conf/" -f "${TMP_DIR}/plugins.ini"
    rm "${TMP_DIR}/plugins.ini"

    echo "Restoring rutorrent custom plugins ${RUTORRENT_WEB_DIR}/plugins"
    cp -apu -t "${RUTORRENT_WEB_DIR}" "${TMP_DIR}/plugins"
    fix_unix_permissions "${RUTORRENT_WEB_DIR}/plugins"
    rm -rf "${TMP_DIR}/plugins"

    echo "Restoring rutorrent global configuration ${RUTORRENT_WEB_DIR}/conf/config.php"
    cp -ap -t "${RUTORRENT_WEB_DIR}/conf" -f "${TMP_DIR}/config.php"
    rm -f "${TMP_DIR}/config.php"

    # Force new line at EOF for older rutorrent upgrade when missing (#4295)
    [ ! -z "$(tail -c1 ${RUTORRENT_WEB_DIR}/conf/config.php)" ] && echo >> "${RUTORRENT_WEB_DIR}/conf/config.php"

    # In previous versions the python entry had nothing defined, 
    # here we define it if, and only if, python3 is actually installed
    if [ -f "${PYTHON_DIR}/python3" ] && is_not_defined_external_program 'python'; then
        define_external_program 'python' "${SYNOPKG_PKGDEST}/env/bin/python3" '/usr/bin/python3'
    fi

    # In previous versions the pgrep entry had nothing defined
    if is_not_defined_external_program 'pgrep'; then
        define_external_program 'pgrep' "${SYNOPKG_PKGDEST}/bin/pgrep" '/usr/bin/pgrep'
    fi

    # In previous versions the sox entry had nothing defined
    if is_not_defined_external_program 'sox'; then
        define_external_program 'sox' "${SYNOPKG_PKGDEST}/bin/sox" '/usr/bin/sox'
    fi

    # In previous versions the mediainfo entry had nothing defined
    if is_not_defined_external_program 'mediainfo'; then
        define_external_program 'mediainfo' "${SYNOPKG_PKGDEST}/bin/mediainfo" '/usr/bin/mediainfo'
    fi

    # In previous versions the stat entry had nothing defined
    if is_not_defined_external_program 'stat'; then
        define_external_program 'stat' '/bin/stat' '/usr/bin/stat'
    fi

    if is_not_defined_external_program 'id'; then
        define_external_program 'id' '/bin/id' '/usr/bin/id'
    fi

    if is_not_defined_external_program 'gzip'; then
        define_external_program 'gzip' '/bin/gzip' '/usr/bin/gzip'
    fi

    if is_not_defined_external_program 'curl'; then
        define_external_program 'curl' "${SYNOPKG_PKGDEST}/bin/curl" '/usr/bin/curl'
    fi

    if is_not_defined_external_program 'php'; then
        define_external_program 'php' '/bin/php' '/usr/bin/php'
    fi

    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -ge 7 -a ! -f "${SYNOPKG_PKGVAR}/.dsm7_migrated" ]; then
      touch "${SYNOPKG_PKGVAR}/.dsm7_migrated"
    fi

    return 0
}
