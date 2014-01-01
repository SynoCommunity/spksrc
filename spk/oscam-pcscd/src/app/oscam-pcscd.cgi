#!/bin/sh
if [ `ifconfig bond0 | grep "inet addr" | wc -l` -gt 0  ]; then
IP_ADDR=`ifconfig bond0 | grep "inet addr" | awk '{print $2}' | awk -F: '{print $2}'`
else
IP_ADDR=`ifconfig eth0 | grep "inet addr" | awk '{print $2}' | awk -F: '{print $2}'`
fi
echo Location: http://$IP_ADDR:16001
echo ""
exit 0
