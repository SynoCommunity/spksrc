#!/bin/sh

# Package
PACKAGE="saltpad"
DNAME="SaltPad"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PYTHON_DIR="/usr/local/python"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:${PATH}"
PYTHON="${INSTALL_DIR}/env/bin/python"
BUILDNUMBER="$(/bin/get_key_value /etc.defaults/VERSION buildnumber)"
UWSGI="${PYTHON_DIR}/bin/uwsgi"
PID_FILE="${INSTALL_DIR}/var/saltpad.pid"
LOG_FILE="${INSTALL_DIR}/var/uwsgi.log"

SC_USER="sc-saltpad"
LEGACY_USER="saltpad"
GROUP="nobody"
USER="$([ "${BUILDNUMBER}" -ge "7321" ] && echo -n ${SC_USER} || echo -n ${LEGACY_USER})"


start_daemon ()
{
    ${UWSGI} --die-on-term --http :8283 --virtualenv ${INSTALL_DIR}/env --chdir ${INSTALL_DIR}/share/saltpad/saltpad --pythonpath .. \
        --module "saltpad.app:app" --master --processes 2 --pidfile ${PID_FILE} --daemonize ${LOG_FILE} --uid ${USER} --gid ${GROUP}
}

stop_daemon ()
{
    kill `cat ${PID_FILE}`
    wait_for_status 1 20 || kill -9 `cat ${PID_FILE}`
    rm -f ${PID_FILE}
}

daemon_status ()
{
    if [ -f ${PID_FILE} ] && kill -0 `cat ${PID_FILE}` > /dev/null 2>&1; then
        return
    fi
    rm -f ${PID_FILE}
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
        echo ${LOG_FILE}
        ;;
    *)
        exit 1
        ;;
esac
