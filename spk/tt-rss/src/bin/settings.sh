#!/bin/bash

if [ -z "${WEB_STATION_HOME_DIR}" ]
then
    WEB_STATION_HOME_DIR="/var/packages/WebStation"
fi

if [ -z "${PACKAGE}" ]
then
    PACKAGE="tt-rss"
fi

if [ -z "${INSTALL_DIR}" ]
then
    INSTALL_DIR="/usr/local/${PACKAGE}"
fi

if [ -z "${LOGS_DIR}" ]
then
    LOGS_DIR="${INSTALL_DIR}/var/logs"
fi