#!/bin/sh

# Display name
DNAME="${SYNOPKG_PKGNAME}"

# Source package specific variable and functions
SVC_SETUP=$(dirname $0)/service-setup
if [ -r "${SVC_SETUP}" ]; then
    . "${SVC_SETUP}"
fi

EJABBERD_PID_PATH=${PID_FILE}
export EJABBERD_PID_PATH


start_daemon ()
{
    ${EJABBERD_CTL} start
    ${EJABBERD_CTL} started
}

stop_daemon ()
{
    ${EJABBERD_CTL} stop
    wait_for_status 1 20 || kill -9 $(cat "${PID_FILE}")
    rm -f ${PID_FILE} 
    ${EJABBERD_CTL} stopped
}

daemon_status ()
{
    if [ -f ${PID_FILE} ] && kill -0 $(cat "${PID_FILE}") > /dev/null 2>&1; then
        return
    fi
    rm -f "${PID_FILE}" > /dev/null
    return 1
}

wait_for_status ()
{
    counter=$2
    while [ ${counter} -gt 0 ]; do
        daemon_status
        [ $? -eq $1 ] && return
        counter=$((counter-1))
        sleep 1
    done
    return 1
}


case $1 in
    start)
        if daemon_status; then
            echo "${DNAME} is already running"
            exit 0
        else
            echo "Starting ${DNAME} ..."
            start_daemon
            exit $?
        fi
        ;;
    stop)
        if daemon_status; then
            echo "Stopping ${DNAME} ..."
            stop_daemon
            exit $?
        else
            echo "${DNAME} is not running"
            exit 0
        fi
        ;;
    status)
        if daemon_status; then
            echo "${DNAME} is running"
            exit 0
        else
            echo "${DNAME} is not running"
            exit 3
        fi
        ;;
    log)
        if [ -n "${LOG_FILE}" -a -r "${LOG_FILE}" ]; then
            # Shorten long logs to last 100 lines
            TEMP_LOG_FILE="${SYNOPKG_PKGDEST}/var/${SYNOPKG_PKGNAME}_temp.log"
            # Clear any previous log
            echo "Full log: ${LOG_FILE}" > "${TEMP_LOG_FILE}"
            tail -n100 "${LOG_FILE}" >> "${TEMP_LOG_FILE}"
            echo "${TEMP_LOG_FILE}"
        fi
        exit 0
        ;;
    *)
        exit 1
        ;;
esac
