#!/bin/sh

PKGNAME="dnsmasq"
PKGPATH="/var/packages/"${PKGNAME}

DNSPKG=`ls -l ${PKGPATH}/target | awk -F "-> " '{print $2}'`

BINPATH="sbin"
CONFPATH="etc"
LOGPATH="log"
LEASEPATH="lease"

DNSBIN="dnsmasq"
DNSCONF="dnsmasq.conf"
DNSLOG="dnsmasq.log" 
DNSLEASE="dnsmasq.lease" 

DNSSTART=${DNSPKG}/${BINPATH}/${DNSBIN}
DNSSTART=${DNSSTART}" --conf-file=${DNSPKG}/${CONFPATH}/${DNSCONF}"
DNSSTART=${DNSSTART}" --log-facility=${DNSPKG}/${LOGPATH}/${DNSLOG}"
DNSSTART=${DNSSTART}" --dhcp-leasefile=${DNSPKG}/${LEASEPATH}/${DNSLEASE}"

case $1 in
	start)
		echo "Starting dnsmasq ..."
		${DNSSTART}
		exit 0
	;;
	stop)
		echo "Stopping dnsmasq ..."
		killall ${DNSBIN}
		exit 0
	;;
	status)
		ps | grep -v grep | grep ${BINPATH}/${DNSBIN} > /dev/null
		if [ $? -ne 0 ]; then
			echo "Status: dnsmasq is not running"
			exit 1
		fi
		echo "Status: dnsmasq is running"
		exit 0
	;;
esac

