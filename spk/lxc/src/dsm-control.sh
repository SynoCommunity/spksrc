#!/bin/sh

. /usr/syno/etc/iptables_modules_list

PREPACKAGED_MODULES="${KERNEL_MODULES_CORE} "
PREPACKAGED_MODULES+="${KERNEL_MODULES_COMMON} "
PREPACKAGED_MODULES+="${KERNEL_MODULES_NAT} "
PREPACKAGED_MODULES+="${TC_MODULES} "
PREPACKAGED_MODULES+="${IPV6_MODULES} "
PREPACKAGED_MODULES+="${TC_6_MODULES} "
PREPACKAGED_MODULES+="stp.ko bridge.ko br_netfilter.ko veth.ko "

SYNOMODULETOOL="/usr/syno/bin/synomoduletool"

MODULE_XT_CHECKSUM="${SYNOPKG_PKGDEST}/lib/modules/$(uname -r)/kernel/net/netfilter/xt_CHECKSUM.ko"

start ()
{
    echo "Inserting synology provided kernel modules"
    "${SYNOMODULETOOL}" --insmod "${SYNOPKG_PKGNAME}" ${PREPACKAGED_MODULES}

    if [ -f $MODULE_XT_CHECKSUM ]; then
        echo "Inserting the xt_CHECKSUM kernel module"
        insmod $MODULE_XT_CHECKSUM
    else
        echo "We do not have the xt_CHECKSUM kernel module"
    fi

    ${SYNOPKG_PKGDEST}/etc/init.d/lxc-net start
    ${SYNOPKG_PKGDEST}/etc/init.d/lxc start
}

stop ()
{
    ${SYNOPKG_PKGDEST}/etc/init.d/lxc stop
    ${SYNOPKG_PKGDEST}/etc/init.d/lxc-net stop

    # Try to remove xt_CHECKSUM but do no care if we fail
    if lsmod | grep -q "xt_CHECKSUM"; then
        echo "Removing the xt_CHECKSUM kernel module"
        rmmod xt_CHECKSUM
    else
        echo "The xt_CHECKSUM kernel module is already not loaded"
    fi
    
    echo "Remove synology provided kernel modules"
    "${SYNOMODULETOOL}" --rmmod "${SYNOPKG_PKGNAME}" ${PREPACKAGED_MODULES}
}

case $1 in
    start)
        start
        exit 0
        ;;
    stop)
        stop
        exit 0
        ;;
    status)
        if [ -f "/run/lxc/network_up" ]; then
            echo "${SYNOPKG_PKGNAME} is running"
            exit 0
        else
            echo "${SYNOPKG_PKGNAME} is not running"
            exit 3
        fi
        ;;
    log)
        exit 0
        ;;
    *)
        exit 1
        ;;
esac
