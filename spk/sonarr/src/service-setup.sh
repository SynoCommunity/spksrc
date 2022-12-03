PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"
MONO_PATH="/var/packages/mono/target/bin"
MONO="${MONO_PATH}/mono"

# Sonarr uses the home directory to store it's ".config"
HOME_DIR="${SYNOPKG_PKGVAR}"
CONFIG_DIR="${SYNOPKG_PKGVAR}/.config"
SONARR_CONFIG_DIR="${CONFIG_DIR}/Sonarr"

# Sonarr v2 -> v3 compatibility:
if [ -f "${SYNOPKG_PKGDEST}/share/NzbDrone/NzbDrone.exe" ]; then
    # v2 installed
    SONARR="${SYNOPKG_PKGDEST}/share/NzbDrone/NzbDrone.exe"
    PID_FILE="${CONFIG_DIR}/NzbDrone/nzbdrone.pid"
else
    # v3 installed
    SONARR="${SYNOPKG_PKGDEST}/share/Sonarr/Sonarr.exe"
    PID_FILE="${SONARR_CONFIG_DIR}/sonarr.pid"
fi

# Some have it stored in the root of package
LEGACY_CONFIG_DIR="${SYNOPKG_PKGDEST}/.config"

# workaround for mono bug with armv5 (https://github.com/mono/mono/issues/12537)
if [ "$SYNOPKG_DSM_ARCH" == "88f6281" ] || [ "$SYNOPKG_DSM_ARCH" == "88f6282" ]; then
    MONO="MONO_ENV_OPTIONS='-O=-aot,-float32' ${MONO}"
fi

# for DSM < 7 only:
GROUP="sc-download"
LEGACY_GROUP="sc-media"

SERVICE_COMMAND="env PATH=${MONO_PATH}:${PATH} HOME=${HOME_DIR} LD_LIBRARY_PATH=${SYNOPKG_PKGDEST}/lib ${MONO} ${SONARR}"
SVC_BACKGROUND=y
SVC_WAIT_TIMEOUT=90

service_postinst ()
{
    mkdir -p "${SONARR_CONFIG_DIR}"
    # Check if config.xml is present in .comfig
    if [ -f "${SONARR_CONFIG_DIR}/config.xml" ]; then
        # Modify config.xml with correct values
        keys=("Branch" "LaunchBrowser" "UpdateAutomatically" "UpdateMechanism")
        values=("main" "False" "True" "BuiltIn")
        for i in "${!keys[@]}"; do
            key="${keys[$i]}"
            value="${values[$i]}"
            if grep -q "<$key>" "${SONARR_CONFIG_DIR}/config.xml"; then
                sed -i "s/<$key>.*<\/$key>/<$key>$value<\/$key>/g" "${SONARR_CONFIG_DIR}/config.xml"
            else
                sed -i "s/\(<\/Config>\)/  <$key>$value<\/$key>\n\1/g" "${SONARR_CONFIG_DIR}/config.xml"
            fi
        done
    else
        # Move new config.xml to .config
        mv "${SYNOPKG_PKGDEST}/app/config.xml" "${SONARR_CONFIG_DIR}/config.xml"
    fi
    
    echo "Set update required"
    # Make Sonarr do an update check on start to avoid possible Sonarr
    # downgrade when synocommunity package is updated
    touch "${SONARR_CONFIG_DIR}/update_required"
    
    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
        set_unix_permissions "${CONFIG_DIR}"
    fi
}

service_preupgrade ()
{
    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -ge 7 ]; then
        # ensure config is in @appdata folder
        if [ -d "${LEGACY_CONFIG_DIR}" ]; then
            if [ "$(realpath "${LEGACY_CONFIG_DIR}")" != "$(realpath "${CONFIG_DIR}")" ]; then
                echo "Move ${LEGACY_CONFIG_DIR} to ${CONFIG_DIR}"
                mv "${LEGACY_CONFIG_DIR}" "${CONFIG_DIR}" 2>&1
            fi
        fi
    fi

    # Is installed Sonarr distribution < v3 (legacy version)?
    CUR_VER=$(${MONO_PATH}/monodis --assembly "${SONARR}" | grep "Version:" | awk -F [:.] '{gsub(/ /,""); print $2}')
    if [ "${CUR_VER}" -lt 3 ]; then
        # replace the Sonarr distribution if legacy version
        touch "${CONFIG_DIR}/LEGACY_DIST" 2>&1
        echo "[REPLACING] Installed Sonarr Binary: ${CUR_VER}"
    else
        # if non-legacy never update Sonarr distribution, use internal updater only
        [ -d "${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup" ] && rm -rf "${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup"
        echo "Backup existing distribution to ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup"
        mkdir -p "${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup" 2>&1
        rsync -aX "${SYNOPKG_PKGDEST}/share" "${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup/" 2>&1
    fi
}

service_postupgrade ()
{
    # restore Sonarr distribution if non-legacy version
    if [ ! -f "${CONFIG_DIR}/LEGACY_DIST" ]; then
        if [ -d "${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup/share" ]; then
            echo "Restore previous distribution from ${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup"
            rm -rf "${SYNOPKG_PKGDEST}/share/Sonarr/bin" 2>&1
            # prevent overwrite of updated package_info
            rsync -aX --exclude=package_info "${SYNOPKG_TEMP_UPGRADE_FOLDER}/backup/share/" "${SYNOPKG_PKGDEST}/share" 2>&1
        fi
    else
        # remove legacy Flag
        rm "${CONFIG_DIR}/LEGACY_DIST"
    fi

    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
        set_unix_permissions "${SYNOPKG_PKGDEST}/share"
        # If backup was created before new-style packages
        # new updates/backups will fail due to permissions (see #3185)
        if [ -d "/tmp/nzbdrone_backup" ] || [ -d "/tmp/nzbdrone_update" ] || [ -d "/tmp/sonarr_backup" ] || [ -d "/tmp/sonarr_update" ]; then
            set_unix_permissions "/tmp/nzbdrone_backup"
            set_unix_permissions "/tmp/nzbdrone_update"
            set_unix_permissions "/tmp/sonarr_backup"
            set_unix_permissions "/tmp/sonarr_update"
        fi
    fi
}
