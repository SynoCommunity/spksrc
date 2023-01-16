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
usage() {
   echo
   printf '%10s %s\n' "Usage :" "$0 [-s|--spk <package>] [<insmod,start|rmmod,stop|reload,restart|status>] module1.ko module2.ko ..."
   printf '%20s %s\n' "Optional :" "[-c|--config <file>:<option1>,<option2>,...]"
   printf '%20s %s\n' "" "[-u|--udev <file>]"
   echo
   printf '%40s %s\n' "[-s|--spk <package>] : " "SynoCommunity package name containing kernel modules"
   printf '%40s %s\n' "[<insmod|rmmod|reload|status>] : " "Action to be performed"
   printf '%40s %s\n' "[-h|--help] : " "Print this help"
   printf '%40s %s\n' "[-v|--verbose] : " "Verbose mode"
   echo
   printf '%10s %s\n' "" "Examples :"
   printf '%20s %s\n' "" "$0 --spk synokernel-cdrom --verbose cdrom sr_mod status"
   printf '%20s %s\n' "" "$0 --spk synokernel-cdrom --config synokernel-cdrom.cfg:default status"
   printf '%20s %s\n' "" "$0 --spk synokernel-usbserial --udev 60-synokernel-usbserial.rules usbserial ch341 cp210x status"
   printf '%20s %s\n' "" "$0 --spk synokernel-usbserial --config synokernel-usbserial.cfg:ch341,cp210x status"
   echo
}

#------------------------------------------------
# Print detailed information for debugging
#------------------------------------------------
verbose() {
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
   printf '%60s %s\n' "udev rules.d path (UPATH)" "[${UPATH}]"
   printf '%60s %s\n' "udev rules.d file (URULE)" "[${URULE}]"
   printf '%60s %s\n' "Kernel objects list (KO_LIST)" "[${KO_LIST}]"
   printf '%60s %s\n' "Kernel objects found (KO_PATH)" "[${KO_PATH}]"
}


#------------------------------------------------
# Get all kernel modules from configuration file
# based on passed configuration option
#------------------------------------------------
get_ko_list() {
   ko_list_cfg=""

   if [ "${SPK_CFG}" ]; then
      # Check that configuration exists (if requested)
      if [ ! -f ${SPK_CFG_PATH}/${SPK_CFG} ]; then
         usage
         echo -ne "\nERROR: Configuration file [${SPK_CFG_PATH}/${SPK_CFG}] does not exist or inaccessible...\n\n"
         exit 1
      fi

      # Always include default first
      ko_list_cfg=$(sed -n "s/^default:\(.*\)/\1/p" ${SPK_CFG_PATH}/${SPK_CFG})
      if [ ! "${ko_list_cfg}" ]; then
         usage
         echo -ne "\nERROR: Configuration option [default] not found in file [${SPK_CFG_PATH}/${SPK_CFG}]...\n\n"
         exit 1
      fi

      IFS=","
      for config in ${SPK_CFG_OPT}
      do
         ko_list_cfg_tmp=$(sed -n "s/^${config}:\(.*\)/\1/p" ${SPK_CFG_PATH}/${SPK_CFG})
         if [ ! "${ko_list_cfg}" ]; then
            usage
            echo -ne "\nERROR: Configuration option [${config}:] not found in file [${SPK_CFG_PATH}/${SPK_CFG}]...\n\n"
            exit 1
         fi
         ko_list_cfg+="${ko_list_cfg_tmp} "
      done
      IFS=" "
   fi

   # Return merged module list from config file and
   # parameters passed as arguments but keep its order,
   # starting with the config file followed by args
   echo ${ko_list_cfg} ${KO_LIST_ARG} | awk '{for (i=1;i<=NF;i++) if (!a[$i]++) printf("%s%s",$i,FS)}{printf("\n")}' | xargs
}


#------------------------------------------------
# Modules can be passed as:
#   <module>
#   <module>.ko
#   /<path>/<module>*
# The following find the right module as needed
#------------------------------------------------
ko_path_match() {
   ko_find=""
   ko_path=""
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
      ko_path+="${ko_find##*${KVER}} "
   done

   # Return missing modules in case of error
   # else return the list of found modules
   [ ! "${ko_missing}" ] \
      && echo "$ko_path" | xargs \
      || echo "missing: ${ko_missing}" | xargs
}

# exit if no parameters passed
[ $# -eq 0 ] && usage && exit 1

# must be root to load/unload kernel modules
if [ ! "$(id -un)" = "root" ]; then
   verbose && usage
   echo
   echo "ERROR: Must have root or sudo priviledges..."
   echo
   exit 1
fi


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
URULE="FALSE"                                                          # Set udev rules to false by default

while [ $# -gt 0 ] 
do
   case $1 in
                                        -s|--spk ) shift 1
                                                   SPK=$1;;
                                     -c|--config ) shift 1
                                                   SPK_CFG=$(echo $1 | cut -f1 -d:)
                                                   SPK_CFG_OPT=$(echo $1 | cut -f2 -d:);;
                                       -u|--udev ) shift 1
                                                   URULE=$(echo $1 | cut -f1 -d:);;
                                       -h|--help ) HELP="TRUE";;
   insmod|rmmod|reload|start|stop|restart|status ) ACTION=$1;;
                                    -v|--verbose ) VERBOSE="TRUE";;
                                               * ) KO_LIST_ARG+="$1 ";;
   esac
   shift 1;
done

