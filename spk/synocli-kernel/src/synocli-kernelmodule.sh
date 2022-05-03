#!/bin/bash

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

#------------------------------------------------
# Make sure an argument was passed 
#------------------------------------------------
usage ()
{
echo
printf '%10s %s\n' "Usage :" "$0 [-s|--spk <package>] [<insmod|rmmod|reload|status>] module1.ko module2.ko ..."
printf '%20s %s\n' "Optional :" "[-c|--config <file>:<option>]"
echo
printf '%40s %s\n' "[-s|--spk <package>] : " "SynoCommunity package name containing kernel modules"
printf '%40s %s\n' "[<insmod|rmmod|reload|status>] : " "Action to be performed"
printf '%40s %s\n' "[-h|--help] : " "Print this help"
printf '%40s %s\n' "[-v|--verbose] : " "Verbose mode"
echo
printf '%10s %s\n' "" "Examples :"
printf '%20s %s\n' "" "$0 --spk synokernel-cdrom --verbose cdrom sr_mod status"
printf '%20s %s\n' "" "$0 --spk synokernel-cdrom --config synokernel-cdrom.cfg:default status"
echo
}

#------------------------------------------------
# Print detailed information for debugging
#------------------------------------------------
verbose ()
{
printf '%20s %s\n' "" "$0 (verbose)"
printf '%60s %s\n' "SynoCommunity kernel driver package name (SPK)" "[${SPK}]"
printf '%60s %s\n' "SynoCommunity configuration file (SPK_CFG)" "[${SPK_CFG}]"
printf '%60s %s\n' "SynoCommunity configuration path (SPK_CFG_PATH)" "[${SPK_CFG_PATH}]"
printf '%60s %s\n' "SynoCommunity configuration option (SPK_CFG_OPT)" "[${SPK_CFG_OPT}]"
printf '%60s %s\n' "Synology NAS arch (ARCH)" "[${ARCH}]"
printf '%60s %s\n' "Synology DSM version (DSM_VERSION)" "[${DSM_VERSION}]"
printf '%60s %s\n' "Running kernel version (KVER)" "[${KVER}]"
printf '%60s %s\n' "Module action insmod|rmmod|reload|status (ACTION)" "[${ACTION}]"
printf '%60s %s\n' "Kernel modules path (MPATH)" "[${MPATH}]"
printf '%60s %s\n' "Full kernel modules path (KPATH)" "[${KPATH}]"
printf '%60s %s\n' "Device firmware path (FPATH)" "[${FPATH}]"
printf '%60s %s\n' "Kernel objects list (KO_LIST)" "[${KO_LIST}]"
printf '%60s %s\n' "Kernel objects found (KO_FOUND)" "[${KO_FOUND}]"
}


#------------------------------------------------
# Modules can be passed as:
#   <module>
#   <module>.ko
#   /<path>/<module>*
# The following find the right module as needed
#------------------------------------------------
ko_path_match ()
{
   ko_find=""
   ko_missing=""

   for ko in $KO_LIST
   do
      # first check if the name
	  # matches to a path
      if [ ! "$(echo $ko | grep '/')" ]; then
         # Ensure to add .ko if needed
         [ ! "$(echo $ko | grep '.ko$')" ] && ko=$ko.ko
		 # Replace any '-' or '_' by '[-_]
		 ko=$(echo ${ko} | sed -r 's/[-_]/[-_]/g')
         # Find full module kernel object path
         ko_find=$(find $KPATH -name $ko)
	     [ ! "$ko_find" ] && ko_missing+="$ko "
      fi
      KO_FOUND+="${ko_find##*${KVER}} "
   done

   KO_FOUND=$(echo $KO_FOUND | xargs)

   if [ ! $(echo $KO_LIST | wc -w) -eq $(echo $KO_FOUND | wc -w) ]; then
	  verbose && usage
      echo
      echo "ERROR: Missing kernel modules: [$(echo $ko_missing | xargs)]"
      echo
	  exit 1
   fi
}


