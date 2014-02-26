#!/bin/sh

# Package
PACKAGE="shairport"
DNAME="ShairPort"
# Others
SHAIRPORT="${SYNOPKG_PKGDEST}/bin/shairport"
VAR_DIR="${SYNOPKG_PKGDEST}/var"
PID_FILE="${VAR_DIR}/${PACKAGE}.pid"


start_daemon ()
{
    # Launch the service in the background.
	cd ${SYNOPKG_PKGDEST}
	$SHAIRPORT --daemon --pidfile="$PID_FILE" --log=$SYNOPKG_TEMP_LOGFILE
    # Wait until the service  is ready (race condition here).
    counter=5
    while [ $counter -gt 0 ]
    do
        daemon_status && break
        let counter=counter-1
        sleep 1
    done
}

stop_daemon ()
{
    # Kill the servive.
    kill -9 `cat ${PID_FILE}`

    # Wait until transmission is really dead (may take some time).
    counter=20
    while [ $counter -gt 0 ] 
    do
        daemon_status || break
        let counter=counter-1
        sleep 1
    done
}

daemon_status ()
{
    if [ -f ${PID_FILE} ] && [ -d /proc/`cat ${PID_FILE}` ]; then
        return 0
    fi
    return 1
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
    restart)
        stop_daemon
        start_daemon
        exit $?
        ;;
    status)
        if daemon_status
	then
            echo ${DNAME} is running
            exit 0
        else
            echo ${DNAME} is not running
            exit 1
        fi
        ;;
    log)
        echo $LOGFILE
        exit 0
        ;;
    *)
        exit 1
        ;;
esac

