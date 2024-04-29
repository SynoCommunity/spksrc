
# Package specific behaviors
# Sourced script by generic installer and start-stop-status scripts

# pass variables to service script by env
export PID_FILE=${PID_FILE}
export SERVICE_PORT=${SERVICE_PORT}

SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/start.sh"
SVC_CWD="${SYNOPKG_PKGVAR}"


# These functions are for demonstration purpose of DSM sequence call
# and installation logging capabilities.
# Only provide useful ones for your own package, logging may be removed.


validate_preinst ()
{
    # use install_log to write to installer log file.
    install_log "validate_preinst ${SYNOPKG_PKG_STATUS}"
    
    # variables not available in preinst
    install_log "Variables:"
    install_log "SHARE_PATH=${SHARE_PATH}"
    install_log "SHARE_NAME=${SHARE_NAME}"

    # writing to stdout in dsm7 shows "installation error" without exit 1 (this looks like an error of DSM7 beta)
    #echo "preinst validation notification"
    
    # to abort the installer use "exit 1"
}

validate_preuninst ()
{
    # use install_log to write to installer log file.
    install_log "validate_preuninst ${SYNOPKG_PKG_STATUS}"
    
    # variables not available in preinst
    install_log "Variables:"
    install_log "SHARE_PATH=${SHARE_PATH}"
    install_log "SHARE_NAME=${SHARE_NAME}"

    # writing to stdout in dsm7 shows "installation error" without exit 1 (this looks like an error of DSM7 beta)
    #echo "preuninst validation notification"
    
    # to abort the installer use "exit 1"
}

validate_preupgrade ()
{
    # use install_log to write to installer log file.
    install_log "validate_preupgrade ${SYNOPKG_PKG_STATUS}"

    install_log "Variables:"
    install_log "SHARE_PATH=${SHARE_PATH}"
    install_log "SHARE_NAME=${SHARE_NAME}"

    # writing to stdout in dsm7 shows "installation error" without exit 1 (this looks like an error of DSM7 beta)
    #echo "preupgrade validation notification"
    
    # to abort the installer use "exit 1"
}

service_preinst ()
{
    # use echo to write to the installer log file.
    echo "service_preinst ${SYNOPKG_PKG_STATUS}"
    
    echo "Variables:"
    echo "SHARE_PATH=${SHARE_PATH}"
    echo "SHARE_NAME=${SHARE_NAME}"
}

service_postinst ()
{
    # use echo to write to the installer log file.
    echo "service_postinst ${SYNOPKG_PKG_STATUS}"
    
    echo "Variables:"
    echo "SHARE_PATH=${SHARE_PATH}"
    echo "SHARE_NAME=${SHARE_NAME}"

    ln -sf ${INST_LOG} ${SYNOPKG_PKGVAR}/${SYNOPKG_PKGNAME}-installer.log
}

service_preuninst ()
{
    # use echo to write to the installer log file.
    echo "service_preuninst ${SYNOPKG_PKG_STATUS}"
    
    echo "Variables:"
    echo "SHARE_PATH=${SHARE_PATH}"
    echo "SHARE_NAME=${SHARE_NAME}"
}

service_postuninst ()
{
    # use echo to write to the installer log file.
    echo "service_postuninst ${SYNOPKG_PKG_STATUS}"
}

service_preupgrade ()
{
    # use echo to write to the installer log file.
    echo "service_preupgrade ${SYNOPKG_PKG_STATUS}"

    echo "Variables:"
    echo "SHARE_PATH=${SHARE_PATH}"
    echo "SHARE_NAME=${SHARE_NAME}"
}

service_postupgrade ()
{
    # use echo to write to the installer log file.
    echo "service_postupgrade ${SYNOPKG_PKG_STATUS}"

    echo "Variables:"
    echo "SHARE_PATH=${SHARE_PATH}"
    echo "SHARE_NAME=${SHARE_NAME}"
}

# REMARKS:
# installer variables are not available in the context of service start/stop
# The regular solution is to use configuration files for services

service_prestart ()
{
    # use echo to write to the service log file.
    echo "service_prestart: Before service start"

    # This code shows how to load and use the function 'load_variables_from_file'
    # defined in the script/functions file
    INST_FUNCTIONS=$(dirname $0)"/functions"
    if [ -r "${INST_FUNCTIONS}" ]; then
        . "${INST_FUNCTIONS}"
        load_variables_from_file ${INST_VARIABLES}
        echo "Variables read from ${INST_VARIABLES}"
        echo "SHARE_PATH=${SHARE_PATH}"
        echo "SHARE_NAME=${SHARE_NAME}"
    fi
}

service_poststop ()
{
    # use echo to write to the service log file.
    echo "service_poststop: After service stop"
}

