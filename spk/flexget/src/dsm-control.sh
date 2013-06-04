#!/bin/sh

# Package
PACKAGE="flexget"
DNAME="FlexGet"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PYTHON_DIR="/usr/local/python"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:${PATH}"
USER="flexget"
PYTHON="${INSTALL_DIR}/env/bin/python"
FLEXGET="${INSTALL_DIR}/env/bin/flexget-webui"
CFG_FILE="${INSTALL_DIR}/var/config.yml"
PID_FILE="${INSTALL_DIR}/var/.config-lock"
LOG_FILE="${INSTALL_DIR}/var/flexget.log"


start_daemon ()
{
    start-stop-daemon -S -q -x ${FLEXGET} -c ${USER} -u ${USER} -p ${PID_FILE} \
      -- -d -c ${CFG_FILE} --logfile ${LOG_FILE} --port 8290 2> /dev/null
}

stop_daemon ()
{
    start-stop-daemon -K -q -u ${USER} -p ${PID_FILE}
    wait_for_status 1 20 || start-stop-daemon -K -s 9 -q -u ${USER} -p ${PID_FILE}
}

daemon_status ()
{
    start-stop-daemon -K -q -t -u ${USER} -p ${PID_FILE}
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
