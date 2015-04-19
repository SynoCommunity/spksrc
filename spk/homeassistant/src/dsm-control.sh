#!/bin/sh

# Package
PACKAGE="homeassistant"
DNAME="Home Assistant"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PYTHON_DIR="/usr/local/python3"
PYTHONPATH="${INSTALL_DIR}/share/${PACKAGE}"
PATH="${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:${PATH}"
USER="homeassistant"
PYTHON="${INSTALL_DIR}/env/bin/python3"

CONFIG_DIR="${INSTALL_DIR}/etc/"
LOG_DIR="${INSTALL_DIR}/var/"

LOG_FILE="${LOG_DIR}/home-assistant.log"
PID_FILE="${LOG_DIR}/homeassistant.pid"

RUN_CMD="${PYTHON}"
RUN_ARGS="-m ${PACKAGE} -c ${CONFIG_DIR} --open-ui"

start_daemon ()
{
    start-stop-daemon -b -o -c ${USER} -S -u ${USER} -m -p ${PID_FILE} -x env PYTHONPATH=${PYTHONPATH} ${RUN_CMD} -- ${RUN_ARGS}
}

stop_daemon ()
{
    start-stop-daemon -o -c ${USER} -K -u ${USER} -p ${PID_FILE} -x ${RUN_CMD}
    wait_for_status 1 20 || start-stop-daemon -K -s 9 -q -p ${PID_FILE}
}

daemon_status ()
{
    start-stop-daemon -K -q -t -u ${USER} -p ${PID_FILE}
    [ $? -eq 0 ] || return 1
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
		exit 0
        ;;
    *)
        exit 1
        ;;
esac
