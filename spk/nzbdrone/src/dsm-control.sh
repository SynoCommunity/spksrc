#!/bin/sh

# Package
PACKAGE="nzbdrone"
DNAME="NzbDrone"
INSTALL_DIR="/usr/local/${PACKAGE}"
INSTALL_LOG="${INSTALL_DIR}/var/install.log"
PATH="${INSTALL_DIR}/bin:${PATH}"
USER="nzbdrone"
PID_FILE="${INSTALL_DIR}/var/${PACKAGE}.pid"
MONO_PATH="/usr/local/mono/bin"
MONO="${MONO_PATH}/mono"
NZBDRONE="${INSTALL_DIR}/share/NzbDrone/NzbDrone.exe"
COMMAND="env PATH=${MONO_PATH}:${PATH} LD_LIBRARY_PATH=${INSTALL_DIR}/lib ${MONO} ${NZBDRONE}"

start_daemon ()
{
    start-stop-daemon -S -q -m -b -N 10 -x ${COMMAND} -c ${USER} -u ${USER} -p ${PID_FILE} > /dev/null
}

stop_daemon ()
{
    start-stop-daemon -K -q -u ${USER} -p ${PID_FILE}
    wait_for_status 1 20 || start-stop-daemon -K -s 9 -q -p ${PID_FILE}
}

daemon_status ()
{
    ps | grep nzbdrone | grep -v grep | awk "{ print \$1 }" > ${PID_FILE}
    sleep 1
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
	echo "${INSTALL_LOG}"
        exit 0
        ;;
    *)
        exit 1
        ;;
esac
