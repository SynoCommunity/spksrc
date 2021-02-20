#!/bin/sh

# Configs
CFG=/var/packages/${SYNOPKG_PKGNAME}/target/etc/${SYNOPKG_PKGNAME}.cfg
INI=/var/packages/${SYNOPKG_PKGNAME}/target/etc/${SYNOPKG_PKGNAME}.ini

# Others
INSTALL_DIR="/usr/local/${SYNOPKG_PKGNAME}"
PATH="${INSTALL_DIR}/bin:${PATH}"
UDEV_RULE=60-${SYNOPKG_PKGNAME}.rules
FIRMWARE_PATH="/var/packages/${SYNOPKG_PKGNAME}/target/lib/firmware/"

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

case $1 in
    start)
        ${SYNOCLI_KMODULE} load $KO

        # Create udev rules to set permissions to 666
        # Doing this at package start so it gets done even after DSM upgrade.
        if [ -f ${INSTALL_DIR}/rules.d/${UDEV_RULE} ]; then
           ln -s ${INSTALL_DIR}/rules.d/${UDEV_RULE} /lib/udev/rules.d/${UDEV_RULE}
           udevadm control --reload-rules
        fi

        exit $?
        ;;
    stop)
        ${SYNOCLI_KMODULE} unload $KO

        # remove udev rules for USB serial permissions
        if [ -h /lib/udev/rules.d/${UDEV_RULE} ]; then
           rm -f /lib/udev/rules.d/${UDEV_RULE}
           udevadm control --reload-rules
        fi

        exit $?
        ;;
    restart)
        ${SYNOCLI_KMODULE} unload $KO
        ${SYNOCLI_KMODULE} load $KO
        exit $?
        ;;
    status)
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
