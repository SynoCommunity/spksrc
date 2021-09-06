#!/bin/sh

# Package
PACKAGE="salt-master"
DNAME="Salt Master"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PYTHON_DIR="/usr/local/python"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:${PATH}"
PYTHON="${INSTALL_DIR}/env/bin/python"
SALT_MASTER="${INSTALL_DIR}/env/bin/salt-master"
SALT_API="${INSTALL_DIR}/env/bin/salt-api"
MASTER_PID_FILE="${INSTALL_DIR}/var/run/salt-master.pid"
API_PID_FILE="${INSTALL_DIR}/var/run/salt-api.pid"
API_LOG_FILE="${INSTALL_DIR}/var/log/salt/api"


start_daemon ()
{
    ${SALT_MASTER} --config-dir=${INSTALL_DIR}/etc --daemon
    ${SALT_API} --config-dir=${INSTALL_DIR}/etc --log-file ${API_LOG_FILE} --daemon 
}

stop_daemon ()
{
    kill `cat ${MASTER_PID_FILE}`
    kill `pidof salt-api`
    wait_for_status 1 20
    if [ $? -eq 1 ]; then
        kill -9 `cat ${MASTER_PID_FILE}`
        kill -9 `pidof salt-api`
    fi
    rm -f ${MASTER_PID_FILE} ${API_PID_FILE}
}

daemon_status ()
{
    MASTER_RUNNING=0
    if [ -f ${MASTER_PID_FILE} ] && kill -0 `cat ${MASTER_PID_FILE}` > /dev/null 2>&1; then
        MASTER_RUNNING=1
    fi
    API_RUNNING=0
    if [ -f ${API_PID_FILE} ] && kill -0 `cat ${API_PID_FILE}` > /dev/null 2>&1; then
        API_RUNNING=1
    fi
    if [ ${MASTER_RUNNING} -eq 1 -o ${API_RUNNING} -eq 1 ]; then
        return
    fi
    rm -f ${MASTER_PID_FILE} ${API_PID_FILE}
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
