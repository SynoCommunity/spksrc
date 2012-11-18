#!/bin/sh

# Package
PACKAGE="uidevelop"
DNAME="UI Develop"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
RUNAS="root"
RUN_FILE="/tmp/uidevelop.run"


start_daemon ()
{
    touch ${RUN_FILE}
}

stop_daemon ()
{
    rm -f ${RUN_FILE}
}

daemon_status ()
{
    if [ -f ${RUN_FILE} ]; then
        return
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
    *)
        exit 1
        ;;
esac

