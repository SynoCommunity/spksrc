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
    # Download latest NZBGet
    if [ -n "${wizard_stable_release}" ] && [ "${wizard_stable_release}" = true ]; then
        echo "Download nzbget installer: latest"
        wget --quiet --output-document="${NZBGET_INSTALLER}" "https://nzbget.net/download/nzbget-latest-bin-linux.run"
    fi
    if [ -n "${wizard_testing_release}" ] && [ "${wizard_testing_release}" = true ]; then
        echo "Download nzbget installer: latest-testing"
        wget --quiet --output-document="${NZBGET_INSTALLER}" "https://nzbget.net/download/nzbget-latest-testing-bin-linux.run"
    fi

    # Stop if download failed
    if [ ! -r "${NZBGET_INSTALLER}" ]; then
        echo "Failed to download installer, please check the internet connection of your device."
        exit 1
    fi
    echo "Download completed"

    if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 6 ]; then
        # On DSM5 the lib-dir is not owned by the package-user
        set_unix_permissions "${SYNOPKG_PKGDEST}/bin"

        # Install as nzbget user, for correct permissions
        chmod +x "${NZBGET_INSTALLER}"
        su ${EFF_USER} -s /bin/sh -c "${NZBGET_INSTALLER} --destdir ${SYNOPKG_PKGDEST}/bin"
    else
        chmod +x "${NZBGET_INSTALLER}"
        ${NZBGET_INSTALLER} --destdir ${SYNOPKG_PKGDEST}/bin
    fi

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

    # Create config file if not exists
    if [ ! -e "${CFG_FILE}" ]; then
        echo "create config file"

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
}
