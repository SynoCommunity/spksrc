#!/bin/sh

DNAME="ZeroTier"
PACKAGE="zerotier"
ZEROTIER="${SYNOPKG_PKGDEST}/bin/zerotier-one"
PID_FILE="/var/lib/zerotier-one/zerotier-one.pid"

start_daemon ()
{
    sleep 1
    insmod /lib/modules/tun.ko
    ${SYNOPKG_PKGDEST}/bin/zerotier-one -d ;
    echo $! >> ${PID_FILE}
}

stop_daemon ()
{
    pkill zerotier-one
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

case "$1" in
  start)
    if ( pidof zerotier-one ); then
        exit 0
    else
        start_daemon
    fi
    ;;
  stop)
    if ( pidof zerotier-one ); then
        stop_daemon
    else
        exit 0
    fi
    ;;
  status)
    if ( pidof zerotier-one ); then
        exit 0
    else
        exit 1
    fi
    ;;
  *)
    exit 1
    ;;
esac

