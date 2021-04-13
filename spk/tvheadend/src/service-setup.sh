# Package specific behaviors
# Sourced script by generic installer and start-stop-status scripts

# Service configuration. Change http and htsp ports here and in conf/tvheadend.sc for non-standard ports
HTTP=9981
HTSP=9982

# Replace generic service startup, run service in background
GRPN=$(id -gn ${EFF_USER})
DVR_LOG_DIR="${SYNOPKG_PKGVAR}/dvr/log"
UPGRADE_CFG_DIR="${SYNOPKG_PKGVAR}/dvr/config"
SAVE_DIR="/tmp/tvheadend-recording-backup"
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/tvheadend -f -u ${EFF_USER} -g ${GRPN} --http_port ${HTTP} --htsp_port ${HTSP} -c ${SYNOPKG_PKGVAR} -p ${PID_FILE}"
SVC_BACKGROUND=yes

# Group configuration to manage permissions of recording folders
GROUP=sc-media

service_postinst ()
{
    # Encrypt password
    wizard_password=$(echo -n "TVHeadend-Hide-${wizard_password:=admin}" | openssl enc -a)

    # Edit the password configuration according to the wizard
    sed -i -e "s/@password@/${wizard_password}/g" ${SYNOPKG_PKGVAR}/passwd/a927e30a755504f9784f23a4efac5109

    # Fix fontconfig links
    CONFD_DIR="${SYNOPKG_PKGDEST}/etc/fonts/conf.d"
    FONTS_DIR="${SYNOPKG_PKGDEST}/share/fontconfig/conf.avail"
    echo "Fixing fontconfig links"
    for FONT_FILE in ${CONFD_DIR}/*.conf
    do
        FONT_NAME=$(basename "${FONT_FILE}")
        $LN "${FONTS_DIR}/${FONT_NAME}" "${CONFD_DIR}/${FONT_NAME}"
    done
}

service_preupgrade ()
{
    # Backup potential recordings from package root directory
    echo "Save potential recordings from package root directory..."
    for logfile in ${DVR_LOG_DIR}/*
    do
        REC_FILE=$(grep -e 'filename' ${logfile} | awk -F'"' '{print $4}')
        # Check whether recording actually exists, otherwise ignore the entry
        if [ -e "${REC_FILE}" ]; then
            REC_DIR=$(dirname "${REC_FILE}")
            REAL_DIR=$(realpath "${REC_DIR}")
            TRUNC_DIR=$(echo "${REAL_DIR}" | cut -c9-28)
            CHECK_VAR=$(echo "${REAL_DIR}" | cut -c29-32)
            if [ ! "${REC_FILE}" = "" ] && [ "${TRUNC_DIR}" = "/@appstore/tvheadend" ] && [ ! "${CHECK_VAR}" = "/var" ]; then
                REC_NAME=$(basename "${REC_FILE}")
                REST_DIR=$(echo "${REAL_DIR}" | cut -c30-)
                DEST_FILE="${SAVE_DIR}/${REST_DIR}/${REC_NAME}"
                echo "Saving: ${REC_FILE}"
                $MKDIR "${SAVE_DIR}/${REST_DIR}"
                $CP "${REC_FILE}" "${DEST_FILE}"
                # Replace any remaining target links in log files first
                sed -i -e "s,${SYNOPKG_PKGDEST},/usr/local/tvheadend/,g" "${logfile}"
                # Adapt recording paths in dvr log files for restored files (postupgrade)
                sed -i -e "s,/tvheadend/,/tvheadend/var/,g" "${logfile}"
            fi
        fi
    done
    # Move recording directories from package root into var
    echo "Move any recording directories from package root directory into var..."
    for file in ${UPGRADE_CFG_DIR}/*
    do
        DVR_DIR=$(grep -e 'storage\":' ${file} | awk -F'"' '{print $4}')
        REAL_DIR=$(realpath "${DVR_DIR}")
        TRUNC_DIR=$(echo "${REAL_DIR}" | cut -c9-28)
        CHECK_VAR=$(echo "${REAL_DIR}" | cut -c29-32)
        # Replace any remaining target links in log files first
        sed -i -e "s,${SYNOPKG_PKGDEST},/usr/local/tvheadend,g" "${file}"
        if [ "${TRUNC_DIR}" = "/@appstore/tvheadend" ] && [ ! "${CHECK_VAR}" = "/var" ]; then
            # Move recording paths in recording profiles into var
            sed -i -e "s,/tvheadend,/tvheadend/var,g" "${file}"
        fi
    done
}

service_postupgrade ()
{
    # For backwards compatibility, restore recordings from old package root into var directory
    if [ -d "${SAVE_DIR}" ]; then
        echo "Restoring recordings into ${SYNOPKG_PKGVAR}"
        $CP "${SAVE_DIR}"/. "${SYNOPKG_PKGVAR}"
        $RM "${SAVE_DIR}"
    fi

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
    echo "Restore '${EFF_USER}' unix permissions on package system directories"
    if [ $SYNOPKG_DSM_VERSION_MAJOR == 6 ]; then
        chown ${EFF_USER}:${USER} "${SYNOPKG_PKGDEST}"
        set_unix_permissions "${SYNOPKG_PKGVAR}"
    fi
}
