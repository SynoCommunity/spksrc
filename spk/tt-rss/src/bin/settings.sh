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
    local profile_name
    profile_name=$(jq -r .default.php "${WEB_STATION_HOME_DIR}/etc/WebStation.json" 2>>"${LOG_FILE}")
    if [ $? -ne 0 ]
    then
        echo "Failed identifying php profile name." >>"${LOG_FILE}"
        return 1
    fi

    if [ -z "${profile_name}" ]
    then
        echo "Invalid empty profile name found" >>"${LOG_FILE}"
        return 2
    fi

    echo -n "${profile_name}"
}

# Computes the PHP fpm binary executable
# Examples:
#   - guess_php_fpm_bin
#   - guess_php_fpm_bin <profile_name>
guess_php_fpm_bin()
{
    local profile_name
    local profile_path
    local fpm_configuration_file
    local php_fpm
    if [ $# -eq 0 ]
    then
        profile_name=$(guess_php_profile_name)
    else
        profile_name=$1
    fi
    profile_path="${WEB_STATION_HOME_DIR}/etc/php_profile/${profile_name}"
    fpm_configuration_file="${profile_path}/fpm.conf"

    if [ -f "${fpm_configuration_file}" ]
    then
        php_fpm=$(php -r 'print(parse_ini_file($argv[1], true)["global"]["syslog.ident"]);' "${fpm_configuration_file}" 2>>"${LOG_FILE}")
        if [ $? -ne 0 ]
        then
            echo "Failed computing php fpm path." >>"${LOG_FILE}"
            return 1
        fi
    else
        echo "No fpm configuration file can be found under ${fpm_configuration_file}" >>"${LOG_FILE}"
        return 1
    fi

    echo -n "${php_fpm}"
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
#   - guess_php <profile_name>
guess_php()
{
    local profile_name
    local php_fpm
    local php
    if [ $# -eq 0 ]
    then
        profile_name=$(guess_php_profile_name)
        if [ $? -ne 0 ]
        then
            echo "Failed computing PHP profile name" >>"${LOG_FILE}"
            return 1
        fi
    else
        profile_name=$1
    fi


    php_fpm="$(guess_php_fpm_bin ${profile_name})"
    if [ -z "${php_fpm}" ]
    then
        echo -n "php -c /etc/php/php.ini"
    else
        php="$(echo ${php_fpm} | sed 's/-fpm//g')"
        echo -n "${php} -c $(guess_php_configuration_file ${php})"
    fi
}
