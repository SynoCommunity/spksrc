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

service_preupgrade ()
{
    # For backwards compatibility on DSM6 systems, backup potential recordings from package root directory
    if [ $SYNOPKG_DSM_VERSION_MAJOR -gt 5 ]; then
        echo "Backup potential recordings from package root directory:" >> ${INST_LOG}
        tar --exclude=app --exclude=bin --exclude=etc --exclude=lib --exclude=sbin --exclude=share --exclude=var --exclude=openssl.cnf -cvf "/tmp/savedrecs.tar" -C "/volume1/@appstore/tvheadend" . >> ${INST_LOG}
    fi
}

service_postupgrade ()
{
    # For backwards compatibility, restore potential recordings from package root directory into var directory
    if [ -e "/tmp/savedrecs.tar" ]; then
        echo "Restoring potential recordings into /volume1/@appstore/tvheadend/var" >> ${INST_LOG}
        /bin/tar -xvf "/tmp/savedrecs.tar" -C "/volume1/@appstore/tvheadend/var" >> ${INST_LOG}
        $RM "/tmp/savedrecs.tar"
    fi

    # Need to enforce correct permissions for recording directories on upgrades
    echo "Adding ${GROUP} group permissions on recording directories:"  >> ${INST_LOG}
    UPGRADE_CFG_DIR="${SYNOPKG_PKGDEST}/var/dvr/config"
    for file in ${UPGRADE_CFG_DIR}/*
    do
        DVR_DIR=`grep -e 'storage\":' ${file} | awk -F'"' '{print $4}'`
        # Exclude directories in @appstore as ACL permissions srew up package installations
        TRUNC_DIR=$(echo "$(realpath ${DVR_DIR})" | awk -F/ '{print "/"$3}')
        if [ "${TRUNC_DIR}" = "/@appstore" ]; then
            echo "Skip: ${DVR_DIR} (system directory)" >> ${INST_LOG}
        else
            echo "Done: ${DVR_DIR}" >> ${INST_LOG}
            set_syno_permissions "${DVR_DIR}" "${GROUP}"
        fi
    done

    # For backwards compatibility, restore ownership of package system directories
    echo "Restore '${EFF_USER}' unix permissions on package system directories" >> ${INST_LOG}
    if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 6 ]; then
        synoacltool -del "/volume1/@appstore/tvheadend" >> ${INST_LOG} 2>&1
        chown ${EFF_USER}:root "/var/packages/tvheadend" >> ${INST_LOG} 2>&1
    else
        chown ${EFF_USER}:${USER} "/var/packages/tvheadend/target" >> ${INST_LOG} 2>&1
        set_unix_permissions "/volume1/@appstore/tvheadend/var"
    fi
}
