#!/bin/sh

# Package
PACKAGE="nzbhydra"
DNAME="NZBHydra"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PYTHON_DIR="/usr/local/python"
GIT_DIR="/usr/local/git"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:${GIT_DIR}/bin:${PATH}"
USER="nzbhydra"
PYTHON="${INSTALL_DIR}/env/bin/python"
NZBHYDRA="${INSTALL_DIR}/share/nzbhydra/nzbhydra.py"
PID_FILE="${INSTALL_DIR}/var/nzbhydra.pid"
LOG_FILE="${INSTALL_DIR}/var/nzbhydra.log"
DB_FILE="${INSTALL_DIR}/var/nzbhydra.db"
CONF_FILE="${INSTALL_DIR}/var/settings.cfg"


start_daemon ()
{
    su ${USER} -c "PATH=${PATH} ${PYTHON} ${NZBHYDRA} --daemon --nobrowser --database ${DB_FILE} --config ${CONF_FILE} --logfile ${LOG_FILE} --pidfile ${PID_FILE} "
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
