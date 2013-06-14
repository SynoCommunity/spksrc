#!/bin/sh

set -e

PHP="php"
FENGOFFICE="/var/services/web/fengoffice/cron.php"
SLEEP_TIME="600"

# Main loop
while true; do
    # Update
    echo "Updating..."
    ${PHP} ${FENGOFFICE}

    # Wait
    echo "Waiting ${SLEEP_TIME} seconds..."
    sleep ${SLEEP_TIME}
done
