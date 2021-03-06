#!/bin/sh

# Configs
CFG=/var/packages/${SYNOPKG_PKGNAME}/target/etc/${SYNOPKG_PKGNAME}.cfg
INI=/var/packages/${SYNOPKG_PKGNAME}/target/etc/${SYNOPKG_PKGNAME}.ini
# Logs - only used if exit prior to calling synocli-kernelmodule
LOG=/tmp/synocli-kernelmodule-${SYNOPKG_PKGNAME}.log
# VideoStation DTS status
VIDEOSTATION_DTS=$(cat /lib/udev/script/DTV_enabled 2>/dev/null)

# Others
INSTALL_DIR="/usr/local/${SYNOPKG_PKGNAME}"
PATH="${INSTALL_DIR}/bin:${PATH}"
UDEV_RULE=60-${SYNOPKG_PKGNAME}.rules
FIRMWARE_PATH="/var/packages/${SYNOPKG_PKGNAME}/target/lib/firmware/"

check_videostation_dts() {
   if [ "$VIDEOSTATION_DTS" = "yes" ]; then
      exec >> $LOG

      echo "################################################################################################"
      echo "################################################################################################"
      echo "DETECTED: VideoStation DTS is enabled !!!!"
      echo
      echo "You must either:"
      echo -e "\t1. uninstall VideoStation"
      echo -e "\tor"
      echo -e "\t2. disable DTV function in VideoStation under:"
      echo -e "\t\tSettings (tab) > DTV > Advanced > Disable the DTV function"
      echo -e "Then reboot your NAS in order to remove any Synology default DVB modules from memory."
      echo
      echo "For more details please refer to"
      echo -e "\thttps://github.com/SynoCommunity/spksrc/wiki/FAQ-SynocliKernel-%28usbserial,-linuxtv%29"
      echo "################################################################################################"
      echo "################################################################################################"

      exit 1
   fi
}

