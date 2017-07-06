#!/bin/sh

# Package
PACKAGE="radarr"
DNAME="Radarr"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:${PATH}"
USER="${PACKAGE}"
PID_FILE="${INSTALL_DIR}/var/.config/Radarr/nzbdrone.pid"
INSTALL_LOG="${INSTALL_DIR}/var/install.log"
MONO_PATH="/usr/local/mono/bin"
MONO="${MONO_PATH}/mono"
RADARR="${INSTALL_DIR}/share/Radarr/Radarr.exe"
COMMAND="env PATH=${MONO_PATH}:${PATH} LD_LIBRARY_PATH=${INSTALL_DIR}/lib ${MONO} -- --debug ${RADARR}"

start_daemon ()
{
    start-stop-daemon -c ${USER} -S -q -b -N 10 -x ${COMMAND} > /dev/null
    sleep 2
}

stop_daemon ()
{
    start-stop-daemon -K -q -u ${USER} -p ${PID_FILE}
    wait_for_status 1 20 || start-stop-daemon -K -s 9 -q -p ${PID_FILE}
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
	echo "${INSTALL_LOG}"
        exit 0
        ;;
    *)
        exit 1
        ;;
esac
