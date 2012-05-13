#!/bin/sh

# Package
PACKAGE="debian-chroot"
DNAME="Debian Chroot"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
CHROOTTARGET="${INSTALL_DIR}/var/chroottarget"
PATH="${INSTALL_DIR}/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/syno/sbin:/usr/syno/bin"


start_daemon ()
{
    mount --bind /proc ${CHROOTTARGET}/proc
    mount --bind /dev/pts ${CHROOTTARGET}/dev/pts
    mount --bind /sys ${CHROOTTARGET}/sys
}

stop_daemon ()
{
    umount ${CHROOTTARGET}/proc
    umount ${CHROOTTARGET}/dev/pts
    umount ${CHROOTTARGET}/sys
}

daemon_status ()
{
    `grep "/proc ${CHROOTTARGET}/proc " /proc/mounts > /dev/null 2>&1` || `grep "/dev/pts ${CHROOTTARGET}/dev/pts " /proc/mounts > /dev/null 2>&1` || `grep "/sys ${CHROOTTARGET}/sys " /proc/mounts > /dev/null 2>&1`
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
            exit 0
        else
            echo ${DNAME} is not running
            exit 0
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
    chroot)
        chroot ${CHROOTTARGET}/ /bin/bash
        ;;
    *)
        exit 1
        ;;
esac

