# Setup environment
PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"

GROUP="sc-syncthing"
LEGACY_GROUP="users"

service_postinst ()
{
    # Add also to "users" group in case it was there
    # This way it keeps any permissions it used to have
    syno_user_add_to_legacy_group "${EFF_USER}" "${USER}" "${LEGACY_GROUP}"

    # Discard legacy obsolete busybox user account
    BIN=${SYNOPKG_PKGDEST}/bin
    $BIN/busybox --install $BIN >> ${INST_LOG}
    $BIN/delgroup "${USER}" "users" >> ${INST_LOG}
    $BIN/deluser "${USER}" >> ${INST_LOG}
}

service_prestart ()
{
    CONFIG_DIR="${SYNOPKG_PKGDEST}/var"
    SYNCTHING_OPTIONS="-home=${CONFIG_DIR}"

    # Read additional startup options from /usr/local/syncthing/var/options.conf
    if [ -f ${CONFIG_DIR}/options.conf ]; then
        . ${CONFIG_DIR}/options.conf
    fi

    SERVICE_OPTIONS=$SYNCTHING_OPTIONS

    # Required: start-stop-daemon do not set environment variables
    HOME=${SYNOPKG_PKGDEST}/var
    export HOME
}
