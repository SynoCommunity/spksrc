# Package specific behaviors
# Sourced script by generic installer and start-stop-status scripts

# Group to access XMLTV files
GROUP=sc-media

# Default configuration file
SPKETC="/var/packages/${SYNOPKG_PKGNAME}/etc"
SYNOCRON=/usr/local/etc/synocron.d/
INSTALLER_VARIABLES="${SPKETC}/installer-variables"
#
ZAP2IT_CONF=${SYNOPKG_PKGDEST}/etc/zap2itconfig.ini
ZAP2IT_CACHE=${SYNOPKG_PKGVAR}
ZAP2IT_BACKUP=/tmp/zap2it

write_zap2it_config()
{
    echo "Call write_zap2it_config()"

    # Set default country
    [ "${zap2it_CAN}" = "true" ] && zap2it_country=CAN || zap2it_country=USA
    # Remove spaces from CAD postal code
    zap2it_code=$(echo ${zap2it_code} | sed 's/ //g')

    # Keep previous passwd if left blank at upgrade time
    echo "Keep previous passwd if left blank at upgrade time"
    if [ "${ZAP2IT_PASSWD}" -a ! "${zap2it_password}" ]; then
       zap2it_password=$(echo "${ZAP2IT_PASSWD}" | openssl enc -d -aes-256-cbc -pass pass:zap2it -a)
    fi

    # Set configuration according to the wizard
    echo "Set configuration according to the wizard"
    sed -i "/^Username: /s/ .*/ ${zap2it_user}/" ${ZAP2IT_CONF}
    sed -i "/^Password: /s/ .*/ ${zap2it_password}/" ${ZAP2IT_CONF}
    sed -i "/^country: /s/ .*/ ${zap2it_country}/" ${ZAP2IT_CONF}
    sed -i "/^zipCode: /s/ .*/ ${zap2it_code}/" ${ZAP2IT_CONF}
    sed -i "/^historicalGuideDays: /s/ .*/ ${zap2it_days}/" ${ZAP2IT_CONF}

    # Encrypt password
    echo "Encrypt password"
    ZAP2IT_PASSWD=$(echo -n "${zap2it_password}" | openssl enc -aes-256-cbc -pass pass:zap2it -a)
    # Backup installer variables
    sed -i -n -e '/^ZAP2IT_USER=/!p' -e "\$aZAP2IT_USER=\"${zap2it_user}\"" ${INSTALLER_VARIABLES}
    sed -i -n -e '/^ZAP2IT_PASSWD=/!p' -e "\$aZAP2IT_PASSWD=\"${ZAP2IT_PASSWD}\"" ${INSTALLER_VARIABLES}
    sed -i -n -e '/^ZAP2IT_CAN=/!p' -e "\$aZAP2IT_CAN=\"${zap2it_CAN}\"" ${INSTALLER_VARIABLES}
    sed -i -n -e '/^ZAP2IT_US=/!p' -e "\$aZAP2IT_US=\"${zap2it_US}\"" ${INSTALLER_VARIABLES}
    sed -i -n -e '/^ZAP2IT_CODE=/!p' -e "\$aZAP2IT_CODE=\"${zap2it_code}\"" ${INSTALLER_VARIABLES}
    sed -i -n -e '/^ZAP2IT_DAYS=/!p' -e "\$aZAP2IT_DAYS=\"${zap2it_days}\"" ${INSTALLER_VARIABLES}
}

service_postinst ()
{
    # Create cache directory if it does not exist
    echo "Create cache directory if it does not exist (${ZAP2IT_CACHE})"
    mkdir -p --mode=0755 ${ZAP2IT_CACHE}
    # For backwards compatibility, set ownership of package system directories
    if [ $SYNOPKG_DSM_VERSION_MAJOR == 6 ]; then
        echo "Set unix permissions on configuration directory"
        set_unix_permissions "${SYNOPKG_PKGDEST}"
        echo "Set unix permissions on cache directory"
        set_unix_permissions "${SYNOPKG_PKGVAR}"
    fi

    # Adjust configuration files
    write_zap2it_config

    # Install the synocron
    echo "Install synocron (${SYNOCRON}/zap2it.conf)"
    cp ${SYNOPKG_PKGDEST}/etc/zap2it.synocron ${SYNOCRON}/zap2it.conf
    synoservice --restart synocrond
}

service_postuninst ()
{
    # Remove synocron
    echo "Remove synocron"
    rm -f ${SYNOCRON}/zap2it.conf
    synoservice --restart synocrond
}

service_preupgrade ()
{
    # Create a backup copy
    echo "Create a backup copy"
    mkdir -p ${ZAP2IT_BACKUP}
    rsync -ah ${SYNOPKG_PKGDEST}/var ${ZAP2IT_BACKUP}
}

service_postupgrade ()
{
    # Recover backup
    echo "Recover backup"
    rsync -ah --ignore-existing --remove-source-files ${ZAP2IT_BACKUP}/var/ ${SYNOPKG_PKGDEST}/var
    # Remove backup directory
    rm -fr ${ZAP2IT_BACKUP}
}