###
### Other global variables
###
ARCH=$(uname -a | awk '{print $NF}' | cut -f2 -d_)                     # Synology NAS arch
DSM_VERSION=$(sed -n 's/^productversion="\(.*\)"/\1/p' /etc/VERSION)   # Synology DSM version
FPATH_SYS="/sys/module/firmware_class/parameters/path"                 # System module firmware path file index
KVER=$(uname -r | awk -F. '{print $1 "." $2 "." $3}')                  # Running kernel version
FPATH=""                                                               # Device firmware path
KPATH=""                                                               # Full kernel modules path
MPATH=""                                                               # Kernel modules path
KO_LIST=""                                                             # List of kernel objects to enable|disable (includes config+args)
KO_LIST_ARG=$(echo ${KO_LIST_ARG} | xargs)                             # List of kernel objects passed in argument
KO_PATH=""                                                             # List of found kernel objects (*.ko) with path (includes config+args)
SYNOLOG_PATH=/var/log/packages                                         # Default log output file
SYNOLOG=${SYNOLOG_PATH}/synocli-kernelmodule.log                       # Default log output file

# If SPK is set reassign variables
if [ -n "${SPK}" ]; then
   SPK_CFG_PATH="/var/packages/${SPK}/target/etc"
   FPATH="/var/packages/${SPK}/target/lib/firmware"
   MPATH="/var/packages/${SPK}/target/lib/modules"
   UPATH="/var/packages/${SPK}/target/rules.d"
   KPATH="${MPATH}/${ARCH}-${DSM_VERSION}/${KVER}"
   SYNOLOG="${SYNOLOG_PATH}/synocli-kernelmodule-${SPK}.log"
fi

# All output to SYNOLOG, STDOUT to the screen
exec > >(tee -a ${SYNOLOG}) 2> >(tee -a ${SYNOLOG} >/dev/null)


# Get list of kernel objects from
# both the configuration file and
# arguments passed on cmd line
KO_LIST=$(get_ko_list)

# Find resulting kernel object (*.ko) full path
KO_PATH=$(ko_path_match)

# exit if modules are missing/not found
if [ "$(echo $KO_PATH | cut -f1 -d:)" = "missing" ]; then
   verbose && usage
   echo
   echo "ERROR: Missing kernel modules: [$(echo $KO_PATH | cut -f2 -d: | xargs)]"
   echo
   exit 1
fi

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

# Check that udev rules file exist
if [ ! ${URULE} "FALSE" -a ! -f ${UPATH}/${URULE} ]; then
   usage
   echo -ne "\nERROR: udev rules.d file [${UPATH}/${URULE}] does not exist or inaccessible...\n\n"
   exit 1
fi

# load the requested modules
load ()
{
   error=0

   if [ "{URULE}" ]; then
      echo -ne "\t[enable] optional udev rules...\n"
      printf '%40s %-34s' "" "[$URULE]"
      ln -s ${UPATH}/${URULE} /lib/udev/rules.d/${URULE}
      udevadm control --reload-rules
      if [ $? -eq 0 ]; then
         echo -ne " OK\n"
      else
         error=1
         echo -ne " N/A\n"
      fi
   fi

   # Add firmware path to running kernel
   if [ -d "${FPATH}" ]; then
      echo -ne "\t[loading] optional firmware path...\n"
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
   for ko in $KO_PATH
   do
      module=$(echo "${ko}" | sed -e 's/.*\///' -e 's/-/_/' -e 's/\.ko//')
      printf '%40s %-35s' $ko "[$module]"

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
   for item in $KO_PATH; do echo $item; done | tac | while read ko
   do
      module=$(echo "${ko}" | sed -e 's/.*\///' -e 's/-/_/g' -e 's/\.ko//')
      printf '%40s %-35s' $ko "[$module]"
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
      echo -ne "\t[unloading] optional firmware path...\n"
      echo "" > ${FPATH_SYS}
      error=$?
   fi

   # Remove udev rules
   if [ "{URULE}" ]; then
      echo -ne "\t[remove] optional udev rules...\n"
      printf '%40s %-34s' "" "[$URULE]"
      rm -f /lib/udev/rules.d/${URULE}
      udevadm control --reload-rules
      if [ $? -eq 0 ]; then
         echo -ne " N/A\n"
      else
         error=1
         echo -ne " ERROR\n"
      fi
   fi

   return $error
}


# Provide a status of the loaded modules
status ()
{
   error=0

   echo -ne "\t[status] kernel modules...\n"
   for ko in $KO_PATH
   do
      module=$(echo "${ko}" | sed -e 's/.*\///' -e 's/-/_/g' -e 's/\.ko//')
      printf '%40s %-35s' $ko "[$module]"

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
      echo -ne "\t[status] of optional firmware path...\n"
	  printf '%65s' "[${FPATH}]"

      grep -q ${FPATH} ${FPATH_SYS}
      if [ $? -eq 0 ]; then
         echo -ne " OK\n"
      else
         error=1
         echo -ne " N/A\n"
      fi
   fi

   # Validate udev rules (not much can be done)
   if [ "{URULE}" ]; then
      echo -ne "\t[status] of optional udev rules...\n"
      printf '%40s %-34s' "" "[$URULE]"
      if [ -h /lib/udev/rules.d/${URULE} ]; then
         echo -ne " OK\n"
      else
         error=1
         echo -ne " N/A\n"
      fi
   fi

   return $error
}


case $ACTION in
    insmod|start)
       if status; then
           echo ${SPK} is already running
           exit 0
       else
           echo Starting ${SPK} ...
           load
           exit $?
       fi
       ;;
    rmmod|stop)
       if status; then
           echo Stopping ${SPK} ...
           unload
           exit $?
       else
           echo ${SPK} is not running
           exit 0
       fi
       ;;
    reload|restart)
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
