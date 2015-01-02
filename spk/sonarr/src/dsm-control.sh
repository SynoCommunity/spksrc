#!/bin/sh

# Package
PACKAGE="nzbdrone"
DNAME="Sonarr"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:${PATH}"
USER="${PACKAGE}"
USER_HOME="$(eval echo ~$USER)"
PID_FILE="${USER_HOME}/.config/NzbDrone/nzbdrone.pid"
INSTALL_LOG="${INSTALL_DIR}/var/install.log"
MONO_PATH="/usr/local/mono/bin"
MONO="${MONO_PATH}/mono"
SONARR="${INSTALL_DIR}/share/NzbDrone/NzbDrone.exe"
COMMAND="env PATH=${MONO_PATH}:${PATH} LD_LIBRARY_PATH=${INSTALL_DIR}/lib ${MONO} ${SONARR}"

start_daemon ()
{
    start-stop-daemon -S -q -b -N 10 -x ${COMMAND} -c ${USER} > /dev/null
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
