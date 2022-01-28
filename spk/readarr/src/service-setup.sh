
# Readarr service setup

READARR="${SYNOPKG_PKGDEST}/share/Readarr/bin/Readarr"

# Readarr uses custom Config and PID directories
HOME_DIR="${SYNOPKG_PKGVAR}"
CONFIG_DIR="${SYNOPKG_PKGVAR}/.config"

SERVICE_COMMAND="env HOME=${HOME_DIR} LD_LIBRARY_PATH=${SYNOPKG_PKGDEST}/lib ${READARR}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

service_postinst ()
{
    # Move config.xml to .config
    mkdir -p ${CONFIG_DIR}/Readarr
    mv ${SYNOPKG_PKGDEST}/app/config.xml ${CONFIG_DIR}/Readarr/config.xml
    
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        set_unix_permissions "${CONFIG_DIR}"
    fi
}

service_postupgrade ()
{
    # Make Readarr do an update check on start to avoid possible Readarr
    # downgrade when synocommunity package is updated
    touch ${CONFIG_DIR}/Readarr/update_required

    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        set_unix_permissions "${CONFIG_DIR}"
    fi
}
