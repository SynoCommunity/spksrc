# Define python312 binary path
PYTHON_DIR="/var/packages/python312/target/bin"
# Add local bin, virtualenv along with python312 to the default PATH
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${SYNOPKG_PKGDEST}/usr/bin:${PYTHON_DIR}:${PATH}"

GROUP="synocommunity"
APACHE_USER="http"
APACHE_GROUP=${APACHE_USER}

RUTORRENT_WEB_DIR="/var/services/web_packages/${SYNOPKG_PKGNAME}"
# rtorrent configuration file location
RTORRENT_RC=${RUTORRENT_WEB_DIR}/conf/rtorrent.rc

# Determine PHP binary path based on DSM version (rutorrent requires DSM >= 7)
if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -eq 7 ] && [ "${SYNOPKG_DSM_VERSION_MINOR}" -lt 2 ]; then
    PHP_BIN="/usr/local/bin/php80"
else
    PHP_BIN="/usr/local/bin/php82"
fi

MEDIAINFO_BIN="/var/packages/mediainfo/target/bin/mediainfo"
# Set HOME for rtorrent to find .rtorrent.rc symlink
HOME="${SYNOPKG_PKGVAR}"
export HOME
export LD_LIBRARY_PATH="${SYNOPKG_PKGDEST}/lib"

SVC_BACKGROUND=y
PID_FILE="${SYNOPKG_PKGVAR}/rtorrent.pid"
LOG_FILE="${SYNOPKG_PKGVAR}/rtorrent.log"
SVC_WRITE_PID=y

SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/rtorrent -n -o import=${RTORRENT_RC}"

fix_shared_folders_rights()
{
    folder=$1
    echo "Fixing shared folder rights for ${folder}"

    # Delete any previous ACL to limit duplicates
    synoacltool -get "${folder}" >/dev/null 2>&1 && synoacltool -del "${folder}"

    # Set default user to sc-rutorrent and group to http
    chown -R "${EFF_USER}:${APACHE_USER}" "${folder}"

    for rule in \
        "everyone:*:allow:r-x----------:fd--" \
        "user:${EFF_USER}:allow:rwxpdDaARWc--:fd" \
        "group:${GROUP}:allow:rwxpdDaARWc--:fd" \
        "user:${APACHE_USER}:allow:rwxp-D------:fd" \
        "group:${APACHE_GROUP}:allow:rwxp-D------:fd"
    do
        synoacltool -add "${folder}" "${rule}"
    done

    # Enforce permissions to sub-folders
    find "${folder}" -mindepth 1 -type d -exec synoacltool -enforce-inherit "{}" \;
}

set_external_program_path()
{
    sep_program=$1
    sep_value=$2
    sep_like=$3
    sep_config_file="${RUTORRENT_WEB_DIR}/conf/config.php"

    [ -f "${sep_config_file}" ] || return 0

    sep_escaped_value=$(printf '%s\n' "${sep_value}" | sed 's/[&#|\\]/\\&/g')

    if grep -q "\"${sep_program}\"" "${sep_config_file}"; then
        sed -i -E "s|\"${sep_program}\"[[:space:]]*=>[[:space:]]*'[^']*'|\"${sep_program}\" => '${sep_escaped_value}'|" "${sep_config_file}"
    else
        sep_indent=$(sed -n 's/^\([[:space:]]*\)"[^"]\+"[[:space:]]*=>.*/\1/p' "${sep_config_file}" | head -n 1)
        [ -n "${sep_indent}" ] || sep_indent="    "

        escaped_value=$(printf "%s" "${sep_value}" | sed "s/'/'\\''/g")
        comment="// Something like ${sep_like}. If empty, will be found in PATH."

        tmp_file=$(mktemp)
        if awk -v indent="${sep_indent}" -v prog="${sep_program}" -v val="${escaped_value}" -v comment="${comment}" '
            BEGIN { inserted = 0; in_array = 0 }
            {
                if ($0 ~ /\$pathToExternals[[:space:]]*=[[:space:]]*array/) {
                    in_array = 1
                }
                if (in_array && !inserted && $0 ~ /^[[:space:]]*\);[[:space:]]*$/) {
                    printf("%s\"%s\" => '\''%s'\'',\t\t%s\n", indent, prog, val, comment)
                    inserted = 1
                }
                print
                if (in_array && $0 ~ /^[[:space:]]*\);[[:space:]]*$/) {
                    in_array = 0
                }
            }
            END {
                exit(inserted ? 0 : 1)
            }
        ' "${sep_config_file}" > "${tmp_file}"; then
            cat "${tmp_file}" > "${sep_config_file}"
            rm -f "${tmp_file}"
            chown "${EFF_USER}:${APACHE_USER}" "${sep_config_file}" 2>/dev/null || true
            chmod 0664 "${sep_config_file}" 2>/dev/null || true
        fi
    fi
}

