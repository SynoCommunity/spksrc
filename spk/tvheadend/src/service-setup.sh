# Package specific behaviors
# Sourced script by generic installer and start-stop-status scripts

# Group configuration to manage permissions of recording folders
GROUP=sc-media

# Service configuration. Change http and htsp ports here and in conf/tvheadend.sc for non-standard ports
HTTPP=9981
HTSPP=9982

service_prestart ()
{
    # Replace generic service startup, run service as daemon

    GRPN=`id -gn ${EFF_USER}`
    HOME_DIR="${SYNOPKG_PKGDEST}/var"

    echo "Starting Tvheadend as daemon under user ${EFF_USER} in group ${GRPN} with configuration directory ${HOME_DIR} on http port ${HTTPP} and htsp port ${HTSPP}" >> ${LOG_FILE}
    COMMAND="${SYNOPKG_PKGDEST}/bin/tvheadend -f -u ${EFF_USER} -g ${GRPN} --http_port ${HTTPP} --htsp_port ${HTSPP} -c ${HOME_DIR} -l ${LOG_FILE} -p ${PID_FILE}"

    if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 6 ]; then
        su ${EFF_USER} -s /bin/sh -c "${COMMAND}" >> ${LOG_FILE} 2>&1 &
    else
        ${COMMAND} >> ${LOG_FILE} 2>&1 &
    fi
}

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
        set_syno_permissions "${DVR_DIR}" "${GROUP}" >> ${INST_LOG}
    done
}
