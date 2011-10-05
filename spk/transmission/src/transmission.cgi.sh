#!/bin/sh

if /usr/local/etc/rc.d/transmission.sh status >/dev/null
then
  echo "Location: http://`echo ${HTTP_HOST} | cut -d':' -f1`:9091/"
  echo
fi
