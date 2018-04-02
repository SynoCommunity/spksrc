#!/bin/sh

set -x

DNAME=dnscrypt-proxy
# USER="root"
DNSCRYPT_PROXY=/usr/local/bin/dnscrypt-proxy
CFG_FILE=/usr/local/etc/dnscrypt-proxy/dnscrypt-proxy.toml
PID_FILE=/usr/local/run/dnscrypt-proxy.pid

start ()
{
    # su ${USER} -s /bin/sh -c "PATH=${PATH} ${DNSCRYPT_PROXY} --config ${CFG_FILE} & echo $! > ${PID_FILE}"
    ${DNSCRYPT_PROXY} --config ${CFG_FILE} & echo $! > ${PID_FILE}
}

stop ()
{
    kill "$(cat ${PID_FILE})"
    wait_for_status 1 20 || kill -9 "$(cat ${PID_FILE})"
    rm -f ${PID_FILE}
}

status ()
{
    if [ -f ${PID_FILE} ] && kill -0 "$(cat ${PID_FILE})" > /dev/null 2>&1; then
        return
    fi
    rm -f ${PID_FILE}
    return 1
}

wait_for_status ()
{
    counter=$2
    while [ "${counter}" -gt 0 ]; do
        daemon_status
        [ $? -eq "$1" ] && return
        let counter=counter-1
        sleep 1
    done
    return 1
}

case $1 in
    start)
        if status; then
            echo ${DNAME} is already running
            exit 0
        else
            echo Starting ${DNAME} ...
            start
            exit $?
        fi
        ;;
    stop)
        if status; then
            echo Stopping ${DNAME} ...
            stop
            exit $?
        else
            echo ${DNAME} is not running
            exit 0
        fi
        ;;
    status)
        if status; then
            echo ${DNAME} is running
            exit 0
        else
            echo ${DNAME} is not running
            exit 1
        fi
        ;;
    *)
        exit 1
        ;;
esac
