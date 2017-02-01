#!/bin/sh

# Package
PACKAGE="fengoffice"
DNAME="Feng Office"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
WEB_DIR="/var/services/web"
PATH="${INSTALL_DIR}/bin:${PATH}"
BUILDNUMBER="$(/bin/get_key_value /etc.defaults/VERSION buildnumber)"
USER="$([ "${BUILDNUMBER}" -ge "4418" ] && echo -n http || echo -n nobody)"
FENGOFFICE="${INSTALL_DIR}/bin/fengoffice.sh"
PID_FILE="${INSTALL_DIR}/var/fengoffice.pid"


start_daemon ()
{
    start-stop-daemon -S -q -m -b -N 10 -x ${FENGOFFICE} -c ${USER} -u ${USER} -p ${PID_FILE} > /dev/null
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
        exit 1
        ;;
    *)
        exit 1
        ;;
esac
