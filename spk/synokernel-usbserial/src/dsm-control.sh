#!/bin/sh

# Package
PACKAGE="synokernel-usbserial"

# Configs
CFG=/var/packages/${PACKAGE}/target/etc/${PACKAGE}.cfg
INI=/var/packages/${PACKAGE}/target/etc/${PACKAGE}.ini

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:${PATH}"
SYNOCLI_KMODULE="/usr/local/bin/synocli-kernelmodule -n ${PACKAGE} -a"
UDEV_RULE=60-${PACKAGE}.rules

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

case $1 in
    start)
        ${SYNOCLI_KMODULE} load $KO

        # Create udev rules to set permissions to 666 
        # Doing this at package start so it gets done even after DSM upgrade.  
        ln -s ${INSTALL_DIR}/rules.d/${UDEV_RULE} /lib/udev/rules.d/${UDEV_RULE}
        udevadm control --reload-rules

        exit $?
        ;;
    stop)
        ${SYNOCLI_KMODULE}unload $KO

        # remove udev rules for USB serial permissions
        rm -f /lib/udev/rules.d/${UDEV_RULE}
        udevadm control --reload-rules

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
