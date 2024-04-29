#!/bin/sh

DNAME="pyLoad"

PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"
PYTHON="${SYNOPKG_PKGDEST}/env/bin/python"
PYLOAD="${SYNOPKG_PKGDEST}/share/pyload/pyLoadCore.py"
LOG_FILE="${SYNOPKG_PKGDEST}/var/pyload.log"
PID_FILE="${SYNOPKG_PKGDEST}/var/pyload.pid"
CFG_DIR="${SYNOPKG_PKGDEST}/var"

EXECUTE_SERVICE="${PYTHON} ${PYLOAD} --configdir=${CFG_DIR} --pidfile=${PID_FILE}"


start_daemon ()
{
    ${EXECUTE_SERVICE} --daemon  >> /dev/null 2>&1
}

stop_daemon ()
{
    ${EXECUTE_SERVICE} --quit  >> /dev/null 2>&1
}

daemon_status ()
{
    if [ "$(${EXECUTE_SERVICE} --status)" == "false" ]; then
        return 1;
    else
        return 0;
    fi
}


case $1 in
    start)
        if daemon_status; then
            echo "${DNAME} is already running" >> ${LOG_FILE}
            exit 0
        else
            echo "Starting ${DNAME} ..." >> ${LOG_FILE}
            start_daemon
            status=$?
            echo "Status = ${status}" >> ${LOG_FILE}
            exit ${status}
        fi
        ;;
    stop)
        if daemon_status; then
            echo "Stopping ${DNAME} ..." >> ${LOG_FILE}
            stop_daemon
            status=$?
            echo "Status = ${status}" >> ${LOG_FILE}
            exit ${status}
        else
            echo "${DNAME} is not running" >> ${LOG_FILE}
            exit 0
        fi
        ;;
    status)
        if daemon_status; then
            echo "${DNAME} is running"
            exit 0
        else
            echo "${DNAME} is not running"
            exit 1
        fi
        ;;
    *)
        exit 1
        ;;
esac
