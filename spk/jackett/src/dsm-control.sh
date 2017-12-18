#!/bin/sh

# Package
PACKAGE="jackett"
DNAME="Jackett"

#BUILDNUMBER="$(/bin/get_key_value /etc.defaults/VERSION buildnumber)"
SC_USER="sc-jackett"
LEGACY_USER="jackett"
#USER="$([ "${BUILDNUMBER}" -ge "7321" ] && echo -n ${SC_USER} || echo -n ${LEGACY_USER})"
# always use legacy user for now
USER=${LEGACY_USER}

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
MONO_PATH="/usr/local/mono/bin"
PATH="${INSTALL_DIR}/bin:${MONO_PATH}:${PATH}"
MONO="${MONO_PATH}/mono"
JACKETT="${INSTALL_DIR}/share/${PACKAGE}/JackettConsole.exe"
HOME_DIR="${INSTALL_DIR}/var"
LOG_FILE_JACKETT="${HOME_DIR}/.config/Jackett/log.txt"
LOG_FILE_STDERR="${HOME_DIR}/${PACKAGE}-stderr.log"
PID_FILE="${HOME_DIR}/${PACKAGE}.pid"
COMMAND="env HOME=${HOME_DIR} PATH=${PATH} LD_LIBRARY_PATH=${INSTALL_DIR}/lib ${MONO} --debug ${JACKETT} --PIDFile ${PID_FILE}"

SC_USER="sc-jackett"
LEGACY_USER="jackett"
USER="$([ "${BUILDNUMBER}" -ge "7321" ] && echo -n ${SC_USER} || echo -n ${LEGACY_USER})"


start_daemon ()
{
    start-stop-daemon -S -u ${USER} -c ${USER} -b -p ${PID_FILE} -a /bin/sh -- -c "${COMMAND} 2>${LOG_FILE_STDERR} | logger --id ${PACKAGE}"
    sleep 2 # give jackett some time to write the pid file
}

stop_daemon ()
{
    start-stop-daemon -Kqu ${USER} -p ${PID_FILE}
    wait_for_status 1 20 || start-stop-daemon -Kqs 9 -p ${PID_FILE}
}

daemon_status ()
{
    if [ -n "${PID_FILE}" -a -r "${PID_FILE}" ]; then
        if kill -0 $(cat "${PID_FILE}") > /dev/null 2>&1; then
            return
        fi
        rm -f "${PID_FILE}" > /dev/null
    fi
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
        echo "${LOG_FILE_JACKETT}"
        exit 0
        ;;
    *)
        exit 1
        ;;
esac

