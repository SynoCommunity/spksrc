#!/bin/sh

set -e

PHP="php"
SELFOSS="/var/services/web/selfoss/update.php"
SLEEP_TIME="600"

# Main loop
while true; do
    # Update
    echo "Updating..."
    ${PHP} ${SELFOSS}

    # Wait
    echo "Waiting ${SLEEP_TIME} seconds..."
    sleep ${SLEEP_TIME}
done
