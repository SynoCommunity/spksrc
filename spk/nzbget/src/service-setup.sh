
PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"
NZBGET="${SYNOPKG_PKGDEST}/bin/nzbget"
CFG_FILE="${SYNOPKG_PKGVAR}/nzbget.conf"
TEMPLATE_CFG_FILE="${SYNOPKG_PKGDEST}/share/nzbget/nzbget.conf"
WEBDIR="${SYNOPKG_PKGDEST}/bin/webui"
NZBGET_INSTALLER="${SYNOPKG_PKGVAR}/nzbget.run"
GROUP="sc-download"

# Force-overwrite the PID-file and WebDir setting
# These could change depending on previous package settings
SERVICE_COMMAND="${NZBGET} -c ${CFG_FILE} -o WebDir=${WEBDIR} -o LockFile=${PID_FILE} -D"

service_postinst ()
{
    # Download current NZBGet (stable or testing)
    if [ -n "${wizard_stable_release}" ] && [ "${wizard_stable_release}" = true ]; then
        echo "Download nzbget installer: latest"
        wget --quiet --output-document="${NZBGET_INSTALLER}" "https://nzbget.com/download/nzbget-latest-bin-linux.run"
    fi
    if [ -n "${wizard_testing_release}" ] && [ "${wizard_testing_release}" = true ]; then
        echo "Download nzbget installer: latest-testing"
        wget --quiet --output-document="${NZBGET_INSTALLER}" "https://nzbget.com/download/nzbget-latest-testing-bin-linux.run"
    fi

    # Abort if download failed
    if [ ! -r "${NZBGET_INSTALLER}" ]; then
        echo "Failed to download installer, please check the internet connection of your device."
        exit 1
    fi
    echo "Download completed"

    chmod +x "${NZBGET_INSTALLER}"
    ${NZBGET_INSTALLER} --destdir ${SYNOPKG_PKGDEST}/bin

    if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ]; then
        # On DSM 5 and 6 the nzbget archive is extracted with the internal build owner (id 1001).
        # Overwrite with the package owner
        set_unix_permissions "${SYNOPKG_PKGDEST}/bin"
    fi

    # Make sure installation worked
    if [ ! -r "${NZBGET}" ]; then
        echo "The installer failed to install NZBGet. Please report the log below to SynoCommunity:"
        echo "${INST_LOG}"
        exit 1
    fi

    # Make a copy of the config file created by the current installer
    cp -f ${SYNOPKG_PKGDEST}/bin/nzbget.conf ${TEMPLATE_CFG_FILE}

    # Remove installer
    rm -f "${NZBGET_INSTALLER}"

    # Create the config file on demand
    if [ ! -e "${CFG_FILE}" ]; then
        echo "Create initial config file"

        # Use whatever the installer found best
        # It does optimizations based on the current system
        cp -f ${TEMPLATE_CFG_FILE} ${CFG_FILE}

        # Edit the configuration according to the wizard
        sed -e "s|MainDir=.*$|MainDir=${wizard_download_volume}/${wizard_download_folder}|g" \
            -e "s/ControlUsername=.*$/ControlUsername=${wizard_control_username:=nzbget}/g" \
            -e "s/ControlPassword=.*$/ControlPassword=${wizard_control_password:=nzbget}/g" \
            -i ${CFG_FILE}

        # Update to match our paths
        sed -e "s|ScriptDir=.*$|ScriptDir=${SYNOPKG_PKGDEST}/share/nzbget/scripts|g" \
            -e "s|LogFile=.*$|LogFile=${SYNOPKG_PKGVAR}/nzbget.log|g" \
            -e "s|ConfigTemplate=.*$|ConfigTemplate=${TEMPLATE_CFG_FILE}|g" \
            -i ${CFG_FILE}
    fi
}
