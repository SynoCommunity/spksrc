#!/bin/sh


#########################################
# A few variables to make things readable

# Package specific variables
PACKAGE="couchpotato"
PYTHON_DIR="/usr/local/python26"
PYTHON=${PYTHON_DIR}/bin/python
PYTHON_VAR_DIR="/usr/local/var/python26"

# Common variables
INSTALL_DIR="/usr/local/${PACKAGE}"
VAR_DIR="/usr/local/var/${PACKAGE}"
PATH="${PYTHON_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin" # Avoid ipkg commands

RUNAS="${PACKAGE}"
CPPY="${VAR_DIR}/CouchPotato.py"
CPPID="${VAR_DIR}/couchpotato.pid"


start_daemon ()
{
    # Launch Couch Potato in the background.
    su - ${RUNAS} -c "PATH=${PATH} ${PYTHON} ${CPPY} -d --pidfile ${CPPID}"
    counter=20
    while [ $counter -gt 0 ]
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
	
    # Kill Couch Potato.
    kill `cat ${CPPID}`

    # Wait until Couch Potato is really dead (may take some time).
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
    if [ -f ${CPPID} ] 
    then
        if [ -d /proc/`cat ${CPPID}` ]
        then
            return 0
        else
            # PID file exists, but no process has this PID. 
            rm ${CPPID}
        fi
    fi
    return 1
}

run_in_console ()
{
    # Launch Couch Potato in the foreground
    su - ${RUNAS} -c "PATH=${PATH} ${PYTHON} ${CPPY}"
}

case $1 in
    start)
        if daemon_status
        then
            echo Couch Potato is already running
            exit 0
        else
            echo Starting Couch Potato ...
            start_daemon
            exit $?
        fi
        ;;
    stop)
        if daemon_status
        then
            echo Stopping Couch Potato ...
            stop_daemon
            exit $?
        else
            echo Couch Potato is not running
            exit 0
        fi
        ;;
    status)
        ${INSTALL_DIR}/sbin/updateInfo
        if daemon_status
        then
            echo Couch Potato is running
            exit 0
        else
            echo Couch Potato is not running
            exit 1
        fi
        ;;
    console)
        run_in_console
        exit $?
        ;;
    log)
        echo ${VAR_DIR}/logs/CouchPotato.log
        exit 0
        ;;
    *)
        exit 1
        ;;
esac
