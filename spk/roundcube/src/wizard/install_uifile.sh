#!/bin/bash

# for backwards compatability
if [ -z "${SYNOPKG_PKGDEST_VOL}" ]; then
    SYNOPKG_PKGDEST_VOL="/volume1"
fi

quote_json ()
{
    sed -e 's|\\|\\\\|g' -e 's|\"|\\\"|g'
}

page_append ()
{
    if [ -z "$1" ]; then
        echo "$2"
    elif [ -z "$2" ]; then
        echo "$1"
    else
        echo "$1,$2"
    fi
}

TYPE_STEP_TITLE="Roundcube Webmail installation type"
DATABASE_STEP_TITLE="Roundcube Webmail database configuration"
HOST_STEP_TITLE="Roundcube Webmail hosts configuration"
SMTP_STEP_TITLE="Roundcube Webmail SMTP configuration"
CONFIRM_STEP_TITLE="Roundcube Webmail confirm restore"
PHP_STEP_TITLE="Multiple PHP profiles"
RESTORE_BACKUP_FILE="wizard_roundcube_restore"
BACKUP_FILE_PATH="wizard_backup_file"
RESTORE_ERROR_TEXT="An empty file path is not allowed when restore is enabled."

checkBackupRestore()
{
    CHECK_BACKUP_RESTORE=$(/bin/cat<<EOF
{
    var backupFilePath = arguments[0];
    var step = arguments[2];
    var backupRestore = step.getComponent("${RESTORE_BACKUP_FILE}");
    if (backupRestore.checked) {
        if (backupFilePath === "") {
            return "${RESTORE_ERROR_TEXT}";
        }
    }
    return true;
}
EOF
)
    echo "$CHECK_BACKUP_RESTORE" | quote_json
}

checkBackupFile()
{
    CHECK_BACKUP_FILE=$(/bin/cat<<EOF
{
    var backupRestore = arguments[0];
    var step = arguments[2];
    var backupFilePath = step.getComponent("${BACKUP_FILE_PATH}");
    if (backupRestore) {
        backupFilePath.setDisabled(false);
    } else {
        backupFilePath.setValue("");
        backupFilePath.setDisabled(true);
    }
    return true;
}
EOF
)
    echo "$CHECK_BACKUP_FILE" | quote_json
}

jsFunction=$(/bin/cat<<EOF
    function findStepByTitle(wizardDialog, title) {
        for (var i = wizardDialog.customuiIds.length - 1 ; i >= 0 ; i--) {
            var step = wizardDialog.getStep(wizardDialog.customuiIds[i]);
            if (title === step.headline) {
                return step;
            }
        }
        return null;
    }
    function isRestoreChecked(wizardDialog) {
        var typeStep = findStepByTitle(wizardDialog, "${TYPE_STEP_TITLE}");
        if (!typeStep) {
            return false;
        } else {
            return typeStep.getComponent("${RESTORE_BACKUP_FILE}").checked;
        }
    }
EOF
)

getActiveate()
{
    ACTIVAETE=$(/bin/cat<<EOF
{
    ${jsFunction}
    var currentStep = arguments[0];
    var wizardDialog = currentStep.owner;
    var dbStep = findStepByTitle(wizardDialog, "${DATABASE_STEP_TITLE}");
    var hostStep = findStepByTitle(wizardDialog, "${HOST_STEP_TITLE}");
    var confirmStep = findStepByTitle(wizardDialog, "${CONFIRM_STEP_TITLE}");
    var restoreChecked = isRestoreChecked(wizardDialog);
    if (currentStep.headline === "${HOST_STEP_TITLE}") {
        if (restoreChecked) {
            wizardDialog.goBack(dbStep.itemId);
            wizardDialog.goNext(confirmStep.itemId);
        }
    } else if (currentStep.headline === "${CONFIRM_STEP_TITLE}") {
        if (!restoreChecked) {
            wizardDialog.goBack(dbStep.itemId);
            wizardDialog.goNext(hostStep.itemId);
        }
    }
}
EOF
)
    echo "$ACTIVAETE" | quote_json
}

getDeActiveate()
{
    DEACTIVAETE=$(/bin/cat<<EOF
{
    ${jsFunction}
    var currentStep = arguments[0];
    var wizardDialog = currentStep.owner;
    var dbStep = findStepByTitle(wizardDialog, "${DATABASE_STEP_TITLE}");
    var hostStep = findStepByTitle(wizardDialog, "${HOST_STEP_TITLE}");
    var smtpStep = findStepByTitle(wizardDialog, "${SMTP_STEP_TITLE}");
    var confirmStep = findStepByTitle(wizardDialog, "${CONFIRM_STEP_TITLE}");
    var phpStep = findStepByTitle(wizardDialog, "${PHP_STEP_TITLE}");
    var restoreChecked = isRestoreChecked(wizardDialog);
    if (currentStep.headline === "${TYPE_STEP_TITLE}") {
        if (!phpStep) {
            smtpStep.nextId = "applyStep";
        } else {
            smtpStep.nextId = phpStep.itemId;
        }
        if (restoreChecked) {
            dbStep.nextId = confirmStep.itemId;
        } else {
            dbStep.nextId = hostStep.itemId;
        }
    }
}
EOF
)
    echo "$DEACTIVAETE" | quote_json
}

getPasswordValidator()
{
    validator=$(/bin/cat<<EOF
{
    var password = arguments[0];
    return -1 !== password.search("(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[^A-Za-z0-9])(?=.{10,})");
}
EOF
)
    echo "$validator" | quote_json
}

