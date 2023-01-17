#!/bin/sh

# Package
PACKAGE="pyload"
DNAME="pyLoad"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PYTHON_DIR="/usr/local/python"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:${PATH}"
PYTHON="${INSTALL_DIR}/env/bin/python"
BUILDNUMBER="$(/bin/get_key_value /etc.defaults/VERSION buildnumber)"
PYLOAD="${INSTALL_DIR}/share/pyload/pyLoadCore.py"
LOG_FILE="${INSTALL_DIR}/etc/Logs/log.txt"
PID_FILE="${INSTALL_DIR}/var/pyload.pid"

SC_USER="sc-pyload"
LEGACY_USER="pyload"
USER="$([ "${BUILDNUMBER}" -ge "7321" ] && echo -n ${SC_USER} || echo -n ${LEGACY_USER})"


start_daemon ()
{
    su ${USER} -s /bin/sh -c "PATH=${PATH} ${PYTHON} ${PYLOAD} --pidfile=${PID_FILE} --daemon"
}

stop_daemon ()
{
    su ${USER} -s /bin/sh -c "PATH=${PATH} ${PYTHON} ${PYLOAD} --pidfile=${PID_FILE} --quit"
}

daemon_status ()
{
    su ${USER} -s /bin/sh -c "PATH=${PATH} ${PYTHON} ${PYLOAD} --pidfile=${PID_FILE} --status" > /dev/null
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
            exit 1
        fi
        ;;
    log)
        if [ -f "${LOG_FILE}" ]; then
            echo "${LOG_FILE}"
        else
            exit 1
        fi
        ;;
    *)
        exit 1
        ;;
esac
