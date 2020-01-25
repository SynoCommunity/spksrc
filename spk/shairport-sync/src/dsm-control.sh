#!/bin/sh

NAME="shairport-sync"

TARGET_DIR="/usr/local/${NAME}"
PATH="${TARGET_DIR}/bin:${PATH}"
DAEMON="${TARGET_DIR}/bin/${NAME}"
PID_FILE="${TARGET_DIR}/var/run/${NAME}.pid"
CONFIG_FILE="${TARGET_DIR}/var/${NAME}.conf"


start_daemon ()
{
    # Return
    #   0 if daemon has been started
    #   2 if daemon could not be started

    # Select daemon mode and define the location of the config file.
    start-stop-daemon --start --quiet --pidfile ${PID_FILE} --exec ${DAEMON} -- --daemon --configfile=${CONFIG_FILE} &> /dev/null \
        || return 2

    # Add code here, if necessary, that waits for the process to be ready
    # to handle requests from services started subsequently which depend
    # on this one.  As a last resort, sleep for some time.
}

stop_daemon ()
{
    # Return
    #   0 if daemon has been stopped
    #   1 if daemon was already stopped
    #   2 if daemon could not be stopped
    #   other if a failure occurred
    start-stop-daemon --stop --quiet -R=TERM/30/KILL/5 --pidfile ${PID_FILE} --name ${NAME}
    RETVAL="$?"
    [ "$RETVAL" = 2 ] && return 2

    # Wait for children to finish too if this is a daemon that forks
    # and if the daemon is only ever run from this script.
    # If the above conditions are not satisfied then add some other code
    # that waits for the process to drop all resources that could be
    # needed by services started subsequently.
    # A last resort is to sleep for some time.
    start-stop-daemon --stop --quiet --oknodo -R=0/30/KILL/5 --exec ${DAEMON}
    [ "$?" = 2 ] && return 2

    return "$RETVAL"
}

daemon_status ()
{
    # Return
    #   0 if daemon is running
    #   1 if daemon is not running
    start-stop-daemon --stop --quiet --test --pidfile ${PID_FILE} &> /dev/null
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
    *)
        exit 1
        ;;
esac
