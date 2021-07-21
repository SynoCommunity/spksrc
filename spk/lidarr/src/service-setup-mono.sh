PATH="${SYNOPKG_PKGDEST}/bin:/var/packages/chromaprint/target/bin/:${PATH}"
MONO_PATH="/var/packages/mono/target/bin"
MONO="${MONO_PATH}/mono"

# Check versions during upgrade
LIDARR="${SYNOPKG_PKGDEST}/share/Lidarr/Lidarr.exe"
SPK_LIDARR="${SYNOPKG_PKGINST_TEMP_DIR}/share/Lidarr/Lidarr.exe"

# Lidarr uses custom Config and PID directories
HOME_DIR="${SYNOPKG_PKGVAR}"
CONFIG_DIR="${SYNOPKG_PKGVAR}/.config"
PID_FILE="${CONFIG_DIR}/Lidarr/lidarr.pid"

# Some have it stored in the root of package
LEGACY_CONFIG_DIR="${SYNOPKG_PKGDEST}/.config"

# workaround for mono bug with armv5 (https://github.com/mono/mono/issues/12537)
if [ "$SYNOPKG_DSM_ARCH" == "88f6281" -o "$SYNOPKG_DSM_ARCH" == "88f6282" ]; then
    MONO="MONO_ENV_OPTIONS='-O=-aot,-float32' ${MONO_PATH}/mono"
fi

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
    echo "Installed Lidarr Binary: ${CUR_VER}"
    SPK_VER=$(${MONO_PATH}/monodis --assembly ${SPK_LIDARR} | grep "Version:" | awk '{print $2}')
    echo "Requested Lidarr Binary: ${SPK_VER}"
    if [ "${CUR_VER//.}" -ge "${SPK_VER//.}" ]; then
        echo 'KEEP_CUR="yes"' > ${CONFIG_DIR}/KEEP_VAR
        echo "[KEEPING] Installed Lidarr Binary - Upgrading Package Only"
        mv ${SYNOPKG_PKGDEST}/share ${INST_VAR}
    else
        echo 'KEEP_CUR="no"' > ${CONFIG_DIR}/KEEP_VAR
        echo "[REPLACING] Installed Lidarr Binary"
    fi
}

service_postupgrade ()
{
    # Restore Current Lidarr Binary if Current Ver. >= SPK Ver.
    . ${CONFIG_DIR}/KEEP_VAR
    if [ "$KEEP_CUR" == "yes" ]; then
        echo "Restoring Lidarr version from before upgrade"
        rm -fr ${SYNOPKG_PKGDEST}/share
        mv ${INST_VAR}/share ${SYNOPKG_PKGDEST}/
        set_unix_permissions "${SYNOPKG_PKGDEST}/share"
    fi
    set_unix_permissions "${CONFIG_DIR}"

    # Remove upgrade Flag
    rm ${CONFIG_DIR}/KEEP_VAR
}
