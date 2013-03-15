#!/bin/sh

set -e

PHP="php -d open_basedir= -d include_path=/usr/local/newznab/share/pear -d memory_limit=256M"
SCRIPTS_PATH="/var/services/web/newznab/misc/update_scripts"
SLEEP_TIME="10"
LASTOPTIMIZE=`date +%s`

while true; do
    cd ${SCRIPTS_PATH}

    # Update
    ${PHP} ${SCRIPTS_PATH}/update_binaries.php
    ${PHP} ${SCRIPTS_PATH}/update_releases.php

    # Optimize
    CURRTIME=`date +%s`
    DIFF=$(($CURRTIME-$LASTOPTIMIZE))
    if [ $DIFF -gt 86400 ]; then
        LASTOPTIMIZE=`date +%s`
        echo "Optimizing DB..."
        ${PHP} ${SCRIPTS_PATH}/optimise_db.php
    fi

    # Wait
    echo "Waiting ${SLEEP_TIME} seconds..."
    sleep ${SLEEP_TIME}
done
