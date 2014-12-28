#!/bin/sh

# Package
PACKAGE="postgresql"
DNAME="PostgreSQL"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:${PATH}"
PGUSER="postgres"

PGLOG="$INSTALL_DIR/var/server.log"
PGCTL="${INSTALL_DIR}/bin/pg_ctl"
DAEMON="${INSTALL_DIR}/bin/postmaster"
PGDATA="${INSTALL_DIR}/var/pgsqldata"
SERVER_PID_FILE="${INSTALL_DIR}/var/postmaster.pid"

start_daemon ()
{
    su - $PGUSER -c "$DAEMON -D '$PGDATA' &" >>$PGLOG 2>&1
}

stop_daemon ()
{
    su - $PGUSER -c "$PGCTL stop -D '$PGDATA' -s -m fast"
}

daemon_status ()
{
    if [ -f ${SERVER_PID_FILE} ] && kill -0 `cat ${SERVER_PID_FILE}` > /dev/null 2>&1; then
        return
    fi
    rm -f ${SERVER_PID_FILE}
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
        echo ${PGLOG}
        exit 0
        ;;
    *)
        exit 1
        ;;
esac
