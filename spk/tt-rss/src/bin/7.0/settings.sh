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
    WEB_DIR="/var/services/web_packages"
fi

LOG_FILE="${LOGS_DIR}/${PACKAGE}.log"
if [ ! -f "${LOG_FILE}" ]
then
    touch "${LOG_FILE}"
    chgrp http "${LOG_FILE}"
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
    echo -n "/usr/local/bin/php74-fpm"
}

# Computes the PHP cli configuration file which should be used when running php code
guess_php_configuration_file()
{
    php_profile=$(jq -r 'to_entries[] | select(.key != "version") | select(.value.profile_name=="tt-rss") | .key ' "${WEB_STATION_HOME_DIR}/etc/PHPSettings.json")
    echo "/var/packages/WebStation/etc/php_profile/${php_profile}/conf.d/user_settings.ini"
}

# Computes the command which should be run to execute php code
# Examples:
#   - guess_php
guess_php()
{
    echo -n "/usr/local/bin/php74 -c $(guess_php_configuration_file)"
}
