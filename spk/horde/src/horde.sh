#!/bin/sh

set -e

PHP="php -d include_path=/usr/local/horde/share/pear"
HORDE="/usr/local/horde/bin/horde-alarms"
SLEEP_TIME="600"

PHP_PEAR_SYSCONF_DIR=/usr/local/horde/etc

# Main loop
while true; do
    # Update
    echo "Updating..."
    ${PHP} ${HORDE}

    # Wait
    echo "Waiting ${SLEEP_TIME} seconds..."
    sleep ${SLEEP_TIME}
done