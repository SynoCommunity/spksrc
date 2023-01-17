PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"
MONO_PATH="/usr/local/mono/bin"
MONO="${MONO_PATH}/mono"

# Check versions during upgrade
LIDARR="${SYNOPKG_PKGDEST}/share/Lidarr/Lidarr.exe"
SPK_LIDARR="${SYNOPKG_PKGINST_TEMP_DIR}/share/Lidarr/Lidarr.exe"

# Lidarr uses custom Config and PID directories
HOME_DIR="${SYNOPKG_PKGDEST}/var"
CONFIG_DIR="${SYNOPKG_PKGDEST}/var/.config"
PID_FILE="${CONFIG_DIR}/Lidarr/lidarr.pid"

# Some have it stored in the root of package
LEGACY_CONFIG_DIR="${SYNOPKG_PKGDEST}/.config"

GROUP="sc-download"

SERVICE_COMMAND="env PATH=${MONO_PATH}:${PATH} HOME=${HOME_DIR} LD_LIBRARY_PATH=${SYNOPKG_PKGDEST}/lib ${MONO} ${LIDARR}"
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
    # Is Installed Lidarr Binary Ver. >= SPK Lidarr Binary Ver.?
    CUR_VER=$(${MONO_PATH}/monodis --assembly ${LIDARR} | grep "Version:" | awk '{print $2}')
    echo "Installed Lidarr Binary: ${CUR_VER}" >> ${INST_LOG}
    SPK_VER=$(${MONO_PATH}/monodis --assembly ${SPK_LIDARR} | grep "Version:" | awk '{print $2}')
    echo "Requested Lidarr Binary: ${SPK_VER}" >> ${INST_LOG}
    if [ "${CUR_VER//.}" -ge "${SPK_VER//.}" ]; then
        echo 'KEEP_CUR="yes"' > ${CONFIG_DIR}/KEEP_VAR
        echo "[KEEPING] Installed Lidarr Binary - Upgrading Package Only" >> ${INST_LOG}
        mv ${SYNOPKG_PKGDEST}/share ${INST_VAR}
    else
        echo 'KEEP_CUR="no"' > ${CONFIG_DIR}/KEEP_VAR
        echo "[REPLACING] Installed Lidarr Binary" >> ${INST_LOG}
    fi
}

service_postupgrade ()
{
    # Restore Current Lidarr Binary If Current Ver. >= SPK Ver.
    . ${CONFIG_DIR}/KEEP_VAR
    if [ "$KEEP_CUR" == "yes" ]; then
        echo "Restoring Lidarr version from before upgrade" >> ${INST_LOG}
        rm -fr ${SYNOPKG_PKGDEST}/share >> $INST_LOG 2>&1
        mv ${INST_VAR}/share ${SYNOPKG_PKGDEST}/ >> $INST_LOG 2>&1
        set_unix_permissions "${SYNOPKG_PKGDEST}/share"
    fi
    set_unix_permissions "${CONFIG_DIR}"

    # Remove upgrade Flag
    rm ${CONFIG_DIR}/KEEP_VAR
}
