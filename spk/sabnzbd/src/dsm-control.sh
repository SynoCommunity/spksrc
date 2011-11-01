#!/bin/sh

#########################################
# A few variables to make things readable

# Package specific variables
PACKAGE="sabnzbd"
DNAME="SABnzbd+"
PYTHON_DIR="/usr/local/python26"
PYTHON_VAR_DIR="/usr/local/var/python26"

# Common variables
INSTALL_DIR="/usr/local/${PACKAGE}"
VAR_DIR="/usr/local/var/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:${PYTHON_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin" # Avoid ipkg commands

RUNAS="${PACKAGE}"
SABNZBD="${INSTALL_DIR}/share/SABnzbd/SABnzbd.py"
PID_FILE="${VAR_DIR}/${PACKAGE}-*.pid"  # The pid file name depends on the effective port
LOG_FILE="${VAR_DIR}/logs/sabnzbd.log"
SABCFG="${VAR_DIR}/config.ini"


start_daemon ()
{
    # Launch the application in the background.
    su - ${RUNAS} -c "PATH=${PATH} ${SABNZBD} --config-file ${SABCFG} --daemon --pid ${VAR_DIR}"
    counter=20
    while [ ${counter} -gt 0 ] 
    do
        daemon_status && break
        let counter=counter-1
        sleep 1
    done
    ln -sf $0 ${PYTHON_VAR_DIR}/run/${PACKAGE}-ctl
}

stop_daemon ()
{
    rm -f ${PYTHON_VAR_DIR}/run/${PACKAGE}-ctl
	
    # Kill the application.
    kill `cat ${PID_FILE}`

    # Wait until the application is really dead (may take some time).
    counter=20
    while [ ${counter} -gt 0 ]
    do
        daemon_status || break
        let counter=counter-1
        sleep 1
    done
}

daemon_status ()
{
    if [ -f ${PID_FILE} ] 
    then
        if [ -d /proc/`cat ${PID_FILE}` ]
        then
            return 0
        else
            # PID file exists, but no process has this PID. 
            rm -f ${PID_FILE}
        fi
    fi
    return 1
}

run_in_console ()
{
    # Launch the application in the foreground
    su - ${RUNAS} -c "PATH=${PATH} ${SABNZBD} --config-file ${SABCFG}"
}

case $1 in
    start)
        if daemon_status
        then
            echo ${DNAME} is already running
            exit 0
        else
            echo Starting ${DNAME} ...
            start_daemon
            exit $?
        fi
        ;;
    stop)
        if daemon_status
        then
            echo Stopping ${DNAME} ...
            stop_daemon
            exit $?
        else
            echo ${DNAME} is not running
            exit 0
        fi
        ;;
    status)
        ${INSTALL_DIR}/sbin/updateInfo
        if daemon_status
        then
            echo ${DNAME} is running
            exit 0
        else
            echo ${DNAME} is not running
            exit 1
        fi
        ;;
    console)
        run_in_console
        exit $?
        ;;
    log)
        echo ${LOG_FILE}
        exit 0
        ;;
    *)
        exit 1
        ;;
esac

