#!/bin/sh

# Package
PACKAGE="couchpotatoserver-custom"
DNAME="CouchPotato Custom"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PYTHON_DIR="/usr/local/python"
GIT_DIR="/usr/local/git"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:${GIT_DIR}/bin:${PATH}"
USER="couchpotatoserver-custom"
PYTHON="${INSTALL_DIR}/env/bin/python"
COUCHPOTATOSERVER="${INSTALL_DIR}/var/CouchPotatoServer/CouchPotato.py"
CFG_FILE="${INSTALL_DIR}/var/settings.conf"
PID_FILE="${INSTALL_DIR}/var/couchpotatoserver-custom.pid"
LOG_FILE="${INSTALL_DIR}/var/logs/CouchPotato.log"


start_daemon ()
{
    su - ${USER} -c "PATH=${PATH} ${PYTHON} ${COUCHPOTATOSERVER} --daemon --pid_file ${PID_FILE} --config_file ${CFG_FILE}"
}

stop_daemon ()
{
    kill `cat ${PID_FILE}`
    wait_for_status 1 20 || kill -9 `cat ${PID_FILE}`
    rm -f ${PID_FILE}
}

daemon_status ()
{
    if [ -f ${PID_FILE} ] && kill -0 `cat ${PID_FILE}` > /dev/null 2>&1; then
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
        else
            echo Starting ${DNAME} ...
            start_daemon
        fi
        ;;
    stop)
        if daemon_status; then
            echo Stopping ${DNAME} ...
            stop_daemon
        else
            echo ${DNAME} is not running
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
    log)
        echo ${LOG_FILE}
        ;;
    *)
        exit 1
        ;;
esac
