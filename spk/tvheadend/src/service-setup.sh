# Package specific behaviors
# Sourced script by generic installer and start-stop-status scripts

# Add ffmpeg and ifself to path
PYTHON_DIR="/var/packages/python38/target"
PYTHONENV="${SYNOPKG_PKGDEST}/env"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
WHEELHOUSE=${SYNOPKG_PKGDEST}/share/wheelhouse
FFMPEG_DIR="/var/packages/ffmpeg/target"
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${FFMPEG_DIR}/bin:${PYTHON_DIR}/bin:${PATH}"

# Service configuration. Change http and htsp ports here and in conf/tvheadend.sc for non-standard ports
HTTP=9981
HTSP=9982

# Replace generic service startup, run service in background
GRPN=$(id -gn ${EFF_USER})
UPGRADE_CFG_DIR="${SYNOPKG_PKGVAR}/dvr/config"
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/tvheadend -f -C -u ${EFF_USER} -g ${GRPN} --http_port ${HTTP} --htsp_port ${HTSP} -c ${SYNOPKG_PKGVAR} -p ${PID_FILE} -l ${LOG_FILE} --debug \"\""
SVC_BACKGROUND=yes

# Group configuration to manage permissions of recording folders
GROUP=sc-media

service_postinst ()
{
    # EPG Grabber (zap2epg) - Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${PYTHONENV}

    # EPG Grabber (zap2epg) - Install the wheels/requirements
    ${SYNOPKG_PKGDEST}/env/bin/pip install \
             --no-deps --no-index --no-input --upgrade \
             --force-reinstall --find-links \
             ${WHEELHOUSE} ${WHEELHOUSE}/*.whl
}

service_postupgrade ()
{
    # Need to enforce correct permissions for recording directories on upgrades
    echo "Adding ${GROUP} group permissions on recording directories:"
    for file in ${UPGRADE_CFG_DIR}/*
    do
        DVR_DIR=$(grep -e 'storage\":' ${file} | awk -F'"' '{print $4}')
        # Exclude directories in @appstore as ACL permissions srew up package installations
        TRUNC_DIR=$(echo "$(realpath ${DVR_DIR})" | awk -F/ '{print "/"$3}')
        if [ "${TRUNC_DIR}" = "/@appstore" ]; then
            echo "Skip: ${DVR_DIR} (system directory)"
        elif [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ]; then
            echo "Done: ${DVR_DIR}"
            set_syno_permissions "${DVR_DIR}" "${GROUP}"
        fi
    done

    # For backwards compatibility, restore ownership of package system directories
    if [ $SYNOPKG_DSM_VERSION_MAJOR == 6 ]; then
        echo "Restore '${EFF_USER}' unix permissions on package system directories"
        chown ${EFF_USER}:${USER} "${SYNOPKG_PKGDEST}"
        set_unix_permissions "${SYNOPKG_PKGVAR}"
    fi
}
