# Package specific behaviors
# Sourced script by generic installer and start-stop-status scripts

# Service configuration. Change http and htsp ports here and in conf/tvheadend.sc for non-standard ports
HTTPP=9981
HTSPP=9982

# Replace generic service startup, run service in background
GRPN=`id -gn ${EFF_USER}`
HOME_DIR="${SYNOPKG_PKGDEST}/var"
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/tvheadend -f -u ${EFF_USER} -g ${GRPN} --http_port ${HTTPP} --htsp_port ${HTSPP} -c ${HOME_DIR} -l ${LOG_FILE} -p ${PID_FILE}"
SVC_BACKGROUND=yes

# Group configuration to manage permissions of recording folders
GROUP=sc-media

service_postinst ()
{
    # Encrypt password
    wizard_password=`echo -n "TVHeadend-Hide-${wizard_password:=admin}" | openssl enc -a`

    # Edit the configuration according to the wizard
    sed -i -e "s/@username@/${wizard_username:=admin}/g" ${SYNOPKG_PKGDEST}/var/accesscontrol/d80ccc09630261ffdcae1497a690acc8
    sed -i -e "s/@username@/${wizard_username:=admin}/g" ${SYNOPKG_PKGDEST}/var/passwd/a927e30a755504f9784f23a4efac5109
    sed -i -e "s/@password@/${wizard_password}/g" ${SYNOPKG_PKGDEST}/var/passwd/a927e30a755504f9784f23a4efac5109

    # Fix fontconfig links
    CONFD_DIR="${SYNOPKG_PKGDEST}/etc/fonts/conf.d"
    FONTS_DIR="${SYNOPKG_PKGDEST}/share/fontconfig/conf.avail"
    echo "Fixing fontconfig links" >> ${INST_LOG}
    for FONT_FILE in ${CONFD_DIR}/*.conf
    do
        FONT_NAME=`basename "${FONT_FILE}"`
        $LN "${FONTS_DIR}/${FONT_NAME}" "${CONFD_DIR}/${FONT_NAME}" >> ${INST_LOG}
    done

    # Discard legacy obsolete busybox user account
    BIN=${SYNOPKG_PKGDEST}/bin
    $BIN/busybox --install $BIN
    $BIN/delgroup "${USER}" "users" >> ${INST_LOG}
    $BIN/deluser "${USER}" >> ${INST_LOG}
}

service_postupgrade ()
{
    # Need to enforce correct permissions for recording directories on upgrades
    echo "Adding ${GROUP} group permissions on recording directories:"  >> ${INST_LOG}
    UPGRADE_CFG_DIR="${SYNOPKG_PKGDEST}/var/dvr/config"
    for file in ${UPGRADE_CFG_DIR}/*
    do
        DVR_DIR=`grep -e 'storage\":' ${file} | awk -F'"' '{print $4}'`
        # Exclude target link (default recording folder) as ACL permissions srew up package installation
        if [ ! "${DVR_DIR}" = "/var/packages/tvheadend/target" ]; then
            echo "Done: ${DVR_DIR}" >> ${INST_LOG}
            set_syno_permissions "${DVR_DIR}" "${GROUP}"
        fi
    done

    # Restore ownership of target link, which is lost during upgrades
    echo "Restore '${EFF_USER}' unix permissions on target link" >> ${INST_LOG}
    if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 6 ]; then
        chown ${EFF_USER}:root "/var/packages/tvheadend/target" >> $INST_LOG 2>&1
    else
        chown ${EFF_USER}:${USER} "/var/packages/tvheadend/target" >> $INST_LOG 2>&1
    fi
}
