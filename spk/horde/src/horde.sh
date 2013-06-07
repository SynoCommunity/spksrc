#!/bin/sh

set -e

PACKAGE="horde"
INSTALL_DIR="/usr/local/${PACKAGE}"
PHP="php -d include_path=${INSTALL_DIR}/share/pear"
HORDE="${INSTALL_DIR}/bin/horde-alarms"
SLEEP_TIME="600"

# Main loop
while true; do
    # Update
    echo "Updating..."
    PHP_PEAR_SYSCONF_DIR=${INSTALL_DIR}/etc ${PHP} ${HORDE}

    # Wait
    echo "Waiting ${SLEEP_TIME} seconds..."
    sleep ${SLEEP_TIME}
done