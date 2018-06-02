# Setup environment
PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"
SYNCTHING="${SYNOPKG_PKGDEST}/bin/syncthing"
CONFIG_DIR="${SYNOPKG_PKGDEST}/var"
SYNCTHING_OPTIONS="-home=${CONFIG_DIR}"

# Read additional startup options from /usr/local/syncthing/var/options.conf
if [ -f ${CONFIG_DIR}/options.conf ]; then
    source ${CONFIG_DIR}/options.conf
fi

# Overwrite the Makefile variables
SERVICE_EXE="env HOME=${SYNOPKG_PKGDEST}/var ${SYNOPKG_PKGDEST}/bin/syncthing"
SERVICE_OPTIONS="-home=${SYNOPKG_PKGDEST}/var"

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
