#!/bin/sh

# Package
PACKAGE="bazarr"
DNAME="Bazarr"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:${PATH}"
BAZARR_DIR="${INSTALL_DIR}/share/bazarr"
PID_FILE="${INSTALL_DIR}/var/bazarr.pid"
SH_PATH=/bin/sh

USER="sc-bazarr"

start_daemon ()
{
    start-stop-daemon -S -q -m -b -N 10 -p "${PID_FILE}" -x "${SH_PATH}"  -- \
        -c "source \"${INSTALL_DIR}/bin/settings.sh\" \
        && pushd \"${BAZARR_DIR}\" \
        && mkdir -p \"${BAZARR_DIR}/var\" \
        && python bazarr.py >>\"${BAZARR_DIR}/var/bazarr.log\" 2>&1"
}

stop_daemon ()
{
    curl http://127.0.0.1:6767/shutdown || echo "Failed invoking smooth shutdown procedure";
    start-stop-daemon -u "${USER}" -K -q -p "${PID_FILE}" -x "${SH_PATH}"
    wait_for_status 1 20 || start-stop-daemon -K -s 9 -q -p "${PID_FILE}" -x "${SH_PATH}"
}

daemon_status ()
{
    start-stop-daemon -u "${USER}" -K -q -t -p "${PID_FILE}" -x "${SH_PATH}"
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
