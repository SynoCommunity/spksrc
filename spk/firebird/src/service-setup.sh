#!/bin/sh

FBGUARD_BIN_FILE="${SYNOPKG_PKGDEST}/bin/fbguard"

# We set onetime because we want the systemd to take care about the failures
SERVICE_COMMAND="${FBGUARD_BIN_FILE} -pidfile ${PID_FILE} -daemon -onetime"

SYSDBA_PASSWORD_FILE="${SYNOPKG_PKGDEST}/SYSDBA.password"

service_postinst () {
    set -x
    cd "$SYNOPKG_PKGDEST" || exit 1
    bin/gbak -rep msg.gbak msg.fdb
    bin/build_file

    # Make the message file accessible so other users can use isql
    chmod go+r firebird.msg

    bin/gbak -rep security4.gbak security4.fdb

    echo "Remove unnecessary intermediate files"
    rm -f bin/build_file msg.gbak msg.fdb security4.gbak

    if [ ! -f "${SYSDBA_PASSWORD_FILE}" ];then
        SYSDBA_PASSWORD="${wizard_sysdba_password}"

        echo "Setting 'SYSDBA' password to '${SYSDBA_PASSWORD}'";

        echo "create or alter user SYSDBA password '$SYSDBA_PASSWORD' using plugin Srp; commit; quit;" \
           | bin/isql -user sysdba security.db

        echo "$SYSDBA_PASSWORD" > "${SYSDBA_PASSWORD_FILE}";
    fi

    set +x
}

