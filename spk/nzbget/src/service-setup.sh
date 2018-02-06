PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"
NZBGET="${SYNOPKG_PKGDEST}/bin/nzbget"
CFG_FILE="${SYNOPKG_PKGDEST}/var/nzbget.conf"
TEMPLATE_CFG_FILE="${SYNOPKG_PKGDEST}/share/nzbget/nzbget.conf"
WEBDIR="${SYNOPKG_PKGDEST}/bin/webui"
NZBGET_INSTALLER="${SYNOPKG_PKGDEST}/var/nzbget.run"
GROUP="sc-download"

# Force-overwrite the PID-file and WebDir setting
# These could change depending on previous package settings
SERVICE_COMMAND="${NZBGET} -c ${CFG_FILE} -o WebDir=${WEBDIR} -o LockFile=${PID_FILE} -D"

service_postinst ()
{
    # Download latest NZBGet
    if [ -n "${wizard_stable_release}" ] && [ "${wizard_stable_release}" = true ]; then
        wget -O "${NZBGET_INSTALLER}" "https://nzbget.net/download/nzbget-latest-bin-linux.run" >> ${INST_LOG} 2>&1
    fi
    if [ -n "${wizard_testing_release}" ] && [ "${wizard_testing_release}" = true ]; then
        wget -O "${NZBGET_INSTALLER}" "https://nzbget.net/download/nzbget-latest-testing-bin-linux.run" >> ${INST_LOG} 2>&1
    fi

    # Stop if download failed
    if [ ! -r "${NZBGET_INSTALLER}" ]; then
        echo "Failed to download installer, please check the internet connection of your device."
        exit 1
    fi

    # On DSM5 the lib-dir is not owned by the package-user
    set_unix_permissions "${SYNOPKG_PKGDEST}/bin"

    # Install as nzbget user, for correct permissions
    chmod +x "${NZBGET_INSTALLER}"
    su ${EFF_USER} -s /bin/sh -c "${NZBGET_INSTALLER} --destdir ${SYNOPKG_PKGDEST}/bin" >> ${INST_LOG} 2>&1

    # Make sure installation worked
    if [ ! -r "${NZBGET}" ]; then
        echo "The installer failed to install NZBGet. Please report the log below to SynoCommunity:"
        echo "${INST_LOG}"
        exit 1
    fi

    # Copy the new template config file created by installer
    cp -f ${SYNOPKG_PKGDEST}/bin/nzbget.conf ${TEMPLATE_CFG_FILE}

    # Remove installer
    rm -f "${NZBGET_INSTALLER}"

    # Correct options from wizard
    if [ ! -e "${CFG_FILE}" ]; then
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

    # Discard legacy obsolete busybox user account
    BIN=${SYNOPKG_PKGDEST}/bin
    $BIN/busybox --install $BIN >> ${INST_LOG}
    $BIN/delgroup "${USER}" "users" >> ${INST_LOG}
    $BIN/deluser "${USER}" >> ${INST_LOG}
}

service_postupgrade ()
{
    # Needed to force correct permissions, during update
    # Extract the right paths from config file
    if [ -r "${CFG_FILE}" ]; then
        MAIN_DIR=`sed -n 's/^MainDir[ ]*=[ ]*//p' ${CFG_FILE}`
        if [ -n "${MAIN_DIR}" ] && [ -d "${MAIN_DIR}" ]; then
            set_syno_permissions "${MAIN_DIR}" "${GROUP}"
        fi
    fi
}