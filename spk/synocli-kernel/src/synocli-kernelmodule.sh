#!/bin/sh

#########################################################################
# Written by: th0ma7@gmail.com
# Part of SynoCommunity Developpers
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#########################################################################

# Make sure an argument was passed 
usage ()
{
printf '%10s %s\n' "Usage :" "$0 [-m <path> ] [-a <load|unload|status>] module1.ko module2.ko ..." 1>&2
printf '%10s %s\n' "Optional :" "[-f <path>] [-k <version> ] [-n <name>]" 1>&2
echo 1>&2
printf '%30s %s\n' "[-m <path> ] : " "Kernel module base path (OPTIONAL if -n <package> is provided)" 1>&2
printf '%30s %s\n' "[-f <path> ] : " "Additional firmware base path (OPTIONAL)" 1>&2
printf '%30s %s\n' "[-k <path> ] : " "Kernel version (OPTIONAL: uses \`uname -r\` if not provided)" 1>&2
printf '%30s %s\n' "[-n <package> ] : " "Name of the SynoCommunity package invoking this script for logging purpose" 1>&2
printf '%30s %s\n' "[-a <load|unload|status> ] : " "Action to be performed" 1>&2
echo 1>&2
printf '%10s %s\n' "" "Example :" "$0 -a load -k 4.4.59+ \\" 1>&2
printf '%35s %s\n' "" "-m /var/package/synokernel-usbserial/target/lib/modules \\" 1>&2
printf '%38s %s\n' "" "usb/serial/usbserial.ko usb/serial/ftdi_sio.ko" 1>&2
echo 1>&2
}
[ $# -eq 0 ] && usage && exit 1

# Get basic options
while getopts ":h:m:f:k:n:a:" arg; do
  case $arg in
    m) MPATH=${OPTARG};;
    f) FPATH=${OPTARG};;
    k) KVER=${OPTARG};;
    n) DNAME=${OPTARG};;
    a) ACTION=${OPTARG};;
    h) usage;;
  esac
done

# Gather the remaining kernel modules passed as parameters
shift $((OPTIND-1))
KO=$@

# Set system module firmware path file index
SYS_FIRMWARE_PATH=/sys/module/firmware_class/parameters/path

# Set LOG output
SYNOLOG=/tmp/synocli-kernelmodule.log
[ -n "${DNAME}" ] && SYNOLOG=/tmp/synocli-kernelmodule-${DNAME}.log

exec >> $SYNOLOG

# Set default kernel version
[ -z "${KVER}" ] && KVER=$(uname -r)

# If neither the module path or name is being provided, exit
if [ -z "${MPATH}" ]; then
   [ -z "{DNAME}" ] \
      && usage \
	  || MPATH=/var/packages/${DNAME}/target/lib/modules
fi

# If module path does not exists, exit
if [ ! -d ${MPATH} ]; then
   echo "ERROR: Module path [${MPATH}] does not exist or inaccessible..." 1>&2
   echo 1>&2
   usage
fi

# Set kernel module .ko object base path
KPATH=${MPATH}/${KVER}/kernel/drivers

# load the requested modules
load ()
{
   error=0

   echo -ne "\tLoading kernel modules...\n"
   for ko in $KO
   do
      module=$(echo "${ko}" | sed -e 's/.*\///' -e 's/-/_/' -e 's/\.ko//')
      printf '%50s %-25s' $ko "[$module]"

      status=$(lsmod | grep "^$module ")
      if [ $? -eq 0 -a "status" ]; then
         echo "Already Loaded"
      else
         if [ -f $KPATH/$ko ]; then
            insmod $KPATH/$ko
            [ $? -eq 0 ] && echo "OK" || echo "ERROR"
         else
            echo "ERROR: Module $KPATH/$ko not found!"
			error=1
         fi
      fi
   done

   # Add firmware path to running kernel
   if [ -n "${FPATH}" ]; then
      echo -ne "\tAdd optional firmware path...\n"
      echo "${FPATH}" > ${SYS_FIRMWARE_PATH}
      error=$?
   fi

   return $error
}


# unload the requested modules in a reversed order
unload ()
{
   error=0

   # Unload drivers in reverse order
   echo -ne "\tUnloading kernel modules...\n"
   for item in $KO; do echo $item; done | tac | while read ko
   do
      module=$(echo "${ko}" | sed -e 's/.*\///' -e 's/-/_/' -e 's/\.ko//')
      printf '%50s %-25s' $ko "[$module]"

      status=$(lsmod | grep "^$module ")
      if [ $? -eq 0 -a "status" ]; then
         rmmod $module
         echo -ne "N/A\n"
      else
         echo -ne "ERROR\n"
		 error=1
      fi
   done

   # Remove firmware path to running kernel
   if [ -n "${FPATH}" ]; then
      echo -ne "\tUnloading of optional firmware path...\n"
      echo "" > ${SYS_FIRMWARE_PATH}
      error=$?
   fi

   return $error
}


# Provide a status of the loaded modules
status ()
{
   error=0

   echo -ne "\tStatus of kernel modules...\n"
   for ko in $KO
   do
	  module=$(echo "${ko}" | sed -e 's/.*\///' -e 's/-/_/' -e 's/\.ko//')
      printf '%50s %-25s' $ko "[$module]"

      status=$(lsmod | grep "^$module ")
      if [ $? -eq 0 -a "status" ]; then
         error=0
         echo -ne "OK\n"
      else
         error=1
         echo -ne "N/A\n"
      fi
   done

   # Validate option firmware path
   if [ -n "${FPATH}" ]; then
      echo -ne "\tStatus of optional firmware path...\n"
	  printf '%75s' "[${FPATH}]"

      grep -q ${FPATH} ${SYS_FIRMWARE_PATH}
	  if [ $? -eq 0 ]; then
	     error=0
		 echo -ne " OK\n"
      else
	     error=1
		 echo -ne " N/A\n"
      fi
   fi

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
