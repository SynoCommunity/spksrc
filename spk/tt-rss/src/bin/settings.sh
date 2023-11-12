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
    INSTALL_DIR="/var/packages/${PACKAGE}/target"
fi

if [ -z "${LOGS_DIR}" ]
then
    LOGS_DIR="${INSTALL_DIR}/var/logs"
fi

if [ -z "${WEB_DIR}" ]
then
    WEB_DIR="/var/services/web"
fi

LOG_FILE="${LOGS_DIR}/${PACKAGE}.log"
if [ ! -f "${LOG_FILE}" ]
then
    touch "${LOG_FILE}"
    chown http:http "${LOG_FILE}"
    chmod 770 "${LOG_FILE}"
fi

PHP_ID=php74
PHP="/usr/local/bin/${PHP_ID}"

php_options()
{
    for line in $(cat ${INSTALL_DIR}/etc/php/conf.d/com.synocommunity.tt-rss.ini)
    do
        echo -n " -d ${line}"
    done
}

# Computes the PHP cli configuration file which should be used when running php code
guess_php_configuration_file()
{
    local web_station_configuration_file
    web_station_configuration_file="${WEB_STATION_HOME_DIR}/etc/${PHP_ID}/php.ini"
    if [ -f "${web_station_configuration_file}" ]
    then
        echo -n "${web_station_configuration_file}"
    elif [ -f "/usr/local/etc/${PHP_ID}/cli/php.ini" ]
    then
        echo -n "/usr/local/etc/${PHP_ID}/cli/php.ini"
    else
        echo -n "/usr/local/etc/${PHP_ID}/php.ini"
    fi
}

# Computes the command which should be run to execute php code
# Examples:
#   - guess_php
#   - guess_php <profile_name>
guess_php()
{
    echo -n "${PHP} -c $(guess_php_configuration_file)"
}
