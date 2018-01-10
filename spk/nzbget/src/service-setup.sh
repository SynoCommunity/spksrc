PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"
NZBGET="${SYNOPKG_PKGDEST}/bin/nzbget"
CFG_FILE="${SYNOPKG_PKGDEST}/var/nzbget.conf"
TEMPLATE_CFG_FILE="${SYNOPKG_PKGDEST}/share/nzbget/nzbget.conf"
UPGRADE_CFG_FILE="${TMP_DIR}/nzbget.conf"
WEBDIR="${SYNOPKG_PKGDEST}/bin/webui"

GROUP="sc-download"

# Force-overwrite the PID-file and WebDir setting
# These could change depending on previous package settings
SERVICE_COMMAND="${NZBGET} -c ${CFG_FILE} -o WebDir=${WEBDIR} -o LockFile=${PID_FILE} -D"

# Needed to force correct permissions, during update
# Extract the right paths from config file
if [ -r "${UPGRADE_CFG_FILE}" ]; then
    DOWNLOAD_FOLDER=`grep -Po '(?<=MainDir=).*' ${UPGRADE_CFG_FILE}`
    if [ -n "$(dirname "${DOWNLOAD_FOLDER}")" ]; then
        SHARE_PATH=$(dirname "${DOWNLOAD_FOLDER}")
    fi
fi

service_postinst ()
{
    # Download latest NZBGet
    if [ -n "${wizard_stable_release}" ] && [ "${wizard_stable_release}" = true ]; then
        wget -O "${SYNOPKG_PKGDEST}/nzbget.run" "https://nzbget.net/download/nzbget-latest-bin-linux.run" >> ${INST_LOG} 2>&1
    fi
    if [ -n "${wizard_testing_release}" ] && [ "${wizard_testing_release}" = true ]; then
        wget -O "${SYNOPKG_PKGDEST}/nzbget.run" "https://nzbget.net/download/nzbget-latest-testing-bin-linux.run" >> ${INST_LOG} 2>&1
    fi

    # Stop if download failed
    if [ ! -r "${SYNOPKG_PKGDEST}/nzbget.run" ]; then
        echo "Failed to download installer, please check the internet connection of your device." >> ${SYNOPKG_TEMP_LOGFILE}
        exit 1
    fi

    # Install as nzbget user, for correct permissions
    sudo -u ${EFF_USER} sh ${SYNOPKG_PKGDEST}/nzbget.run --destdir ${SYNOPKG_PKGDEST}/bin >> ${INST_LOG} 2>&1

    # Make sure installation worked
    if [ ! -r "${NZBGET}" ]; then
        echo "The installer failed to install NZBGet. Please report the log below to SynoCommunity:" >> ${SYNOPKG_TEMP_LOGFILE}
        echo "${INST_LOG}" >> ${SYNOPKG_TEMP_LOGFILE}
        exit 1
    fi

    # Copy the new template config file created by installer
    cp -f ${SYNOPKG_PKGDEST}/bin/nzbget.conf ${TEMPLATE_CFG_FILE}

    # Rempove installer
    rm -f ${SYNOPKG_PKGDEST}/nzbget.run

    # Correct options from wizard
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        # Use whatever the installer found best
        # It does optimizations based on the current system
        cp -f ${TEMPLATE_CFG_FILE} ${CFG_FILE}

        # Edit the configuration according to the wizard
        sed -i -e "s|MainDir=.*$|MainDir=${wizard_download_dir:=/volume1/downloads}|g" \
               -e "s/ControlUsername=.*$/ControlUsername=${wizard_control_username:=nzbget}/g" \
               -e "s/ControlPassword=.*$/ControlPassword=${wizard_control_password:=nzbget}/g" \
               ${CFG_FILE}

        # Update to match our paths
        sed -i -e "s|ScriptDir=.*$|ScriptDir=${SYNOPKG_PKGDEST}/share/nzbget/scripts|g" \
               -e "s|LogFile=.*$|LogFile=${SYNOPKG_PKGDEST}/var/nzbget.log|g" \
               -e "s|ConfigTemplate=.*$|ConfigTemplate=${TEMPLATE_CFG_FILE}|g" \
               ${CFG_FILE}
    fi

    # Have to make sure our download dirs have right permissions
    if [ -n "${DOWNLOAD_FOLDER}" ] && [ -d "${DOWNLOAD_FOLDER}" ]; then
        set_syno_permissions "${DOWNLOAD_FOLDER}" "${GROUP}"
    fi

    # Discard legacy obsolete busybox user account
    BIN=${SYNOPKG_PKGDEST}/bin
    $BIN/busybox --install $BIN >> ${INST_LOG}
    $BIN/delgroup "${USER}" "users" >> ${INST_LOG}
    $BIN/deluser "${USER}" >> ${INST_LOG}
}
