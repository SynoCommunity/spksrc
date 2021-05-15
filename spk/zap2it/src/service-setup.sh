# Package specific behaviors
# Sourced script by generic installer and start-stop-status scripts

# Group configuration to manage permissions of recording folders
GROUP=sc-media

# Default configuration file
SYNOCRON=/usr/local/etc/synocron.d/
CONF=${SYNOPKG_PKGDEST}/etc/zap2itconfig.ini
CACHE=${SYNOPKG_PKGVAR}

service_postinst ()
{
    # Create cache directory if it does not exist
    mkdir --mode=0755 ${CACHE}
    # For backwards compatibility, set ownership of package system directories
    if [ $SYNOPKG_DSM_VERSION_MAJOR == 6 ]; then
        echo "Set unix permissions on configuration directory"
        set_unix_permissions "${SYNOPKG_PKGDEST}"
        echo "Set unix permissions on cache directory"
        set_unix_permissions "${SYNOPKG_PKGVAR}"
    fi

    # Encrypt password
    zap2it_password=$(echo -n "TVHeadend-Hide-${zap2it_password}" | openssl enc -a)
    [ "${zap2it_CAN}" = "true" ] && zap2it_country=CAN || zap2it_country=USA
    # Remove spaces from CAD postal code
    zap2it_code=$(echo ${zap2it_code} | sed 's/ //g')

    # Set configuration according to the wizard
    sed -i "/^Username: /s/ .*/ ${zap2it_user}/" ${CONF}
    sed -i "/^Password: /s/ .*/ ${zap2it_password}/" ${CONF}
    sed -i "/^country: /s/ .*/ ${zap2it_country}/" ${CONF}
    sed -i "/^zipCode: /s/ .*/ ${zap2it_code}/" ${CONF}
    sed -i "/^historicalGuideDays: /s/ .*/ ${zap2it_days}/" ${CONF}

    # Install the synocron
    cp ${SYNOPKG_PKGDEST}/etc/zap2it.synocron ${SYNOCRON}/zap2it.conf
    sudo synoservice --restart synocrond
}

service_preupgrade ()
{
}

service_postupgrade ()
{
}