# Check for multiple PHP profiles
check_php_profiles ()
{
    SC_PKG_PREFIX="com-synocommunity-packages-"
    SC_PKG_NAME="${SC_PKG_PREFIX}${SYNOPKG_PKGNAME}"
    PHP_CFG_PATH="/usr/syno/etc/packages/WebStation/PHPSettings.json"
    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ] && \
        jq -e 'to_entries | map(select((.key | startswith("'"${SC_PKG_PREFIX}"'")) and .key != "'"${SC_PKG_NAME}"'")) | length > 0' "${PHP_CFG_PATH}" >/dev/null; then
        return 0  # true
    else
        return 1  # false
    fi
}

PAGE_ADMIN_CONFIG=$(/bin/cat<<EOF
{
    "step_title": "${TYPE_STEP_TITLE}",
    "invalid_next_disabled_v2": true,
    "deactivate_v2": "$(getDeActiveate)",
    "items": [{
        "type": "singleselect",
        "desc": "For the installation, you have the option to either create a new instance or restore from a backup archive.",
        "subitems": [{
            "key": "wizard_roundcube_install",
            "desc": "Install new deployment",
            "defaultValue": true
        }, {
            "key": "${RESTORE_BACKUP_FILE}",
            "desc": "Restore from archive",
            "defaultValue": false,
            "validator": {
                "fn": "$(checkBackupFile)"
            }
        }]
    }, {
        "type": "textfield",
        "desc": "Please provide the complete path to the archive you wish to restore.",
        "subitems": [{
            "key": "${BACKUP_FILE_PATH}",
            "desc": "Backup file location",
            "disabled": true,
            "emptyText": "${SYNOPKG_PKGDEST_VOL}/${SYNOPKG_PKGNAME}/backup",
            "validator": {
                "fn": "$(checkBackupRestore)"
            }
        }]
    }]
}, {
    "step_title": "${DATABASE_STEP_TITLE}",
    "invalid_next_disabled_v2": true,
    "items": [{
        "type": "password",
        "desc": "Enter your MySQL superuser account password",
        "subitems": [{
            "key": "wizard_mysql_password_root",
            "desc": "MySQL 'root' password",
            "validator": {
                "allowBlank": false
            }
        }]
    }, {
        "type": "password",
        "desc": "A '${SYNOPKG_PKGNAME}' MySQL user and database will be created. Please provide a password for the '${SYNOPKG_PKGNAME}' user.",
        "subitems": [{
            "key": "wizard_mysql_password_roundcube",
            "desc": "MySQL '${SYNOPKG_PKGNAME}' password",
            "invalidText": "Password is invalid. Ensure it includes at least one uppercase letter, one lowercase letter, one digit, one special character, and has a minimum length of 10 characters.",
            "validator": {
                "fn": "$(getPasswordValidator)"
            }
        }]
    }, {
        "type": "multiselect",
        "subitems": [{
            "key": "wizard_create_db",
            "desc": "Creates initial DB",
            "defaultValue": true,
            "hidden": true
        }, {
            "key": "mysql_grant_user",
            "desc": "Configures user rights",
            "defaultValue": true,
            "hidden": true
        }]
    }]
}, {
    "step_title": "${HOST_STEP_TITLE}",
    "invalid_next_disabled_v2": true,
    "activate_v2": "$(getActiveate)",
    "items": [{
        "type": "textfield",
        "desc": "Log-in IMAP server. Leave blank to show a textbox at login. (Sample usage: 'ssl://imap.gmail.com:993', 'localhost', or blank)",
        "subitems": [{
            "key": "wizard_roundcube_imap_host",
            "desc": "Default host"
        }]
    }, {
        "type": "textfield",
        "desc": "SMTP server. (Sample usage: 'ssl://smtp.gmail.com:465', 'localhost', or blank for PHP mail() function)",
        "subitems": [{
            "key": "wizard_roundcube_smtp_host",
            "desc": "SMTP server",
            "defaultValue": "localhost"
        }]
    }]
}, {
    "step_title": "${SMTP_STEP_TITLE}",
    "invalid_next_disabled_v2": true,
    "items": [{
        "type": "textfield",
        "desc": "SMTP username (if required)",
        "subitems": [{
            "key": "wizard_roundcube_smtp_user",
            "desc": "SMTP username"
        }]
    }, {
        "type": "password",
        "desc": "SMTP password (if required)",
        "subitems": [{
            "key": "wizard_roundcube_smtp_pass",
            "desc": "SMTP password"
        }]
    }]
}, {
    "step_title": "${CONFIRM_STEP_TITLE}",
    "invalid_next_disabled_v2": true,
    "activate_v2": "$(getActiveate)",
    "items": [{
        "desc": "The installation will now proceed, and your previous configuration will be restored from the backup. Please verify that the file path is accurate and that the user 'sc-roundcube' has read permissions for that path."
    }]
}
EOF
)

PAGE_PHP_PROFILES=$(/bin/cat<<EOF
{
    "step_title": "${PHP_STEP_TITLE}",
    "items": [{
        "desc": "Attention: Multiple PHP profiles detected; the package webpage will not display until a DSM restart is performed to load new configurations."
    }]
}
EOF
)

main () {
    local install_page=""
    install_page=$(page_append "$install_page" "$PAGE_ADMIN_CONFIG")
    if check_php_profiles; then
        install_page=$(page_append "$install_page" "$PAGE_PHP_PROFILES")
    fi
    echo "[$install_page]" > "${SYNOPKG_TEMP_LOGFILE}"
}

main "$@"
