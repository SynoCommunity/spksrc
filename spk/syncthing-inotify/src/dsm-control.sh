#!/bin/sh

# Package
PACKAGE="syncthing-inotify"
DNAME="Syncthing-Inotify"

# Syncthing folders
SYNCTHING_DIR="/usr/local/syncthing"
SYNCTHING_CONFIG_DIR="${SYNCTHING_DIR}/var"

# Syncthing-Inotify reads Syncthing's config and uses its busybox and user account
PATH="${SYNCTHING_DIR}/bin:${PATH}"
USER="syncthing"
INOTIFY_OPTIONS="-home=${SYNCTHING_CONFIG_DIR}"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
INOTIFY="${INSTALL_DIR}/bin/syncthing-inotify"
CONFIG_DIR="${INSTALL_DIR}/var"

# Read additional startup options from /usr/local/syncthing-inotify/var/options.conf
if [ -f ${CONFIG_DIR}/options.conf ]; then
	source ${CONFIG_DIR}/options.conf
fi

start_daemon ()
{
    start-stop-daemon -b -o -c ${USER} -S -u ${USER} -x env HOME=${SYNCTHING_CONFIG_DIR} ${INOTIFY} -- ${INOTIFY_OPTIONS}
}

stop_daemon ()
{
    start-stop-daemon -o -c ${USER} -K -u ${USER} -x ${INOTIFY}
    wait_for_status 1 20 || start-stop-daemon -K -s 9 -q -x ${INOTIFY}
}

daemon_status ()
{
    start-stop-daemon -K -q -t -u ${USER} -x ${INOTIFY}
    [ $? -eq 0 ] || return 1
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
