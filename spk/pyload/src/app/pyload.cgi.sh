#!/bin/sh

CFGFILE=/usr/local/pyload/etc/pyload.conf

PROTO_S=$(sed -ne '/^webinterface/,/https/{/https/s/^.*=[[:space:]]*true/s/Ip}' ${CFGFILE})
PORT=$(sed -ne '/^webinterface/,/port/{/port/s/^.*=[[:space:]]*\([0-9]\+\)$/\1/p}' ${CFGFILE})

echo -ne "Location: http${PROTO_S}://${SERVER_NAME}:${PORT}\n\n"

