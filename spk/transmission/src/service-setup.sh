# Add python to path
# This gives tranmission the power to execute python scripts on completion (like TorrentToMedia).
if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -ge 7 ]; then
    # use system python for DSM7
    PYTHON_BIN_PATHS=""
else
    GROUP="sc-download"
    PYTHON_BIN_PATHS="/var/packages/python310/target/bin:/var/packages/python38/target/bin:/var/packages/python3/target/bin:"
fi

PATH="${SYNOPKG_PKGDEST}/bin:${PYTHON_BIN_PATHS}${PATH}"
CFG_FILE="${SYNOPKG_PKGVAR}/settings.json"
TRANSMISSION="${SYNOPKG_PKGDEST}/bin/transmission-daemon"

SERVICE_COMMAND="${TRANSMISSION} -g ${SYNOPKG_PKGVAR} -x ${PID_FILE} -e ${LOG_FILE}"

service_postinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" = "INSTALL" ]; then
        # Capture wizard variable
        TXN_DNLOAD=${wizard_download_dir:=volume1/downloads}
        # Check that the path exists, if not use path in package shares
        if [ ! -d "${TXN_DNLOAD}" ]; then
            TXN_DNLOAD=$(realpath "/var/packages/${SYNOPKG_PKGNAME}/shares/${wizard_download_share}")
        fi
        TXN_FUNCTS=("complete" "incomplete" "watch")
        TXN_FOLDRS=("complete" "incomplete" "watch-transmission")
        TXN_PATHS=()

        # Create the managed folders
        for item in "${TXN_FOLDRS[@]}"; do
            folder="$TXN_DNLOAD/$item"
            if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -ge 7 ]; then
                mkdir -p "$folder"
            else
                /bin/su "${EFF_USER}" -s /bin/sh -c "mkdir -p $folder"
                set_syno_permissions "$folder" "${GROUP}"
            fi
            TXN_PATHS+=("$folder")
        done

        # Edit the configuration according to the wizard
        sed -e "s|@username@|${wizard_username:=admin}|g" \
            -e "s|@password@|${wizard_password:=admin}|g" \
            -i "${CFG_FILE}"
        i=0
        while [ $i -lt ${#TXN_FUNCTS[@]} ]; do
            if [ -d "${TXN_PATHS[$i]}" ]; then
                if [ "${TXN_FUNCTS[$i]}" = "complete" ]; then
                    sed -e "s|@download_dir@|${TXN_PATHS[$i]}|g" -i "${CFG_FILE}"
                else
                    sed -e "s|@${TXN_FUNCTS[$i]}_dir_enabled@|true|g" \
                        -e "s|@${TXN_FUNCTS[$i]}_dir@|${TXN_PATHS[$i]}|g" \
                        -i "${CFG_FILE}"
                fi
            else
                if [ "${TXN_FUNCTS[$i]}" = "complete" ]; then
                    sed -e "s|@download_dir@|${TXN_DNLOAD}|g" -i "${CFG_FILE}"
                else
                    sed -e "s|@${TXN_FUNCTS[$i]}_dir_enabled@|false|g" \
                        -e "/@${TXN_FUNCTS[$i]}_dir@/d" \
                        -i "${CFG_FILE}"
                fi
            fi
            i=$((i+1))
        done
    fi
}
