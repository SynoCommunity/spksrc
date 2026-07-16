#!/bin/sh

PACKAGE="dnsacme"
TARGET="/var/packages/${PACKAGE}/target"
VAR="/var/packages/${PACKAGE}/var"
ETC="/var/packages/${PACKAGE}/etc"
PID_FILE="${VAR}/${PACKAGE}.pid"
CONFIG="${ETC}/config.yaml"
LOG_FILE="${VAR}/${PACKAGE}.log"

daemon_pid()
{
    [ -r "${PID_FILE}" ] || return 1

    pid="$(cat "${PID_FILE}")"
    case "${pid}" in
        ''|*[!0-9]*) return 1 ;;
    esac

    kill -0 "${pid}" 2>/dev/null || return 1

    executable="$(readlink "/proc/${pid}/exe" 2>/dev/null)"
    expected_executable="$(readlink -f "${TARGET}/bin/dnsacme" 2>/dev/null)"
    [ -n "${expected_executable}" ] || return 1
    [ "${executable}" = "${expected_executable}" ] || return 1

    command_line="$(tr '\000' ' ' < "/proc/${pid}/cmdline" 2>/dev/null)"
    case "${command_line}" in
        *" synology daemon "*) ;;
        *) return 1 ;;
    esac

    printf '%s\n' "${pid}"
}

start_daemon()
{
    if daemon_pid >/dev/null; then
        echo "${PACKAGE} is already running"
        return 0
    fi

    mkdir -p "${VAR}" "${ETC}" || return 1
    chmod 700 "${VAR}" "${ETC}" || return 1
    rm -f "${PID_FILE}"

    umask 077
    DNSACME_CONFIG="${CONFIG}" nohup "${TARGET}/bin/dnsacme" synology daemon --config "${CONFIG}" \
        >>"${LOG_FILE}" 2>&1 &
    pid=$!
    printf '%s\n' "${pid}" > "${PID_FILE}"

    sleep 1
    if daemon_pid >/dev/null; then
        echo "${PACKAGE} started"
        return 0
    fi

    rm -f "${PID_FILE}"
    echo "${PACKAGE} failed to start"
    return 1
}

stop_daemon()
{
    pid="$(daemon_pid)" || {
        rm -f "${PID_FILE}"
        echo "${PACKAGE} is not running"
        return 0
    }

    kill "${pid}"
    timeout=20
    while kill -0 "${pid}" 2>/dev/null && [ "${timeout}" -gt 0 ]; do
        sleep 1
        timeout=$((timeout - 1))
    done

    if kill -0 "${pid}" 2>/dev/null; then
        echo "${PACKAGE} failed to stop"
        return 1
    fi

    rm -f "${PID_FILE}"
    echo "${PACKAGE} stopped"
}

case "$1" in
    start) start_daemon ;;
    stop) stop_daemon ;;
    restart)
        stop_daemon && start_daemon
        ;;
    status)
        daemon_pid >/dev/null
        ;;
    log)
        echo "${LOG_FILE}"
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status|log}" >&2
        exit 1
        ;;
esac
