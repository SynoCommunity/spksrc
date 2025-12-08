# syncthing service definition
SYNCTHING="${SYNOPKG_PKGDEST}/bin/syncthing"
# file with additional options
SYNCTHING_OPTIONS_FILE=${SYNOPKG_PKGVAR}/options.conf
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
    
    if [ "${SYNOPKG_DSM_ARCH}" == "88f628x" ]; then
        # disable auto update for AMRv5 archs
        comment="disable auto update for ${SYNOPKG_DSM_ARCH} arch"
        if [ -r ${SYNCTHING_OPTIONS_FILE} ]; then
            if grep -q "^SYNCTHING_OPTIONS=" "${SYNCTHING_OPTIONS_FILE}"; then
                options=$(grep '^SYNCTHING_OPTIONS=' ${SYNCTHING_OPTIONS_FILE} | cut -d= -f2 | tr -d '"')
                if [[ "${options}" == *"--no-upgrade"* ]]; then
                    echo "- 'auto update' option is already disabled for ${SYNOPKG_DSM_ARCH} arch"
                else
                    echo "- Patch ${SYNCTHING_OPTIONS_FILE} to ${comment}"
                    sed "s/^SYNCTHING_OPTIONS=.*/SYNCTHING_OPTIONS=\"${options} --no-upgrade\"/" -i ${SYNCTHING_OPTIONS_FILE}
                fi
            elif grep -q "#SYNCTHING_OPTIONS=" "${SYNCTHING_OPTIONS_FILE}"; then
                # commented SYNCTHING_OPTIONS defined, append line to disable auto update
                echo "- Patch ${SYNCTHING_OPTIONS_FILE} to add option to ${comment}"
                sed '/#SYNCTHING_OPTIONS=.*/a SYNCTHING_OPTIONS="--no-upgrade"' -i ${SYNCTHING_OPTIONS_FILE}
            else
                echo "- Add option in ${SYNCTHING_OPTIONS_FILE} to ${comment}"
                echo "SYNCTHING_OPTIONS=\"--no-upgrade\"" >>  ${SYNCTHING_OPTIONS_FILE}
            fi
        else
            # create options file (should not occur, since such a file was just installed)
            echo "- Create ${SYNCTHING_OPTIONS_FILE} with option to ${comment}"
            echo "SYNCTHING_OPTIONS=\"--no-upgrade\"" > ${SYNCTHING_OPTIONS_FILE}
        fi
    fi
}

service_prestart ()
{
    # Read additional startup options and variables from var/options.conf
    if [ -r ${SYNCTHING_OPTIONS_FILE} ]; then
        . ${SYNCTHING_OPTIONS_FILE}
        SERVICE_COMMAND="${SERVICE_COMMAND} ${SYNCTHING_OPTIONS}"
    fi

    # Required to run any syncthing command: set $HOME environment variable
    if [ -z "${HOME}" ]; then
        # if HOME is not set in ${SYNCTHING_OPTIONS_FILE}
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
        if [ -e ${SYNCTHING_OPTIONS_FILE}.new ]; then
            echo "remove former version of options.conf.new"
            rm -f ${SYNCTHING_OPTIONS_FILE}.new
        fi
    fi
}

service_restore ()
{
    if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
        echo "install updated options.conf as options.conf.new"
        mv -f ${SYNCTHING_OPTIONS_FILE} ${SYNCTHING_OPTIONS_FILE}.new
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