[ $# -eq 0 ] && usage && exit 1

###
### Global variables
###
SPK=""                                                                 # SynoCommunity kernel driver package name
SPK_CFG=""                                                             # SynoCommunity configuration file
SPK_CFG_OPT=""                                                         # SynoCommunity configuration option
SPK_CFG_PATH=""                                                        # SynoCommunity configuration path
ACTION=""                                                              # Module action insmod|rmmod|reload|status
VERBOSE="FALSE"                                                        # Set verbose mode
HELP="FALSE"                                                           # Print help

while [ $# -gt 0 ] 
do
   case $1 in
                          -s|--spk ) shift 1
						             SPK=$1;;
                       -c|--config ) shift 1
						             SPK_CFG=$(echo $1 | cut -f1 -d:)
						             SPK_CFG_OPT=$(echo $1 | cut -f2 -d:);;
                         -h|--help ) HELP="TRUE";;
        insmod|rmmod|reload|status ) ACTION=$1;;
                      -v|--verbose ) VERBOSE="TRUE";;
                                 * ) KO_LIST+="$1 ";;
   esac
   shift 1;
done

###
### Other global variables
###
ARCH=$(uname -a | awk '{print $NF}' | cut -f2 -d_)                     # Synology NAS arch
DSM_VERSION=$(sed -n 's/^productversion="\(.*\)"/\1/p' /etc/VERSION)   # Synology DSM version
FPATH_SYS="/sys/module/firmware_class/parameters/path"                 # System module firmware path file index
KVER=$(uname -r)                                                       # Running kernel version
FPATH=""                                                               # Device firmware path
KPATH=""                                                               # Full kernel modules path
MPATH=""                                                               # Kernel modules path
KO_LIST=$(echo ${KO_LIST} | xargs)                                     # List of kernel objects to enable|disable
KO_LIST_CFG=""                                                         # List of kernel objects in configuration
KO_FOUND=""                                                            # List of found kernel objects
SYNOLOG_PATH=/var/log/packages                                         # Default log output file
SYNOLOG=${SYNOLOG_PATH}/synocli-kernelmodule.log                       # Default log output file

# If SPK is set reassign variables
if [ -n "${SPK}" ]; then
   SPK_CFG_PATH="/var/packages/${SPK}/target/etc"
   FPATH="/var/packages/${SPK}/target/lib/firmware"
   MPATH="/var/packages/${SPK}/target/lib/modules"
   KPATH="${MPATH}/${ARCH}-${DSM_VERSION}/${KVER}"
   SYNOLOG="${SYNOLOG_PATH}/synocli-kernelmodule-${SPK}.log"
fi

# All output to SYNOLOG, STDOUT to the screen
exec > >(tee -a ${SYNOLOG}) 2> >(tee -a ${SYNOLOG} >/dev/null)

if [ "${SPK_CFG}" ]; then
   # Check that configuration exists (if requested)
   if [ ! -f ${SPK_CFG_PATH}/${SPK_CFG} ]; then
      usage
      echo -ne "\nERROR: Configuration file [${SPK_CFG_PATH}/${SPK_CFG}] does not exist or inaccessible...\n\n"
      exit 1
   fi	
   # Check that configuration option exists
   KO_LIST_CFG=$(sed -n "s/^${SPK_CFG_OPT}:\(.*\)/\1/p" ${SPK_CFG_PATH}/${SPK_CFG})

   # Merge modules from config file
   # and parameters passed as arguments
   # but keep its order, starting with
   # the config file followed by args
   if [ "${KO_LIST_CFG}" ]; then
      KO_LIST=$(echo ${KO_LIST_CFG} ${KO_LIST} | awk '{for (i=1;i<=NF;i++) if (!a[$i]++) printf("%s%s",$i,FS)}{printf("\n")}' | xargs)
   else
      usage
      echo -ne "\nERROR: Configuration option [${SPK_CFG_OPT}:] no found in file [${SPK_CFG_PATH}/${SPK_CFG}]...\n\n"
      exit 1
   fi	