#
# Return pid:username of all used
# DVB adapter by checking all
# opened device files from /dev/dvb/adapter*
#
check_dvb_odev() {
   default_list=""
   user_list=""
   pid_list=""
   device_list=""
   service_list=""

   for device in $(ls -1 /dev/dvb/adapter[0-9]/*); do
      pid=$(lsof | grep $device | awk -F' ' '{print $1}')
      echo $pid >> /tmp/synokernel-linuxtv.out
      if [ "$pid" ]; then
         user=$(ps -o uname= -p $pid)
         service=$(synoservice --list | grep -i ${user#*-})

         default_list="$default_list $pid:$user:$service:$device"
         device_list="$device_list $device"

         # user, pid and services can be repeated
         # ensure to return only unique elements
         [ ! "$(echo $user_list | grep $user)" ] && user_list="$user_list $user"
         [ ! "$(echo $pid_list | grep $pid)" ] && pid_list="$pid_list $pid"
         [ ! "$(echo $service_list | grep $service)" ] && service_list="$service_list $service"
      fi
   done

   case $1 in
        user) echo $user_list;;
         pid) echo $pid_list;;
      device) echo $device_list;;
     service) echo $service_list;;
           *) echo $default_list;;
   esac
}

#
# stop|start any of program accessing
# DVB device files
#
mgmnt_dvb_odev() {
   action=$1
   status_file=/tmp/synokernel-linuxtv_procs.lock
   read -ra process <<<"$(check_dvb_odev)"
   read -ra services <<<"$(check_dvb_odev service)"

   exec >> $LOG

   # DEBUG
   #echo "process[@]: [${process[@]}]"
   #echo "services[@]: [${services[@]}]"

   case $1 in
    start) echo -ne "\tStarting DVB applications\n"
           for serv in $(cat $status_file 2>/dev/null)
           do
              printf '%50s %-25s' "" "[$serv]"
              synoservice --status $serv 1>/dev/null 2>&1
              if [ $? -ne 0 ]; then
                 synoservice --start $serv 1>/dev/null 2>&1;
                 echo -ne "OK\n"
              else
                 # Service already started
                 echo -ne "N/A\n"
              fi
           done
           rm -f $status_file
           ;;
     stop) echo -ne "\tStopping DVB applications\n"
           # Clean-up any previous status file
           rm -f $status_file

           for serv in "${services[@]}"
           do
              printf '%50s %-25s' "" "[$serv]"
              synoservice --stop $serv 1>/dev/null 2>&1
              if [ $? -eq 0 ]; then
                 echo $serv >> $status_file
                 echo -ne "OK\n"
              else
                 echo -ne "ERROR\n"
                 echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                 echo "UNABLE TO UNLOAD KERNEL MODULES"
                 echo "DUE TO RUNNING SERVICE : [$serv]"
                 echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                 exit 1
              fi
           done
           ;;
   status) echo -ne "\tStatus of DVB device files\n"
           if [ ! "${process[@]}" ]; then
              echo -ne "\t\t[No device in usage]\n"
           else
              for pinfo in "${process[@]}"; do echo -ne "\t\t$pinfo\n"; done
           fi
           ;;
   esac
}

# Initiate exec call-up
if [ -d ${FIRMWARE_PATH} ]; then
   SYNOCLI_KMODULE="/usr/local/bin/synocli-kernelmodule -n ${SYNOPKG_PKGNAME} -f ${FIRMWARE_PATH} -a"
else
   SYNOCLI_KMODULE="/usr/local/bin/synocli-kernelmodule -n ${SYNOPKG_PKGNAME} -a"
fi

# Load kernel objects values
if [ -f ${CFG} ]; then
   . ${CFG}
else
   echo "Configuration file not found! [${CFG}]" 1>&2
   exit 1
fi

# First assign default modules
if [ "${default}" ]; then
   KO=${default}
else
   echo "Undifined default kernel modules! [default:${CFG}]" 1>&2
   exit 1
fi

# Add all modules set to true
if [ -f ${INI} ]; then
   for module in $(cat ${INI}); do
      ko="${module%%=*}"
	  [ "${module#*=}" = "true" -a ! "${module%%=*}" = "default" ] && KO="${KO} ${!ko}"
   done
fi

# Ensure KO is not empty
if [ ! "${KO}" ]; then
   echo "No kernel modules enabled in configuration! [${INI}]" 1>&2
   exit 1
fi

# Remove duplicates entries but do not change order
KO=$(echo $KO | tr ' ' '\n' | awk '!x[$1]++ { print $1 }' | tr '\n' ' ')

# Check VideoStation DTS status
check_videostation_dts

case $1 in
    start)
        ${SYNOCLI_KMODULE} load $KO

        # Create udev rules to set permissions to 666
        # Doing this at package start so it gets done even after DSM upgrade.
        if [ -f ${INSTALL_DIR}/rules.d/${UDEV_RULE} ]; then
           ln -s ${INSTALL_DIR}/rules.d/${UDEV_RULE} /lib/udev/rules.d/${UDEV_RULE}
           udevadm control --reload-rules
        fi

        # Resume any application that was started previously
        mgmnt_dvb_odev start

        exit $?
        ;;
    stop)
        # Stop any application using DVB device files
        mgmnt_dvb_odev stop

        ${SYNOCLI_KMODULE} unload $KO

        # remove udev rules for USB serial permissions
        if [ -h /lib/udev/rules.d/${UDEV_RULE} ]; then
           rm -f /lib/udev/rules.d/${UDEV_RULE}
           udevadm control --reload-rules
        fi

        exit $?
        ;;
    status)
        # Stop any application using DVB device files
        mgmnt_dvb_odev status

        if ${SYNOCLI_KMODULE} status $KO; then
            exit 0
        else
            exit 1
        fi
        ;;
    *)
        exit 1
        ;;
esac
