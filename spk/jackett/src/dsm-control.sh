#!/bin/sh

# Package
PACKAGE="jackett"
DNAME="Jackett"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:${PATH}"
USER="${PACKAGE}"
USER_HOME="$(eval echo ~$USER)"
MONO_PATH="/usr/local/mono/bin"
MONO="${MONO_PATH}/mono"
JACKETT="${INSTALL_DIR}/share/${PACKAGE}/JackettConsole.exe"
COMMAND="env PATH=${MONO_PATH}:${PATH} LD_LIBRARY_PATH=${INSTALL_DIR}/lib ${MONO} -- --debug ${JACKETT}"
HOME_DIR="${INSTALL_DIR}/var"
PID_FILE="${USER_HOME}/jackett.pid"
LOG_FILE="${USER_HOME}/.config/Jackett/log.txt"

start_daemon ()
{
    export HOME=${USER_HOME} && start-stop-daemon -c ${USER} -Sqbmp ${PID_FILE} -x ${COMMAND} > /dev/null
    sleep 2
}

stop_daemon ()
{
    start-stop-daemon -Kqu ${USER} -p ${PID_FILE}
    wait_for_status 1 20 || start-stop-daemon -Kqs 9 -p ${PID_FILE}
}

daemon_status ()
{
    start-stop-daemon -Kqtu ${USER} -p ${PID_FILE}
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
        echo "${LOG_FILE}"
        exit 0
        ;;
    *)
        exit 1
        ;;
esac
