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
printf '%10s %s\n' "Usage :" "$0 [-m <path> ] [-a <insmod|rmmod|reload|status>] module1.ko module2.ko ..." 1>&2
printf '%10s %s\n' "Optional :" "[-f <path>] [-k <version> ] [-n <name>]" 1>&2
echo 1>&2
printf '%40s %s\n' "[-m <path> ] : " "Kernel module base path (OPTIONAL if -n <package> is provided)" 1>&2
printf '%40s %s\n' "[-f <path> ] : " "Additional firmware base path (OPTIONAL)" 1>&2
printf '%40s %s\n' "[-k <path> ] : " "Kernel version (OPTIONAL: uses \`uname -r\` if not provided)" 1>&2
printf '%40s %s\n' "[-n <package> ] : " "SynoCommunity package name containing kernel modules" 1>&2
printf '%40s %s\n' "[-a <insmod|rmmod|reload|status> ] : " "Action to be performed" 1>&2
echo 1>&2
printf '%10s %s\n' "" "Examples :" 1>&2
printf '%20s %s\n' "" "$0 -a status -n synokernel-cdrom cdrom sr_mod" 1>&2
echo 1>&2
printf '%20s %s\n' "" "$0 -a status -k 4.4.59+ \\" 1>&2
printf '%30s %s\n' "" "-m /var/packages/synokernel-cdrom/target/lib/modules \\" 1>&2
printf '%30s %s\n' "" "drivers/cdrom/cdrom.ko \\" 1>&2
printf '%30s %s\n' "" "drivers/scsi/sr_mod.ko" 1>&2
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
    h) usage && exit 0;;
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

# Get ARCH
[ -z "${ARCH}" ] && ARCH=$(uname -a | awk '{print $NF}' | cut -f2 -d_)

# Get DSM VERSION
[ -z "${VERSION}" ] && VERSION=$(sed -n 's/^productversion=\(.*\)/\1/p' /etc/VERSION | sed -e 's/"//g')

# Set kernel module .ko object base path
# If does not exists, exit
KPATH=${MPATH}/${ARCH}-${VERSION}/${KVER}
if [ ! -d ${KPATH} ]; then
   echo "ERROR: Kernel modules base path [${KPATH}] does not exist or inaccessible..." 1>&2
   echo 1>&2
   usage
fi


#------------------------------------------------
# Modules can be passed as:
#   <module>
#   <module>.ko
#   /<path>/<module>*
# The following find the right module as needed
#------------------------------------------------
fix_ko_path ()
{
   KO_TMP=""
   for ko in $KO
   do
      # first check if the name
	  # matches to a path
      if [ ! "$(echo $ko | grep '/')" ]; then
         # Ensure to add .ko if needed
         [ ! "$(echo $ko | grep '.ko$')" ] && ko=$ko.ko
		 # Replace any '-' or '_' by '[-_]
		 ko=$(echo ${ko} | sed -r 's/[-_]/[-_]/g')
         # Find full module kernel object path
         ko=drivers/$(find $KPATH -name $ko | awk -F'drivers/' '{print $2}')
      fi
      KO_TMP="$KO_TMP $ko"
   done

   KO="$KO_TMP"
}

# load the requested modules
load ()
{
   error=0

   # Add firmware path to running kernel
   if [ -n "${FPATH}" ]; then
      echo -ne "\tAdd optional firmware path...\n"
	  printf '%65s' "[${FPATH}]"
      echo "${FPATH}" > ${SYS_FIRMWARE_PATH}

      if [ $? -eq 0 ]; then
         echo -ne " OK\n"
      else
         error=1
         echo -ne " N/A\n"
      fi
   fi

   echo -ne "\t[insmod] kernel modules...\n"
   for ko in $KO
   do
      module=$(echo "${ko}" | sed -e 's/.*\///' -e 's/-/_/' -e 's/\.ko//')
      printf '%40s %-25s' $(basename $ko) "[$module]"

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

   return $error
}


# unload the requested modules in a reversed order
unload ()
{
   error=0

   # Unload drivers in reverse order
   echo -ne "\t[rmmod] kernel modules...\n"
   for item in $KO; do echo $item; done | tac | while read ko
   do
      module=$(echo "${ko}" | sed -e 's/.*\///' -e 's/-/_/g' -e 's/\.ko//')
      printf '%40s %-25s' $(basename $ko) "[$module]"

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

   echo -ne "\t[status] kernel modules...\n"
   for ko in $KO
   do
      module=$(echo "${ko}" | sed -e 's/.*\///' -e 's/-/_/g' -e 's/\.ko//')
      printf '%40s %-25s' $(basename $ko) "[$module]"

      status=$(lsmod | grep "^$module ")
      if [ $? -eq 0 -a "status" ]; then
         echo -ne "OK\n"
      else
         error=1
         echo -ne "N/A\n"
      fi
   done

   # Validate option firmware path
   if [ -n "${FPATH}" ]; then
      echo -ne "\tStatus of optional firmware path...\n"
	  printf '%65s' "[${FPATH}]"

      grep -q ${FPATH} ${SYS_FIRMWARE_PATH}
      if [ $? -eq 0 ]; then
         echo -ne " OK\n"
      else
         error=1
         echo -ne " N/A\n"
      fi
   fi

   return $error
}

# Fis Kernel object path in order to allow
# receiving full path kernel module or
# kernel object name only
fix_ko_path

case $ACTION in
    insmod)
       if status; then
           echo ${DNAME} is already running
           exit 0
       else
           echo Starting ${DNAME} ...
           load
           exit $?
       fi
       ;;
    rmmod)
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
       echo -ne "---\nReloading ${DNAME} package...\n"
       unload
       load
       exit $?
       ;;
    status)
       echo -ne "---\nStatus of ${DNAME} package...\n"
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
