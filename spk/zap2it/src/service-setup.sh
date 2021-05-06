# Package specific behaviors
# Sourced script by generic installer and start-stop-status scripts

# Group configuration to manage permissions of recording folders
GROUP=sc-media

# Default configuration file
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
    wizard_password=`echo -n "TVHeadend-Hide-${wizard_password:=admin}" | openssl enc -a`

    # Set configuration according to the wizard
    sed -i -e "s/example\$/${wizard_user}/g" ${CONF}
    sed -i -e "s/examplePass\$/${wizard_password}/g" ${CONF}
    sed -i -e "s/USA\$/${wizard_country}/g" ${CONF}
    sed -i -e "s/55555\$/${wizard_zipcode}/g" ${CONF}
}

service_preupgrade ()
{
}

service_postupgrade ()
{
}
