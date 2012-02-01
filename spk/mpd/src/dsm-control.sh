#!/bin/sh

#########################################
# A few variables to make things readable

# Package specific variables
PACKAGE="mpd"
DNAME="Music Player Daemon"

# Common variables
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin" # Avoid ipkg commands

RUNAS="root"
MPD="${INSTALL_DIR}/bin/mpd"
CFG_FILE="${INSTALL_DIR}/etc/mpd.conf"
PID_FILE="${INSTALL_DIR}/var/pid"

start_daemon ()
{
    # Launch the application in the background
    su - ${RUNAS} -c "PATH=${PATH} ${MPD} -c ${CFG_FILE}"
    counter=20
    while [ ${counter} -gt 0 ]; do
        daemon_status && break
        let counter=counter-1
        sleep 1
    done
}

stop_daemon ()
{
    # Kill the application
    kill `cat ${PID_FILE}`

    # Wait until the application is really dead (may take some time)
    counter=20
    while [ $counter -gt 0 ]; do
        daemon_status || exit 0
        let counter=counter-1
        sleep 1
    done

    exit 1
}

reload_daemon ()
{
    kill -s HUP `cat ${PID_FILE}`
}

daemon_status ()
{
    if [ -f ${PID_FILE} ]; then
        if [ -d /proc/`cat ${PID_FILE}` ]; then
            return 0
        else
            # PID file exists, but no process has this PID
            rm ${PID_FILE}
    	fi
    fi
    return 1
}


case $1 in
    start)
        if daemon_status; then
            echo ${DNAME} is already running
            exit 0
        else
            echo Starting ${DNAME} ...
            start_daemon
            exit $?
        fi
        ;;
    stop)
        if daemon_status; then
            echo Stopping ${DNAME} ...
            stop_daemon
            exit $?
        else
            echo ${DNAME} is not running
            exit 0
        fi
        ;;
    status)
        if daemon_status; then
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

