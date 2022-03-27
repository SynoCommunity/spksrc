# syncthing service definition
SYNCTHING="${SYNOPKG_PKGDEST}/bin/syncthing"
SERVICE_COMMAND="${SYNCTHING} serve --home=${SYNOPKG_PKGVAR}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

GROUP="sc-syncthing"

# Required to run any syncthing command: set $HOME environment variable
HOME=${SYNOPKG_PKGVAR}
export HOME


set_credentials() {
    if [ -n "${wizard_username}" -a -n "${wizard_password}" ]; then
        # Password needs to be hashed for config entry
        ${SYNCTHING} generate --home=${SYNOPKG_PKGVAR} \
            --gui-user="${wizard_username}" --gui-password="${wizard_password}"
    fi
}

service_postinst() {
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

    # If the system has a TLS certificate for us, force its usage
    cert_dir=/usr/local/etc/certificate/${SYNOPKG_PKGNAME}/${SERVICE_CERT}
    if [ -f ${cert_dir}/cert.pem -a -f ${cert_dir}/privkey.pem ]; then
        ln -sf ${cert_dir}/cert.pem ${SYNOPKG_PKGVAR}/https-cert.pem
        ln -sf ${cert_dir}/privkey.pem ${SYNOPKG_PKGVAR}/https-key.pem
    fi
}

version_le()
{
    if printf '%s\n' "$1" "$2" | sort -VC ; then
        return 0 # true since we are returning an error code
    fi
    return 255 # everything else is false
}

service_preupgrade()
{
    CUR_VER=$(${SYNCTHING} --version | awk '{print $2}' | awk --field-separator=- '{print $1}')
    PKG_VER=$(${SYNOPKG_PKGINST_TEMP_DIR}/bin/syncthing --version | awk '{print $2}' | awk --field-separator=- '{print $1}')
    if version_le $CUR_VER $PKG_VER; then
	install_log "Package ${PKG_VER} is newer than or same as installed binary ${CUR_VER}"
    else
	install_log "Installed binary ${CUR_VER} is newer than package ${PKG_VER}, preserving a backup"
	mkdir ${SYNOPKG_TEMP_UPGRADE_FOLDER}/bin
        cp -p ${SYNCTHING} ${SYNOPKG_TEMP_UPGRADE_FOLDER}/bin/syncthing
    fi
}

service_postupgrade()
{
    if [ -x ${SYNOPKG_TEMP_UPGRADE_FOLDER}/bin/syncthing ]; then
	install_log "Restoring preserved binary backup"
	mv -f ${SYNOPKG_TEMP_UPGRADE_FOLDER}/bin/syncthing ${SYNCTHING}
    fi
}
