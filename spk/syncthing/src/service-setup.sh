# syncthing service definition
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/syncthing serve --home=${SYNOPKG_PKGVAR}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

GROUP="sc-syncthing"

set_credentials() {
    if [ -n "${wizard_username}" -a -n "${wizard_password}" ]; then
        # Password needs to be hashed for config entry
        ${SYNOPKG_PKGDEST}/bin/syncthing generate --home=${SYNOPKG_PKGVAR} \
            --gui-user="${wizard_username}" --gui-password="${wizard_password}"
    fi
}

service_postinst() {
    # Required: set $HOME environment variable
    HOME=${SYNOPKG_PKGVAR}
    export HOME

    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        set_credentials
    fi
}

service_prestart ()
{
    # Read additional startup options from var/options.conf
    if [ -f ${SYNOPKG_PKGVAR}/options.conf ]; then
        . ${SYNOPKG_PKGVAR}/options.conf
        SERVICE_COMMAND="${SERVICE_COMMAND} ${SYNCTHING_OPTIONS}"
    fi

    # Required: set $HOME environment variable
    HOME=${SYNOPKG_PKGVAR}
    export HOME
}