configure_external_programs()
{
    set_external_program_path 'php' "${PHP_BIN}" '/usr/bin/php'
    set_external_program_path 'python' "${SYNOPKG_PKGDEST}/env/bin/python3" '/usr/bin/python3'
    set_external_program_path 'pgrep' "${SYNOPKG_PKGDEST}/bin/pgrep" '/usr/bin/pgrep'
    set_external_program_path 'sox' "${SYNOPKG_PKGDEST}/bin/sox" '/usr/bin/sox'
    set_external_program_path 'mediainfo' "${MEDIAINFO_BIN}" '/usr/bin/mediainfo'
    set_external_program_path 'stat' '/bin/stat' '/usr/bin/stat'
    set_external_program_path 'curl' "${SYNOPKG_PKGDEST}/bin/curl" '/usr/bin/curl'
    set_external_program_path 'id' '/bin/id' '/usr/bin/id'
    set_external_program_path 'gzip' '/bin/gzip' '/usr/bin/gzip'
    set_external_program_path 'dumptorrent' "${SYNOPKG_PKGDEST}/bin/dumptorrent" "${SYNOPKG_PKGDEST}/bin/dumptorrent"
}

service_postinst()
{
    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        # Allow direct-user access to rtorrent configuration file
        mv "${SYNOPKG_PKGVAR}/rtorrent.rc" "${RTORRENT_RC}"
        ln -s -T -f "${RTORRENT_RC}" "${SYNOPKG_PKGVAR}/.rtorrent.rc"

        # Configure files
        MAX_MEMORY=$(awk '/MemTotal/{memory=$2*1024*0.25; if (memory > 512*1024*1024) memory=512*1024*1024; printf "%0.f", memory}' /proc/meminfo)

        sed -i \
            -e "s|^\([[:space:]]*\)\$scgi_port =.*|\1\$scgi_port = ${SERVICE_PORT};|" \
            -e "s|^\([[:space:]]*\)\$log_file =.*|\1\$log_file = '${SYNOPKG_PKGDEST}/tmp/errors.log';|" \
            -e "s|^\([[:space:]]*\)\$topDirectory =.*|\1\$topDirectory = '${SHARE_PATH}/';|" \
            -e "s|^\([[:space:]]*\)\$tempDirectory =.*|\1\$tempDirectory = '${SYNOPKG_PKGDEST}/tmp/';|" \
            "${RUTORRENT_WEB_DIR}/conf/config.php"

        sed -i -e "s|@download_dir@|${SHARE_PATH}|g" \
            -e "s|@max_memory@|$MAX_MEMORY|g" \
            -e "s|@service_port@|${SERVICE_PORT}|g" \
            "${RTORRENT_RC}"

        if [ -n "${wizard_watch_dir}" ]; then
            cleaned_watch_dir=${wizard_watch_dir#/}
            effective_watch_dir="${SHARE_PATH}/${cleaned_watch_dir}"
            mkdir -p "${effective_watch_dir}"
            sed -i -e "s|@watch_dir@|${effective_watch_dir}|g" ${RTORRENT_RC}
        else
            sed -i -e "/@watch_dir@/d" ${RTORRENT_RC}
        fi

        # Refresh external tool paths (php versioning, mediainfo relocation, etc.)
        configure_external_programs

        mkdir -p "${RUTORRENT_WEB_DIR}/share"
        # Allow read/write/execute over the share web_packages/rutorrent/share directory
        fix_shared_folders_rights "${RUTORRENT_WEB_DIR}/share"
    fi

    mkdir -p "${SYNOPKG_PKGDEST}/tmp"
    # Allow read/write/execute over the share packages/rutorrent/target/tmp directory
    fix_shared_folders_rights "${SYNOPKG_PKGDEST}/tmp"

    # Setup a virtual environment with cloudscraper
    # Create a Python virtualenv
    install_python_virtualenv

    # Install the wheels (cloudscraper)
    install_python_wheels

    return 0
}

service_postupgrade ()
{
    # Check for and remove extra rtorrent configuration file
    if [ -L "${SYNOPKG_PKGVAR}/.rtorrent.rc" ]; then
        if [ -f "${SYNOPKG_PKGVAR}/rtorrent.rc" ]; then
            rm "${SYNOPKG_PKGVAR}/rtorrent.rc"
        fi
    elif [ -f "${RTORRENT_RC}" ]; then
        ln -s -T -f "${RTORRENT_RC}" "${SYNOPKG_PKGVAR}/.rtorrent.rc"
    fi
    
    return 0
}

service_save ()
{
    ruTorrentConfigFile="${RUTORRENT_WEB_DIR}/conf/config.php"

    # Save the configuration file
    cp -ap -t "${SYNOPKG_TEMP_UPGRADE_FOLDER}" "${ruTorrentConfigFile}"
    if [ -f "${RUTORRENT_WEB_DIR}/.htaccess" ]; then
        cp -ap -t "${SYNOPKG_TEMP_UPGRADE_FOLDER}" "${RUTORRENT_WEB_DIR}/.htaccess"
    fi

    # Save session files
    cp -ap -t "${SYNOPKG_TEMP_UPGRADE_FOLDER}" "${SYNOPKG_PKGVAR}/.session"

    # Save rtorrent configuration file (new location)
    if [ -L "${SYNOPKG_PKGVAR}/.rtorrent.rc" ] && [ -f "${RTORRENT_RC}" ]; then
        mv -t "${SYNOPKG_TEMP_UPGRADE_FOLDER}" "${RTORRENT_RC}"
    fi

    # Save rutorrent share directory
    cp -ap -t "${SYNOPKG_TEMP_UPGRADE_FOLDER}" "${RUTORRENT_WEB_DIR}/share"

    # Save plugins directory for any user-added plugins
    cp -ap -t "${SYNOPKG_TEMP_UPGRADE_FOLDER}" "${RUTORRENT_WEB_DIR}/conf/plugins.ini"
    cp -ap -t "${SYNOPKG_TEMP_UPGRADE_FOLDER}" "${RUTORRENT_WEB_DIR}/plugins"

    return 0
}

service_restore ()
{
    echo "Restoring http custom security file ${RUTORRENT_WEB_DIR}/.htaccess"
    if [ -f "${SYNOPKG_TEMP_UPGRADE_FOLDER}/.htaccess" ]; then
        cp -ap -t "${RUTORRENT_WEB_DIR}" "${SYNOPKG_TEMP_UPGRADE_FOLDER}/.htaccess"
        rm "${SYNOPKG_TEMP_UPGRADE_FOLDER}/.htaccess"
    fi

    echo "Restoring rtorrent configuration ${RTORRENT_RC}"
    cp -apf "${SYNOPKG_TEMP_UPGRADE_FOLDER}/rtorrent.rc" "${RTORRENT_RC}"
    rm "${SYNOPKG_TEMP_UPGRADE_FOLDER}/rtorrent.rc"

    # Upgrade migrations for rtorrent.rc: drop legacy PHP 7.4 execute hooks,
    # and ensure daemon mode is enabled (required for running without screen)
    sed -i -e "/\/var\/packages\/PHP7\.4\/target\/usr\/local\/bin\/php74/d" "${RTORRENT_RC}"
    if ! grep -q "^system\.daemon\.set" "${RTORRENT_RC}"; then
        sed -i '1i # Run in daemon mode (no ncurses UI)\nsystem.daemon.set = true\n' "${RTORRENT_RC}"
    fi

    echo "Restoring rutorrent web shared directory ${RUTORRENT_WEB_DIR}/share"
    cp -ap -t "${RUTORRENT_WEB_DIR}" -f "${SYNOPKG_TEMP_UPGRADE_FOLDER}/share"
    rm -rf "${SYNOPKG_TEMP_UPGRADE_FOLDER}/share"

    echo "Restoring rutorrent custom plugins configuration ${RUTORRENT_WEB_DIR}/conf/plugins.ini"
    cp -ap -t "${RUTORRENT_WEB_DIR}/conf/" -f "${SYNOPKG_TEMP_UPGRADE_FOLDER}/plugins.ini"
    rm "${SYNOPKG_TEMP_UPGRADE_FOLDER}/plugins.ini"

    echo "Restoring rutorrent custom plugins ${RUTORRENT_WEB_DIR}/plugins"
    for src in "${SYNOPKG_TEMP_UPGRADE_FOLDER}/plugins"/*; do
        plugin=$(basename "$src")
        dest="${RUTORRENT_WEB_DIR}/plugins/${plugin}"
        if [ ! -e "$dest" ]; then
            cp -ap "$src" "${RUTORRENT_WEB_DIR}/plugins/"
        fi
    done
    echo "Restoring plugin configurations"
    cp -ap -t "${RUTORRENT_WEB_DIR}/plugins/dump" -f "${SYNOPKG_TEMP_UPGRADE_FOLDER}/plugins/dump/conf.php"
    rm -rf "${SYNOPKG_TEMP_UPGRADE_FOLDER}/plugins"

    echo "Restoring rutorrent global configuration ${RUTORRENT_WEB_DIR}/conf/config.php"
    cp -ap -t "${RUTORRENT_WEB_DIR}/conf" -f "${SYNOPKG_TEMP_UPGRADE_FOLDER}/config.php"
    rm -f "${SYNOPKG_TEMP_UPGRADE_FOLDER}/config.php"

    # Refresh external tool paths (php versioning, mediainfo relocation, etc.)
    configure_external_programs

    return 0
}
