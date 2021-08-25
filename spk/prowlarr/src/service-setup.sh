
# Prowlarr service setup

PROWLARR="${SYNOPKG_PKGDEST}/share/Prowlarr/bin/Prowlarr"

# Prowlarr uses custom Config and PID directories
HOME_DIR="${SYNOPKG_PKGVAR}"
CONFIG_DIR="${SYNOPKG_PKGVAR}/.config"
PID_FILE="${CONFIG_DIR}/Prowlarr/prowlarr.pid"

# Some have it stored in the root of package
LEGACY_CONFIG_DIR="${SYNOPKG_PKGDEST}/.config"

SERVICE_COMMAND="env HOME=${HOME_DIR} LD_LIBRARY_PATH=${SYNOPKG_PKGDEST}/lib ${PROWLARR}"
SVC_BACKGROUND=y

service_postinst ()
{
    # Move config.xml to .config
    mkdir -p ${CONFIG_DIR}/Prowlarr
    mv ${SYNOPKG_PKGDEST}/app/config.xml ${CONFIG_DIR}/Prowlarr/config.xml
    
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        set_unix_permissions "${CONFIG_DIR}"
    fi
}

service_preupgrade ()
{
}

service_postupgrade ()
{
    # Make Prowlarr do an update check on start to avoid possible Prowlarr
    # downgrade when synocommunity package is updated
    touch ${CONFIG_DIR}/Prowlarr/update_required

    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        set_unix_permissions "${CONFIG_DIR}"
    fi
    
    UPDATE_FROM_VERSION=${SYNOPKG_OLD_PKGVER%-*}
    UPDATE_FROM_REV=${SYNOPKG_OLD_PKGVER##*-}
    if [ ${UPDATE_FROM_REV} -lt 6 ]; then
        # If backup was created before new-style packages
        # new updates/backups will fail due to permissions (see #3185)
        # fixed in #3190, i.e. radarr v20180303-6
        set_unix_permissions "/tmp/prowlarr_backup"
        set_unix_permissions "/tmp/prowlarr_update"
    fi
}
