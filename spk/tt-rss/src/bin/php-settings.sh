#!/bin/bash

SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
source "${SCRIPT_DIR}/settings.sh"

profile_name="$(${SCRIPT_DIR}/guess-php-profile-name)"

php_configuration_file=
php_fpm="$(${SCRIPT_DIR}/guess-php-fpm-bin ${profile_name})"
if [ -z "${php_fpm}" ]
then
    php=php
    php_configuration_file=/etc/php/php.ini
else
    php="$(echo ${php_fpm} | sed 's/-fpm//g')"
    php_configuration_file="$(${SCRIPT_DIR}/guess-php-configuration-file ${php})"
fi