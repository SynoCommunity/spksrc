# Fbguard binary is a wrapper around firebird that allows it to run as
# a daemon
FBGUARD_BIN_FILE="${SYNOPKG_PKGDEST}/bin/fbguard"
FB_SECDB="${SYNOPKG_PKGVAR}/security4.fdb"

# We set onetime because we want the systemd to take care about the failures
SERVICE_COMMAND="${FBGUARD_BIN_FILE} -pidfile ${PID_FILE} -daemon -onetime"

SYSDBA_PASSWORD_FILE="${SYNOPKG_PKGVAR}/SYSDBA.password"

validate_preupgrade () {
    # We must check that either SYSDBA.password or the security database
    # exists.
    # If neither of them is present, we don't know how to set the main
    # DB password.
    [ -f "$SYSDBA_PASSWORD_FILE" ] || [ -f "$FB_SECDB" ] || {
        echo "Neither SYSDBA.password nor security4.fdb exists."
        exit 1;    
    };
}

gen_password() {
    head -c20 /dev/urandom | base64
}

service_postinst () {
    cd "$SYNOPKG_PKGDEST"
    SET_PASSWD=false
    SECDB_CREATED=false

    # =================== Build Messages ========================
    # Build the firebird.msg file during both install and upgrade.
    # The messages differ across versions and must always match the binaries
    # version.
    # Building the messages should be first step because the tools used here
    # later are already expectine the message file to exist.
    bin/gbak -rep msg.gbak msg.fdb
    bin/build_file

    # Publish the message file so that other users can use isql
    # (isql and other cli tools access the file to translate sql errors)
    chmod go+r firebird.msg

    echo "Remove unnecessary intermediate files"
    rm -f bin/build_file msg.gbak msg.fdb

    # =================== Build Security Database ===============
    # Build security database only when none is present yet or we are being
    # installed
    if [ ! -f "$FB_SECDB" ] || [ "$SYNOPKG_PKG_STATUS" = "INSTALL" ];then
        bin/gbak -rep security4.gbak "$FB_SECDB"

        # We just built the security database. We must also set the password.
        SECDB_CREATED=true
    fi
    
    # We already built the DB. This is no longer needed.
    rm -f security4.gbak

    # =================== Set SYSDBA password ===================
    #
    # Setting the SYSDBA password is somewhat tricky:
    # - When being installed from the UI, the password is provided by the wizard
    # - When being installed from cli, no wizard runs and we get empty string
    #       in such case we generate new password and announce it in the log.
    # - When upgrading, we usually don't have to do anything, unless the user
    #       deleted the security database and is re-installing the package
    #       to fix it. Then:
    #       o We either use the password from SYSDBA.password file (if it exists)
    #       o Or generate new random password and announce it in the log.
    # - Upgrades where security.db exists are best because we don't do anything.
    #
    if [ "$SYNOPKG_PKG_STATUS" = "INSTALL" ]; then
        if [ "x$wizard_sysdba_password" = "x" ]; then
            # User provided new password. We override the password file even
            # if it exists because the user expects to have the new password.
            gen_password > "$SYSDBA_PASSWORD_FILE";
        else
            # Use the users password
            printf "%s" "$wizard_sysdba_password" > "$SYSDBA_PASSWORD_FILE"
        fi
        SET_PASSWD=true
    else #UPGRADING
        if $SECDB_CREATED && [ ! -f "$SYSDBA_PASSWORD_FILE" ]; then
            # We are upgrading/re-installing and the user deleted 
            # both the password file and the database file
            gen_password > "$SYSDBA_PASSWORD_FILE";
            SET_PASSWD=true
        fi
    fi

    # =================== Set SYSDBA password ===================
    if "$SET_PASSWD"; then
        # The file must exist otherwise we wouldn't be here
        SYSDBA_PASSWORD="$(cat "$SYSDBA_PASSWORD_FILE")"

        echo "Setting 'SYSDBA' password to '${SYSDBA_PASSWORD}'";

        # The security.db here refers to the database alias defined in
        # databases.conf and does not reflect the real file location
        echo "create or alter user SYSDBA password '$SYSDBA_PASSWORD' using plugin Srp; commit; quit;" \
           | bin/isql -user sysdba security.db
    fi
}

