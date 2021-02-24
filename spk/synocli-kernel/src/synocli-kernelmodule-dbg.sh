#!/bin/bash

DATE=`date --utc +%Y%m%d-%H%M`
LOG=/tmp/synocli-kernelmodule-dbg.${DATE}.log
exec > >(tee $LOG) 2>&1

echo "Date: ${DATE}"
echo "uptime: $(uptime)"

echo "--------------------------------------"
echo "Running kernel"
uname -a
echo

echo "--------------------------------------"
echo "synokernel-usbserial"
echo "==="
synoservice --status pkgctl-synokernel-usbserial
echo "==="
echo "synokernel-usbserial.ini"
cat /var/packages/synokernel-usbserial/target/etc/synokernel-usbserial.ini
echo "==="
echo "synokernel-usbserial.cfg"
cat /var/packages/synokernel-usbserial/target/etc/synokernel-usbserial.cfg
echo "==="
[ -f /tmp/synocli-kernelmodule-synokernel-usbserial.log ] \
   && tail -25 /tmp/synocli-kernelmodule-synokernel-usbserial.log \
   || echo "No log available..."
echo

echo "--------------------------------------"
echo "synokernel-linuxtv"
echo "==="
synoservice --status pkgctl-synokernel-linuxtv
echo "==="
echo "/lib/udev/script/DTV_enabled"
cat /lib/udev/script/DTV_enabled
echo "==="
echo "synokernel-linuxtv.ini"
cat /var/packages/synokernel-linuxtv/target/etc/synokernel-linuxtv.ini
echo "==="
echo "synokernel-linuxtv.cfg"
cat /var/packages/synokernel-linuxtv/target/etc/synokernel-linuxtv.cfg
echo "==="
[ -f /tmp/synocli-kernelmodule-synokernel-linuxtv.log ] \
   && tail -50 /tmp/synocli-kernelmodule-synokernel-linuxtv.log \
   || echo "No log available..."
echo

echo "--------------------------------------"
echo "/var/packages/synocli-kernel/target/bin/usb-devices"
/var/packages/synocli-kernel/target/bin/usb-devices
echo

echo "--------------------------------------"
echo "lsusb -I"
lsusb -I
echo

echo "--------------------------------------"
echo "lsmod"
lsmod
echo

echo "--------------------------------------"
echo "dmesg"
dmesg -T
echo