fi


# Find resulting kernel object path
# and confirm that KO_LIST and KO_FOUND
# do match
ko_path_match

# If verbose is set print default arguments
[ ${VERBOSE} = "TRUE" ] && verbose

[ ${HELP} = "TRUE" ] && usage && exit 0

# If module path does not exists, exit
if [ ! -d ${MPATH} ]; then
   usage
   echo -ne "\nERROR: Module path [${MPATH}] does not exist or inaccessible...\n\n"
   exit 1
fi

# Set kernel module .ko object base path
# If does not exists, exit
if [ ! -d ${KPATH} ]; then
   usage
   echo -ne "\nERROR: Kernel modules base path [${KPATH}] does not exist or inaccessible...\n\n"
   exit 1
fi

# load the requested modules
load ()
{
   error=0

   # Add firmware path to running kernel
   if [ -d "${FPATH}" ]; then
      echo -ne "\tAdd optional firmware path...\n"
	  printf '%65s' "[${FPATH}]"
      echo "${FPATH}" > ${FPATH_SYS}

      if [ $? -eq 0 ]; then
         echo -ne " OK\n"
      else
         error=1
         echo -ne " N/A\n"
      fi
   fi

   echo -ne "\t[insmod] kernel modules...\n"
   for ko in $KO_FOUND
   do
      module=$(echo "${ko}" | sed -e 's/.*\///' -e 's/-/_/' -e 's/\.ko//')
      printf '%40s %-25s' $ko "[$module]"

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
   for item in $KO_FOUND; do echo $item; done | tac | while read ko
   do
      module=$(echo "${ko}" | sed -e 's/.*\///' -e 's/-/_/g' -e 's/\.ko//')
      printf '%40s %-25s' $ko "[$module]"

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
   if [ -d "${FPATH}" ]; then
      echo -ne "\tUnloading of optional firmware path...\n"
      echo "" > ${FPATH_SYS}
      error=$?
   fi

   return $error
}


# Provide a status of the loaded modules
status ()
{
   error=0

   echo -ne "\t[status] kernel modules...\n"
   for ko in $KO_FOUND
   do
      module=$(echo "${ko}" | sed -e 's/.*\///' -e 's/-/_/g' -e 's/\.ko//')
      printf '%40s %-25s' $ko "[$module]"

      status=$(lsmod | grep "^$module ")
      if [ $? -eq 0 -a "status" ]; then
         echo -ne "OK\n"
      else
         error=1
         echo -ne "N/A\n"
      fi
   done

   # Validate option firmware path
   if [ -d "${FPATH}" ]; then
      echo -ne "\tStatus of optional firmware path...\n"
	  printf '%65s' "[${FPATH}]"

      grep -q ${FPATH} ${FPATH_SYS}
      if [ $? -eq 0 ]; then
         echo -ne " OK\n"
      else
         error=1
         echo -ne " N/A\n"
      fi
   fi

   return $error
}


case $ACTION in
    insmod)
       if status; then
           echo ${SPK} is already running
           exit 0
       else
           echo Starting ${SPK} ...
           load
           exit $?
       fi
       ;;
    rmmod)
       if status; then
           echo Stopping ${SPK} ...
           unload
           exit $?
       else
           echo ${SPK} is not running
           exit 0
       fi
       ;;
    reload)
       echo -ne "---\nReloading ${SPK} package...\n"
       unload
       load
       exit $?
       ;;
    status)
       echo -ne "---\nStatus of ${SPK} package...\n"
       if status; then
           echo ${SPK} is running
           exit 0
       else
           echo ${SPK} is not running
           exit 1
       fi
       ;;
    *) usage
       exit 1
       ;;
esac
