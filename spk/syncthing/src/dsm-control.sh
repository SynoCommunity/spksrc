#!/bin/sh

# Package
PACKAGE="syncthing"
DNAME="Syncthing"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:${PATH}"
USER="syncthing"
SYNCTHING="${INSTALL_DIR}/bin/syncthing"
CONFIG_DIR="${INSTALL_DIR}/var/"


start_daemon ()
{
    start-stop-daemon -b -o -c ${USER} -S -u ${USER} -x env HOME=${CONFIG_DIR} ${SYNCTHING} -- --home ${CONFIG_DIR}
    #su - ${USER} -c "PATH=${PATH} ${SYNCTHING} --home ${CONFIG_DIR}"
}

stop_daemon ()
{
    # Kill the application
    #kill `ps w | grep ${PACKAGE} | grep -v -E 'stop|grep' | awk '{print $1}'`
    start-stop-daemon -o -c ${USER} -K -u ${USER} -x ${SYNCTHING} -- --home ${CONFIG_DIR}
}

daemon_status ()
{
   if [ `ps w | grep ${PACKAGE} | grep -v -E 'status|grep' | wc -l` -gt 0 ]
    then
        return 0
    else
        return 1
    fi
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
