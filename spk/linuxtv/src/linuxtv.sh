#!/bin/sh


# Firmware path
FIRMWARE_PATH=/sys/module/firmware_class/parameters/path
# Kernel object path
KO_PATH=/var/packages/linuxtv/target/lib/modules/$(uname -r)/kernel/drivers/media


# Make sure an argument was passed 
usage() { echo "Usage: $0 [-n <name>] [-a <load|unload|status>] module1.ko module2.ko ..." 1>&2 }
[ $# -eq 0 ] && usage && exit 1


# Get basic options
while getopts ":h:n:a:" arg; do
  case $arg in
    n) NAME=${OPTARG};;
    a) ACTION=${OPTARG};;
    h) usage;;
  esac
done

# Gather the remaining kernel modules passed as parameters
shift $((OPTIND-1))
KO=$@


# load the requested modules
load ()
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


# unload the requested modules in a reversed order
unload ()
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


# Provide a status of the loaded modules
status ()
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


case $ACTION in
    load)
       if status; then
           echo ${DNAME} is already running
           exit 0
       else
           echo Starting ${DNAME} ...
           load
           exit $?
       fi
       ;;
    unload)
       if status; then
           echo Stopping ${DNAME} ...
           unload
           exit $?
       else
           echo ${DNAME} is not running
           exit 0
       fi
       ;;
    reload)
       unload
       load
       exit $?
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
    *) usage
       exit 1
       ;;
esac
