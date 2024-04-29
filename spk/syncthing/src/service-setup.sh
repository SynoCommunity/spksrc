# syncthing service definition
SYNCTHING="${SYNOPKG_PKGDEST}/bin/syncthing"
# define folder for configuration (config, keys, database, logs)
SYNCTHING_CONFIG="--config=${SYNOPKG_PKGVAR} --data=${SYNOPKG_PKGVAR}"
SERVICE_COMMAND="${SYNCTHING} serve ${SYNCTHING_CONFIG}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y

GROUP="sc-syncthing"

# include next gen gui
export STGUIASSETS=${SYNOPKG_PKGDEST}/gui

set_credentials() {
    if [ -n "${wizard_username}" -a -n "${wizard_password}" ]; then
        echo "set user name ${wizard_username} for syncthing Web GUI access"
        # Password needs to be hashed for config entry
        # Required to run any syncthing command: set $HOME environment variable
        HOME=${SYNOPKG_PKGVAR} ${SYNCTHING} generate    \
                --config=${SYNOPKG_PKGVAR}              \
                --gui-user="${wizard_username}"         \
                --gui-password="${wizard_password}"
    fi
}

service_postinst() {
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        set_credentials
    fi
}

service_prestart ()
{
    # Read additional startup options and variables from var/options.conf
    if [ -f ${SYNOPKG_PKGVAR}/options.conf ]; then
        . ${SYNOPKG_PKGVAR}/options.conf
        SERVICE_COMMAND="${SERVICE_COMMAND} ${SYNCTHING_OPTIONS}"
    fi

    # Required to run any syncthing command: set $HOME environment variable
    if [ -z "${HOME}" ]; then
        # if HOME is not set in options.conf
        # use a default folder the package user has permissions for
        HOME=${SYNOPKG_PKGVAR}
    fi
    export HOME

    # If the system has a TLS certificate for us, force its usage
    cert_dir=/usr/local/etc/certificate/${SYNOPKG_PKGNAME}/${SERVICE_CERT}
    if [ -f ${cert_dir}/cert.pem -a -f ${cert_dir}/privkey.pem ]; then
        ln -sf ${cert_dir}/cert.pem ${SYNOPKG_PKGVAR}/https-cert.pem
        ln -sf ${cert_dir}/privkey.pem ${SYNOPKG_PKGVAR}/https-key.pem
    fi
}


service_save ()
{
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        if [ -e ${SYNOPKG_PKGVAR}/options.conf.new ]; then
            echo "remove former version of options.conf.new"
            rm -f ${SYNOPKG_PKGVAR}/options.conf.new
        fi
    fi
}

service_restore ()
{
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        echo "install updated options.conf as options.conf.new"
        mv -f ${SYNOPKG_PKGVAR}/options.conf ${SYNOPKG_PKGVAR}/options.conf.new
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
    # Required to run any syncthing command: set $HOME environment variable
    CUR_VER=$(HOME=${SYNOPKG_PKGVAR} ${SYNCTHING} --version | awk '{print $2}' | awk --field-separator=- '{print $1}')
    PKG_VER=$(HOME=${SYNOPKG_PKGVAR} ${SYNOPKG_PKGINST_TEMP_DIR}/bin/syncthing --version | awk '{print $2}' | awk --field-separator=- '{print $1}')
    if version_le $CUR_VER $PKG_VER; then
        echo "Package ${PKG_VER} is newer than or same as installed binary ${CUR_VER}"
    else
        echo "Installed binary ${CUR_VER} is newer than package ${PKG_VER}, preserving a backup"
        mkdir ${SYNOPKG_TEMP_UPGRADE_FOLDER}/bin
        cp -p ${SYNCTHING} ${SYNOPKG_TEMP_UPGRADE_FOLDER}/bin/syncthing
    fi
}

service_postupgrade()
{
    if [ -x ${SYNOPKG_TEMP_UPGRADE_FOLDER}/bin/syncthing ]; then
        echo "Restoring preserved binary backup"
        mv -f ${SYNOPKG_TEMP_UPGRADE_FOLDER}/bin/syncthing ${SYNCTHING}
    fi
}
