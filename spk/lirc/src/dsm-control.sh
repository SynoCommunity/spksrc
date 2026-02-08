#!/bin/sh

# Package
PACKAGE="lirc"
DNAME="LIRC"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
INSTALLER_SCRIPT=`dirname $0`/installer
PATH="${PATH}:${INSTALL_DIR}/bin:${PATH}"
DAEMON="${INSTALL_DIR}/sbin/lircd"
PID_FILE="${INSTALL_DIR}/var/lircd.pid"
CONF_FILE="${INSTALL_DIR}/etc/lirc/lircd.conf"
IREXEC="${INSTALL_DIR}/bin/irexec"
LIRCRC_FILE="${INSTALL_DIR}/etc/lirc/lircrc"
LOG_FILE="${INSTALL_DIR}/var/log/lircd"
VERSION_FILE="${INSTALL_DIR}/etc/DSM_VERSION"

SELECTED_LIRC_DRIVER=@driver@


load_unload_drivers ()
{
    case $1 in
        load)
            case $2 in
                mceusb)
                    insmod ${INSTALL_DIR}/lib/modules/lirc_dev.ko
                    insmod ${INSTALL_DIR}/lib/modules/lirc_${2}.ko
                ;;
                uirt)
                    insmod ${INSTALL_DIR}/lib/modules/lirc_dev.ko
                    insmod /lib/modules/usbserial.ko
                    insmod /lib/modules/ftdi_sio.ko
                    stty -F /dev/usb/ttyUSB0 1200 sane evenp parenb cs7 -crtscts
                    LIRC_STARTUP_PARAMS="--device=/dev/usb/ttyUSB0 --driver=usb_uirt_raw"
                ;;
                uirt2)
                    insmod ${INSTALL_DIR}/lib/modules/lirc_dev.ko
                    insmod /lib/modules/usbserial.ko
                    insmod /lib/modules/ftdi_sio.ko
                    stty -F /dev/usb/ttyUSB0 1200 sane evenp parenb cs7 -crtscts
                    LIRC_STARTUP_PARAMS="--device=/dev/usb/ttyUSB0 --driver=uirt2_raw"
                ;;
                irtoy)
                    # Not yet supported. Here for example only.
                ;;
                *)
                    # Not yet supported.
                ;;
            esac
        ;;
        unload)
            case $2 in
                mceusb)
                    rmmod ${INSTALL_DIR}/lib/modules/lirc_${2}.ko
                    rmmod ${INSTALL_DIR}/lib/modules/lirc_dev.ko
                ;;
                uirt|uirt2)
                    rmmod /lib/modules/ftdi_sio.ko
                    rmmod /lib/modules/usbserial.ko
                    rmmod ${INSTALL_DIR}/lib/modules/lirc_dev.ko
                ;;
                irtoy)
                    # Not yet supported. Here for example only.
                ;;
                *)
                    # Not yet supported.
                ;;
            esac
        ;;
    esac

}

start_daemon ()
{
    # Call function to load driver - validation happens inside
    load_unload_drivers load $SELECTED_LIRC_DRIVER

    ${DAEMON} ${LIRC_STARTUP_PARAMS} ${CONF_FILE} --pidfile=${PID_FILE} --logfile=${LOG_FILE}
    if [ -e ${LIRCRC_FILE} ]; then
        ${IREXEC} -d ${LIRCRC_FILE}
    fi
}

stop_daemon ()
{
    killall irexec >/dev/null 2>&1
    if daemon_status; then
        echo Stopping ${DNAME} ...
        kill `cat ${PID_FILE}`
        wait_for_status 1 20 || kill -9 `cat ${PID_FILE}`
    else
        echo ${DNAME} is not running
        exit 0
    fi

    test -e ${PID_FILE} || rm -f ${PID_FILE}

    # Call function to unload driver - validation happens inside
    load_unload_drivers unload $SELECTED_LIRC_DRIVER
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

check_dsm_version ()
{
    if [ -f ${VERSION_FILE} ]; then
        diff -qw /etc.defaults/VERSION ${VERSION_FILE} 2>&1 >/dev/null
        if [ $? -ne 0 ]; then
            echo -n "DSM version has changed, re-running driver setup..."
            . ${INSTALLER_SCRIPT}
            lirc_install_drivers ${SELECTED_LIRC_DRIVER}
            cp /etc.defaults/VERSION ${VERSION_FILE}
            echo done.
        fi
    else
        echo "First time starting, capturing DSM version"
        cp /etc.defaults/VERSION ${VERSION_FILE}
    fi
}

case $1 in
    start)
        if daemon_status; then
            echo ${DNAME} is already running
            exit 0
        else
            # Check if DSM was upgraded
            check_dsm_version
            echo Starting ${DNAME} ...
            start_daemon
            exit $?
        fi
        ;;
    stop)
            stop_daemon
            exit $?
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
        echo ${LOG_FILE}
        ;;
    driver)
        echo ${SELECTED_LIRC_DRIVER}
        ;;
    *)
        exit 1
        ;;
esac
