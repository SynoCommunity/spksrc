#!/bin/sh

CFG_FILE="${SYNOPKG_PKGDEST}/var/influxdb.conf"
BIN="${SYNOPKG_PKGDEST}/bin/influxd"

SERVICE_COMMAND="${BIN} -config ${CFG_FILE} -pidfile ${PID_FILE} &"

