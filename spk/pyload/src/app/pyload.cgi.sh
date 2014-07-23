#!/bin/sh
configfile="/usr/local/pyload/var/pyload.conf"

host=$(hostname -i | sed 's/ //g')

`grep -i "bool https : \"Use HTTPS\""  $configfile | grep -i true`
if test $? -eq 0
then
	protocol="https"
else
	protocol="http"
fi

port=$(sed -n '/webinterface/,/port/p' $configfile | grep port | awk -F" " '{print $NF}')

echo "Location: $protocol://$host:$port"
