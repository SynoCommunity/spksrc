#!/bin/sh

# Package
PACKAGE="gentoo-chroot"
DNAME="Gentoo Chroot"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/syno/sbin:/usr/syno/bin"
CHROOTTARGET=`realpath ${INSTALL_DIR}/var/chroottarget`

start_daemon ()
{
    # Mount if install is finished
    if [ -f ${INSTALL_DIR}/var/installed ]; then
        # Make sure we don't mount twice
        grep -q "${CHROOTTARGET}/proc " /proc/mounts || mount -t proc proc ${CHROOTTARGET}/proc
        grep -q "${CHROOTTARGET}/sys " /proc/mounts || mount -t sysfs sys ${CHROOTTARGET}/sys
        grep -q "${CHROOTTARGET}/dev " /proc/mounts || mount -o bind /dev ${CHROOTTARGET}/dev
        grep -q "${CHROOTTARGET}/dev/pts " /proc/mounts || mount -o bind /dev/pts ${CHROOTTARGET}/dev/pts
        test -d "${CHROOTTARGET}/dev/fd" || ln -s '../proc/self/fd' ${CHROOTTARGET}/dev/fd
        grep -q "${CHROOTTARGET}/tmp " /proc/mounts || mount -t tmpfs /tmp ${CHROOTTARGET}/tmp

    # Mount user specified directories, if specified
    if [ -f ${INSTALL_DIR}/etc/mounts ]; then
        if [ `sed -e 's/#.*$//g' -e '/^$/d' ${INSTALL_DIR}/etc/mounts | wc -l` != 0 ]; then
            sed -e 's/#.*$//g' -e '/^$/d' ${INSTALL_DIR}/etc/mounts | while read mount; do
                SRC=$(echo $mount | awk '{ print $1 }')
                DST=$(echo $mount | awk '{ print $2 }' | cut -c 2-)
                grep -q "${CHROOTTARGET}/${DST} " /proc/mounts || mount -o bind $SRC ${CHROOTTARGET}/${DST}
                done
        fi
    fi

        # Start all services
        ${INSTALL_DIR}/app/start.py
    fi
}

stop_daemon ()
{
    # Stop running services
    ${INSTALL_DIR}/app/stop.py

    # Unmount
    test -L ${CHROOTTARGET}/dev/fd && rm ${CHROOTTARGET}/dev/fd
    for mount in `grep ${CHROOTTARGET} /proc/mounts | awk '{ print $2 }'`; do umount -l $mount; done

}

daemon_status ()
{
    `grep -q "${CHROOTTARGET}/proc " /proc/mounts` && `grep -q "${CHROOTTARGET}/sys " /proc/mounts` && `grep -q "${CHROOTTARGET}/dev " /proc/mounts` && `grep -q "${CHROOTTARGET}/dev/pts " /proc/mounts` && `grep -q "${CHROOTTARGET}/tmp " /proc/mounts` && `test -d "${CHROOTTARGET}/dev/fd"`
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
    restart)
        if daemon_status; then
            echo Stopping ${DNAME} ... && \
            stop_daemon && \
            echo Starting ${DNAME} ... && \
            start_daemon && \
            exit 0
        else
            echo ${DNAME} is not running
            exit 1
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
        if daemon_status; then
            echo Entering chroot...
            chroot ${CHROOTTARGET}/ /bin/bash
        else
            echo WARNING: ${DNAME} is not running
            echo WARNING: The chroot environment will not have access to /proc, /dev, /sys or /tmp which could cause problems!
            echo Entering chroot...
            chroot ${CHROOTTARGET}/ /bin/bash
            exit 1
        fi
        ;;
    log)
        if [ -f ${CHROOTTARGET}/var/log/syslog ]; then
            echo ${CHROOTTARGET}/var/log/syslog
            exit 0
        elif [ -f ${CHROOTTARGET}/var/log/messages ]; then
            echo ${CHROOTTARGET}/var/log/messages
            exit 0
        else
            exit 1
        fi
        ;;
    *)
        echo "You must provide an argument to this script; either 'start', 'stop', 'restart', 'status' or 'chroot'"
        exit 1
        ;;
esac
