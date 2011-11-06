#!/bin/sh

PATH=/bin:/sbin:/usr/bin

DAEMON="/usr/local/openvpn/bin/openvpn"
CONFIG_DIR="/usr/local/var/openvpn"
CONF_FILE="/usr/local/var/openvpn/client.conf"
DAEMONARG="--daemon openvpn"
PIDFILE="/usr/local/var/openvpn/openvpn.pid"
LOG_FILE="/usr/local/var/openvpn/log/openvpn.log"


test -x $DAEMON || exit 0
test -d $CONFIG_DIR || exit 0

daemon_status ()
{
    if [ -f $PIDFILE ] 
    then
        if [ -d /proc/`cat $PIDFILE` ]
        then
            return 0
        else
            # PID file exists, but no process has this PID. 
            rm $PIDFILE
        fi
    fi
    return 1
}

start_daemon ()
{
    # Make sure IP forwarding is enabled
    echo 1 > /proc/sys/net/ipv4/ip_forward

    # Make device if not present (not devfs)
    if [ ! -c /dev/net/tun ]
    then
        # Make /dev/net directory if needed
        if [ ! -d /dev/net ]
        then
            mkdir -m 755 /dev/net
        fi
        mknod /dev/net/tun c 10 200
    fi

    # Make sure the tunnel driver is loaded
    if !(lsmod | grep -q "^tun")
    then
        insmod /lib/modules/tun.ko
    fi

    echo -n "Starting openvpn, please wait ... "
    $DAEMON --writepid $PIDFILE --config $CONF_FILE $DAEMONARG --cd $CONFIG_DIR
    
    # Wait until transmission is ready (race condition here).
    counter=5
    while [ $counter -gt 0 ]
    do
        daemon_status && break
        let counter=counter-1
        sleep 1
    done
	
	sleep 5
    ifconfig
    echo "Done."
}

stop_daemon ()
{
	echo -n "Stopping openvpn daemon, please wait ... "

    # Kill openvpn.
	PID=`cat $PIDFILE`
	kill $PID
	rm $PIDFILE

    # Wait until openvpn is really dead (may take some time).
    counter=20
    while [ $counter -gt 0 ]
        do
        daemon_status || break
        let counter=counter-1
        sleep 1
    done
    
	sleep 5
	ifconfig
	echo "Done."
}

reload_daemon ()
{
    kill -s HUP `cat $PIDFILE`
}


case "$1" in
    start)
        if daemon_status
        then
            echo -n "openvpn daemon is already running"
            exit 0
        else
            start_daemon
            exit $?
        fi
        ;;
    stop)
        if daemon_status
        then
			stop_daemon
            exit 0
        else
            exit $?
        fi
        ;;
    restart)
        stop_daemon
        start_daemon
        exit $?
        ;;
    reload)
        if daemon_status
        then
            reload_daemon
        fi
        exit $?
        ;;
    status)
        if daemon_status
        then
            echo Running
            exit 0
        else
            echo Not running
            exit 1
        fi
        ;;
    log)
        echo "${LOG_FILE}"
        exit 0
        ;;
    *) 
        echo "Usage: $0 {start|stop|restart|reload|status|log}" >&2 
        exit 1 
        ;; 
esac
