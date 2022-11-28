
# Package specific behaviors
# Sourced script by generic installer and start-stop-status scripts

SERVER_MODULE="SimpleHTTPServer"
PYTHON_VERSION=$(python --version 2>&1)
PYTHON_MAJOR_VERSION=$(echo ${PYTHON_VERSION} | cut -d ' ' -f2 | cut -d . -f1)

if [ "${PYTHON_MAJOR_VERSION}" == "3" ]; then
SERVER_MODULE="http.server"
fi


SERVICE_COMMAND="python -m ${SERVER_MODULE} ${SERVICE_PORT}"
SVC_CWD="${SYNOPKG_PKGVAR}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y


# These functions are for demonstration purpose of DSM sequence call
# and installation logging capabilities.
# Only provide useful ones for your own package, logging may be removed.


validate_preinst ()
{
    # use install_log to write to installer log file.
    install_log "validate_preinst ${SYNOPKG_PKG_STATUS}"
    
    # writing to stdout in dsm7 shows "installation error" without exit 1 (this looks like an error of DSM7 beta)
    #echo "preinst validation notification"
    
    # to abort the installer use "exit 1"
}

validate_preuninst ()
{
    # use install_log to write to installer log file.
    install_log "validate_preuninst ${SYNOPKG_PKG_STATUS}"

    # writing to stdout in dsm7 shows "installation error" without exit 1 (this looks like an error of DSM7 beta)
    #echo "preuninst validation notification"
    
    # to abort the installer use "exit 1"
}

validate_preupgrade ()
{
    # use install_log to write to installer log file.
    install_log "validate_preupgrade ${SYNOPKG_PKG_STATUS}"

    # writing to stdout in dsm7 shows "installation error" without exit 1 (this looks like an error of DSM7 beta)
    #echo "preupgrade validation notification"
    
    # to abort the installer use "exit 1"
}

service_preinst ()
{
    # use echo to write to the installer log file.
    echo "service_preinst ${SYNOPKG_PKG_STATUS}"
    
    echo "PYTHON_VERSION:       ${PYTHON_VERSION}"
    echo "PYTHON_MAJOR_VERSION: ${PYTHON_MAJOR_VERSION}"
    echo "SERVER_MODULE:        ${SERVER_MODULE}"
    echo "SERVICE_COMMAND:      ${SERVICE_COMMAND}"
    echo "SYNOPKG_PKGVAR:       ${SYNOPKG_PKGVAR}"
}

service_postinst ()
{
    # use echo to write to the installer log file.
    echo "service_postinst ${SYNOPKG_PKG_STATUS}"
    
    ln -sf ${INST_LOG} ${SYNOPKG_PKGVAR}/installer.log
}

service_preuninst ()
{
    # use echo to write to the installer log file.
    echo "service_preuninst ${SYNOPKG_PKG_STATUS}"
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
}

service_postupgrade ()
{
    # use echo to write to the installer log file.
    echo "service_postupgrade ${SYNOPKG_PKG_STATUS}"
}

service_prestart ()
{
    # use echo to write to the service log file.
    echo "service_prestart: Before service start"
}

service_poststop ()
{
    # use echo to write to the service log file.
    echo "service_poststop: After service stop"
}

