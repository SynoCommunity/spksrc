#!/bin/sh

# Package
PACKAGE="sabnzbd"
DNAME="SABnzbd"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PYTHON_DIR="/usr/local/python"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
RUNAS="sabnzbd"
PYTHON="${INSTALL_DIR}/env/bin/python"
SABNZBD="${INSTALL_DIR}/share/SABnzbd/SABnzbd.py"
CFG_FILE="${INSTALL_DIR}/var/config.ini"
LOG_FILE="${INSTALL_DIR}/var/logs/sabnzbd.log"
PID_FILES="${INSTALL_DIR}/var/sabnzbd-*.pid"


start_daemon ()
{
    su - ${RUNAS} -c "PATH=${PATH} ${PYTHON} ${SABNZBD} -f ${CFG_FILE} --pid ${INSTALL_DIR}/var/ -d"
}

stop_daemon ()
{
    for pid_file in ${PID_FILES}; do
        kill `cat ${pid_file}`
    done
    wait_for_status 1 20
    rm -f ${PID_FILES}
}

daemon_status ()
{
    for pid_file in ${PID_FILES}; do
        if [ -f ${pid_file} ] && [ -d /proc/`cat ${pid_file}` ]; then
            return 0
        fi
    done
    return 1
}

wait_for_status()
{
    counter=$2
    while [ ${counter} -gt 0 ]; do
        daemon_status
        [ $? -eq $1 ] && break
        let counter=counter-1
        sleep 1
    done
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
    log)
        echo ${LOG_FILE}
        exit 0
        ;;
    *)
        exit 1
        ;;
esac

