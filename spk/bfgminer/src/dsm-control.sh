#!/bin/sh

# Package
PACKAGE="bfgminer"
DNAME="BFGMiner"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
USER="guest"
BFGMINER="${INSTALL_DIR}/bin/bfgminer"

PID=""
get_pid() 
{
    PID=`ps -w | grep -v grep | grep python | grep bfgui | awk '{print $1}'`
}

start_daemon ()
{
    #su - ${USER} -c "python ${INSTALL_DIR}/app/bfgui.py&"
    python ${INSTALL_DIR}/app/bfgui.py&
}

stop_daemon ()
{
    get_pid
    if [ ! -z $PID ]; then
        kill $PID
    fi
}

daemon_status ()
{
    get_pid
    if [ ! -z ${PID} ] && kill -0 ${PID} > /dev/null 2>&1; then
        return
    fi
    return 1
}

wait_for_status ()
{
    counter=$2
    while [ ${counter} -gt 0 ]; do
        daemon_status
        [ $? -eq $1 ] && return
        let counter=counter-1
        sleep 1
    done
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
    restart)
        stop_daemon
        start_daemon
        exit $?
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
