#!/bin/sh

# Display name
DNAME="${SYNOPKG_PKGNAME}"

# Source package specific variable and functions
SVC_SETUP="$(dirname "$0")/service-setup"
if [ -r "${SVC_SETUP}" ]; then
    . "${SVC_SETUP}"
fi

EJABBERD_PID_PATH="${PID_FILE}"
export EJABBERD_PID_PATH


start_daemon ()
{
    ${EJABBERD_CTL} start
    ${EJABBERD_CTL} started
}

stop_process ()
{
    [ -f "${PID_FILE}" ] || return 0
    pid="$(cat "${PID_FILE}" 2>/dev/null)"
    [ -n "${pid}" ] || {
        rm -f "${PID_FILE}"
        return 0
    }

    if kill -0 "${pid}" > /dev/null 2>&1; then
        kill -TERM "${pid}" > /dev/null 2>&1 || true
        counter="${SVC_WAIT_TIMEOUT:-20}"
        while [ "${counter}" -gt 0 ] && kill -0 "${pid}" > /dev/null 2>&1; do
            sleep 1
            counter=$((counter - 1))
        done
        kill -0 "${pid}" > /dev/null 2>&1 && kill -9 "${pid}" > /dev/null 2>&1 || true
    fi
    rm -f "${PID_FILE}"
}

stop_daemon ()
{
    # Use ejabberdctl for the graceful stop handshake; generic stop only
    # terminates the stored PID and bypasses ejabberd's node shutdown.
    # If the node is already down (stale PID or crashed node), do not run the
    # RPC handshake or wait for its full timeout; clean up the process instead.
    if ! ${EJABBERD_CTL} stop > /dev/null 2>&1; then
        echo "ejabberd node is not reachable; stopping any remaining process."
        stop_process
        return 0
    fi

    if ! ${EJABBERD_CTL} stopped > /dev/null 2>&1; then
        stop_process
        ${EJABBERD_CTL} stopped > /dev/null 2>&1 || true
    fi
    rm -f "${PID_FILE}"
}

daemon_status ()
{
    [ -f "${PID_FILE}" ] || return 1
    pid="$(cat "${PID_FILE}" 2>/dev/null)"
    if [ -z "${pid}" ] || ! kill -0 "${pid}" > /dev/null 2>&1; then
        rm -f "${PID_FILE}"
        return 1
    fi
    # A live PID is not enough after a crashed node: verify the node answers.
    ${EJABBERD_CTL} ping > /dev/null 2>&1
}


case "$1" in
    start)
        if daemon_status; then
            echo "${DNAME} is already running"
            exit 0
        else
            stop_process
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
            stop_process
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
        if [ -n "${LOG_FILE}" ] && [ -r "${LOG_FILE}" ]; then
            # Shorten long logs to last 100 lines
            TEMP_LOG_FILE="${SYNOPKG_PKGVAR}/${SYNOPKG_PKGNAME}_temp.log"
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
