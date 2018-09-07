#!/bin/sh

PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin

if ls /etc/safekeep/backup.d/*.backup 1>/dev/null 2>&1; then
    safekeep -v --server
fi
