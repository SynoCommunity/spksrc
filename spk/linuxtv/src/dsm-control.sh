#!/bin/sh

# Package
PACKAGE="linuxtv"
DNAME="LinuxTV"

FIRMWARE_PATH=/sys/module/firmware_class/parameters/path
KO_PATH=/var/packages/linuxtv/target/lib/modules/$(uname -r)/kernel/drivers/media

KO=" rc/rc-core.ko \
    common/tveeprom.ko"
#KO="v4l2-core/media.ko \
#    common/videobuf2/videodev.ko \
#    common/videobuf2/videobuf2-common.ko \
#    common/videobuf2/videobuf2-v4l2.ko \
#    common/videobuf2/videobuf2-memops.ko \
#    common/videobuf2/videobuf2-vmalloc.ko \
#    dvb-core/dvb-core.ko \
#    rc/rc-core.ko \
#    usb/dvb-usb-v2/dvb_usb_v2.ko \
#    usb/dvb-usb/dvb-usb.ko \
#    v4l2-core/v4l2-common.ko \
#    common/tveeprom.ko"

start_daemon ()
{
   echo "Loading kernel modules... "
   for ko in $KO
   do
      module=$(echo "${ko}" | sed -e 's/.*\///' -e 's/-/_/' -e 's/\.ko//')
      printf '%30s %-15s' $ko "[$module]"

      status=$(lsmod | grep "^$module ")
      if [ $? -eq 0 -a "status" ]; then
         echo "Already Loaded"
      else
         if [ -f $KO_PATH/$ko ]; then
            insmod $KO_PATH/$ko
            [ $? -eq 0 ] && echo "OK" || echo "ERROR"
         else
            echo "ERROR: Module $KO_PATH/$ko not found!"
         fi
      fi
   done

   # Add firmware path to running kernel
   echo "$FIRMWARE_PATH" > /sys/module/firmware_class/parameters/path
}

stop_daemon ()
{
   # Unload drivers in reverse order
   echo "Unloading kernel modules... "
   for item in $KO; do echo $item; done | tac | while read ko
   do
      module=$(echo "${ko}" | sed -e 's/.*\///' -e 's/-/_/' -e 's/\.ko//')
      printf '%30s %-15s' $ko "[$module]"

      status=$(lsmod | grep "^$module ")
      if [ $? -eq 0 -a "status" ]; then
         rmmod $module
         echo -ne "OK\n"
      else
         echo -ne "N/A\n"
      fi
   done
}

daemon_status ()
{
   echo "Status of kernel modules... "
   error=0

   for ko in $KO
   do
      module=$(echo "${ko}" | sed -e 's/.*\///' -e 's/-/_/' -e 's/\.ko//')
      printf '%30s %-15s' $ko "[$module]"

      status=$(lsmod | grep "^$module ")
      if [ $? -eq 0 -a "status" ]; then
         echo -ne "OK\n"
      else
         error=1
         echo -ne "N/A\n"
      fi
   done

   return $error
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
    *)
        exit 1
        ;;
esac
