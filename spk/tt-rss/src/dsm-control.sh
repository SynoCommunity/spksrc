#!/bin/sh

# Package
PACKAGE="tt-rss"
DNAME="Tiny Tiny RSS"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
WEB_DIR="/var/services/web"
PATH="${INSTALL_DIR}/bin:${PATH}"
USER="$([ $(/bin/get_key_value /etc.defaults/VERSION buildnumber) -ge 4418 ] && echo -n http || echo -n nobody)"
PHP="$([ $(/bin/get_key_value /etc.defaults/VERSION buildnumber) -ge 7135 ] && echo -n /usr/local/bin/php56 || echo -n /usr/bin/php)"
TTRSS="${WEB_DIR}/${PACKAGE}/update.php"
PID_FILE="${INSTALL_DIR}/var/tt-rss.pid"


start_daemon ()
{
    start-stop-daemon -S -q -m -b -N 10 -x ${PHP} ${TTRSS} -c ${USER} -u ${USER} -p ${PID_FILE} \
      -- --daemon 2> /dev/null
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
