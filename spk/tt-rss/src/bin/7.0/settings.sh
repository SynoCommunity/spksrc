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
    LOGS_DIR="/var/packages/${PACKAGE}/var/logs"
fi

if [ -z "${WEB_DIR}" ]
then
    WEB_DIR="/var/webservices/web"
fi

LOG_FILE="${LOGS_DIR}/${PACKAGE}.log"
if [ ! -f "${LOG_FILE}" ]
then
    touch "${LOG_FILE}"
    chown http:http "${LOG_FILE}"
    chmod 770 "${LOG_FILE}"
fi

php_options()
{
    for line in $(cat ${INSTALL_DIR}/etc/php/conf.d/com.synocommunity.tt-rss.ini)
    do
        echo -n " -d ${line}"
    done
}

# Computes the name of the PHP profile currently being used by the WebStation
guess_php_profile_name()
{
    echo -n "tt-rss"
}

# Computes the PHP fpm binary executable
# Examples:
#   - guess_php_fpm_bin
#   - guess_php_fpm_bin <profile_name>
guess_php_fpm_bin()
{
    echo -n "/usr/local/bin/php73-fpm"
}

# Computes the PHP cli configuration file which should be used when running php code
# Examples:
#   - guess_php_configuration_file
#   - guess_php_configuration_file php56
#   - guess_php_configuration_file php74
guess_php_configuration_file()
{
    local php_bin
    local web_station_configuration_file
    local php_fpm
    if [ $# -eq 0 ]
    then
        php_fpm="$(guess_php_fpm_bin)"
        if [ -z "${php_fpm}" ]
        then
            echo -n "/etc/php/php.ini"
            return 0
        fi
        php_bin="$(echo ${php_fpm} | sed 's/-fpm//g')"
    else
        php_bin=$1
    fi
    web_station_configuration_file="${WEB_STATION_HOME_DIR}/etc/${php_bin}/php.ini"
    if [ -f "${web_station_configuration_file}" ]
    then
        echo -n "${web_station_configuration_file}"
    elif [ -f "/usr/local/etc/${php_bin}/cli/php.ini" ]
    then
        echo -n "/usr/local/etc/${php_bin}/cli/php.ini"
    else
        echo -n "/usr/local/etc/${php_bin}/php.ini"
    fi
}

# Computes the command which should be run to execute php code
# Examples:
#   - guess_php
guess_php()
{
    local php

    php="/usr/local/bin/php73"
    echo -n "/usr/local/bin/php73 -c $(guess_php_configuration_file ${php})"
}
