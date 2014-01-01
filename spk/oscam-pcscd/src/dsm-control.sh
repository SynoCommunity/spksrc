#!/bin/sh

# Package
PACKAGE="oscam"
DNAME="OSCam"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
RUNAS="root"
OSCAM="${INSTALL_DIR}/bin/oscam"
PID_FILE="${INSTALL_DIR}/var/oscam.pid"

start_daemon ()
{
    su - ${RUNAS} -c "LD_LIBRARY_PATH=${INSTALL_DIR}/lib ${INSTALL_DIR}/sbin/pcscd"  
    su - ${RUNAS} -c "LD_LIBRARY_PATH=${INSTALL_DIR}/lib ${OSCAM} -b -c /var/services/homes/oscam"
    sleep 1
    pidof oscam > ${PID_FILE}
}

stop_daemon ()
{
    killall oscam
    killall pcscd
    rm -f ${PID_FILE}
}

daemon_status ()
{
    if [ -f ${PID_FILE} ]; then
        return
    fi
    return 1
}

wait_for_status ()
{
    counter=$2
    while [ ${counter} -gt 0 ]; do
        daemon_status
        [ $? -eq $1 ] && break
        let counter=counter-1
        sleep 1
    done
}


case $1 in
    start)
        if daemon_status; then
            echo ${DNAME} is already running
            exit 0
        else
            echo Starting ${DNAME} ...
            start_daemon
            exit $?
        fi
        ;;
    stop)
        if daemon_status; then
            echo Stopping ${DNAME} ...
            stop_daemon
            exit $?
        else
            echo ${DNAME} is not running
            exit 0
        fi
        ;;
    restart)
        stop_daemon
        start_daemon
        exit $?
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
        logfile=$(cat /var/services/homes/oscam/oscam.conf | grep logfile | awk {'print $3'})
        echo $logfile
        exit 0
        ;;
    *)
        exit 1
        ;;
esac

