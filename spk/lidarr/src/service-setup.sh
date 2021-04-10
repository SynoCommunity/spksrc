LIDARR="${SYNOPKG_PKGDEST}/share/Lidarr/bin/Lidarr"

# Lidarr uses custom Config and PID directories
HOME_DIR="${SYNOPKG_PKGVAR}"
CONFIG_DIR="${SYNOPKG_PKGVAR}/.config"
PID_FILE="${CONFIG_DIR}/Lidarr/lidarr.pid"

# Some have it stored in the root of package
LEGACY_CONFIG_DIR="${SYNOPKG_PKGDEST}/.config"

GROUP="sc-download"

SERVICE_COMMAND="env HOME=${HOME_DIR} LD_LIBRARY_PATH=${SYNOPKG_PKGDEST}/lib ${LIDARR}"
SVC_BACKGROUND=y

service_postinst ()
{
    # Move config.xml to .config
    mkdir -p ${CONFIG_DIR}/Lidarr
    mv ${SYNOPKG_PKGDEST}/app/config.xml ${CONFIG_DIR}/Lidarr/config.xml
    set_unix_permissions "${CONFIG_DIR}"
}

service_preupgrade ()
{
    # We have to account for legacy folder in the root
    # It should go, after the upgrade, into /var/.config/
    # The /var/ folder gets automatically copied by service-installer after this
    if [ -d "${LEGACY_CONFIG_DIR}" ]; then
        echo "Moving ${LEGACY_CONFIG_DIR} to ${SYNOPKG_PKGVAR}"
        mv ${LEGACY_CONFIG_DIR} ${SYNOPKG_PKGVAR}
    fi

    if [ ! -d "${CONFIG_DIR}" ]; then
        # Create, in case it's missing for some reason
        mkdir -p ${CONFIG_DIR}
    fi

}

service_postupgrade ()
{
    # Make Lidarr do an update check on start to avoid possible Lidarr
    # downgrade when synocommunity package is updated
    touch ${CONFIG_DIR}/Lidarr/update_required

    set_unix_permissions "${CONFIG_DIR}"
}
