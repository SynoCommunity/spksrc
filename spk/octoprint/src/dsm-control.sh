#!/bin/sh

# Package
PACKAGE="octoprint"
DNAME="OctoPrint"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PYTHON_DIR="/usr/local/python"
GIT_DIR="/usr/local/git"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/env/bin:${PYTHON_DIR}/bin:${GIT_DIR}/bin:${PATH}"
PYTHON="${INSTALL_DIR}/env/bin/python"
BUILDNUMBER="$(/bin/get_key_value /etc.defaults/VERSION buildnumber)"
OCTOPRINT="${INSTALL_DIR}/share/OctoPrint/run"
PID_FILE="${INSTALL_DIR}/var/octoprint.pid"
LOG_FILE="${INSTALL_DIR}/var/.octoprint/logs/octoprint.log"
PORT="8088"

SC_USER="sc-octoprint"
LEGACY_USER="octoprint"
USER="$([ "${BUILDNUMBER}" -ge "7321" ] && echo -n ${SC_USER} || echo -n ${LEGACY_USER})"


start_daemon ()
{
    insmod /lib/modules/usbserial.ko
    insmod /lib/modules/ftdi_sio.ko
    insmod /lib/modules/cdc-acm.ko

    # Create device
    test -e /dev/ttyACM0 || mknod /dev/ttyACM0 c 166 0
    chmod 777 /dev/ttyACM0

    su ${USER} -s /bin/sh -c "PATH=${PATH} ${PYTHON} ${OCTOPRINT} --daemon start --port=${PORT} --pid ${PID_FILE}"
}

stop_daemon ()
{
    kill `cat ${PID_FILE}`
    wait_for_status 1 20 || kill -9 `cat ${PID_FILE}`
    rm -f ${PID_FILE}

    rmmod /lib/modules/usbserial.ko
    rmmod /lib/modules/ftdi_sio.ko
    rmmod /lib/modules/cdc-acm.ko
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
