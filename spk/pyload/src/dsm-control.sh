#!/bin/sh

PATH=/bin:/usr/bin

RUNAS=pyLoad

PYLDIR=/usr/local/pyLoad
PYLPY=$PYLDIR/share/pyLoad/pyLoadCore.py
PYLVAR=/usr/local/var/pyLoad

pylport=`grep -A6 'webinterface - "Webinterface"' $PYLVAR/pyload.conf | tail -n 1 | cut -d' ' -f6`

start_daemon ()
{
    # Launch pyLoad in the background.
    su - $RUNAS -s /bin/sh -c "PATH=$PATH:$PYLDIR/bin $PYLPY --configdir=$PYLVAR --daemon"
}

stop_daemon ()
{
    # Kill pyLoad.
    su - $RUNAS -s /bin/sh -c "$PYLPY --configdir=$PYLVAR --quit"
}

daemon_status ()
{
    [ `su $RUNAS -s /bin/sh -c "$PYLPY --configdir=$PYLVAR --status"` != False ]
}

run_in_console ()
{
    # Launch pyLoad in the foreground
    su - $RUNAS -s /bin/sh -c "PATH=$PATH:$PYLDIR/bin $PYLPY --configdir=$PYLVAR"
}

doConfig ()
{
    # Launch pyLoad and go through the setup assitant to set default values
    su - $RUNAS -s /bin/sh -c "PATH=$PATH:$PYLDIR/bin $PYLPY --configdir=$PYLVAR --autosetup" >$PYLVAR/install.log
}

doCgi ()
{
    if daemon_status
    then
        host=`echo $HTTP_HOST | cut -f1 -d:`
        echo Location: http://$host:$pylport/
        echo
        return 0
    else
        return 1
    fi
}

case $1 in
    start)
        if daemon_status
        then
            echo pyLoad is already running
            exit 0
        else
            echo Starting pyLoad ...
            start_daemon
            exit $?
        fi
        ;;
    stop)
        if daemon_status
        then
            echo Stopping pyLoad ...
            stop_daemon
            exit $?
        else
            echo pyLoad is not running
            exit 0
        fi
        ;;
    status)
        sed -e "s/^\(adminport\)=.*$/\1=$pylport/" -i /var/packages/pyLoad/INFO
        if daemon_status
        then
            echo pyLoad is running
            exit 0
        else
            echo pyLoad is not running
            exit 1
        fi
        ;;
    log)
        echo $PYLVAR/Logs/log.txt
        exit 0
        ;;
    console)
        run_in_console
        exit $?
        ;;
    config)
        doConfig
        exit $?
        ;;
    cgi)
        doCgi
        exit $?
        ;;
    *)
        exit 1
        ;;
esac
