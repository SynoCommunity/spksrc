#!/bin/sh

# Package
PACKAGE="salt-minion"
DNAME="Salt Minion"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PYTHON_DIR="/usr/local/python3"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:${PATH}"
PYTHON="${INSTALL_DIR}/env/bin/python"
SALT_MINION="${INSTALL_DIR}/env/bin/salt-minion"
PID_FILE="${INSTALL_DIR}/var/run/salt-minion.pid"


start_daemon ()
{
    ${SALT_MINION} -c ${INSTALL_DIR}/etc/salt -d
}

stop_daemon ()
{
    kill `cat ${PID_FILE}`
    wait_for_status 1 20
    if [ $? -eq 1 ]; then
        kill -9 `cat ${PID_FILE}`
    fi
    rm -f ${PID_FILE}
}

daemon_status ()
{
    MINION_RUNNING=0
    if [ -f ${PID_FILE} ] && kill -0 `cat ${PID_FILE}` > /dev/null 2>&1; then
        MINION_RUNNING=1
    fi
    if [ ${MINION_RUNNING} -eq 1 ]; then
        return
    fi
    rm -f ${PID_FILE}
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
