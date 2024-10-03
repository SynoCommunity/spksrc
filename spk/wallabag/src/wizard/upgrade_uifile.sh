#!/bin/bash

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

checkDatabaseUpgrade()
{
    if [[ "${SYNOPKG_OLD_PKGVER}" =~ ^[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+-[[:digit:]]+$ ]]; then
        SPK_REV="${SYNOPKG_OLD_PKGVER##*-}"
        if [[ "${SPK_REV}" -le 3 ]]; then
            return 0  # true
        else
            return 1  # false
        fi
    else
        return 1  # false
    fi
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

PAGE_UPGRADE_CONFIG=$(/bin/cat<<EOF
{
    "step_title": "Wallabag upgrade",
    "items": [{
        "desc": "The upgrading process ensures that your configurations and files are saved prior to updating your setup."
    }, {
        "type": "multiselect",
        "subitems": [{
            "key": "wizard_create_db",
            "desc": "Creates initial DB",
            "defaultValue": false,
            "hidden": true
        }, {
            "key": "mysql_grant_user",
            "desc": "Initializes user rights",
            "defaultValue": false,
            "hidden": true
        }]
    }]
}
EOF
)

PAGE_MIGRATE_DATABASE=$(/bin/cat<<EOF
{
    "step_title": "Wallabag DB migration",
    "invalid_next_disabled_v2": true,
    "items": [{
        "desc": "Enter your respective Maria DB installation 'root' account passwords",
        "type": "password",
        "subitems": [{
            "key": "wizard_mariadb5_password_root",
            "desc": "Maria DB 5",
            "validator": {
                "allowBlank": false
            }
        }, {
            "key": "wizard_mysql_password_root",
            "desc": "Maria DB 10",
            "validator": {
                "allowBlank": false
            }
        }]
    }, {
        "desc": "A new '${SYNOPKG_PKGNAME}' user will be created. Please enter a password for the '${SYNOPKG_PKGNAME}' user.",
        "type": "password",
        "subitems": [{
            "key": "wizard_mysql_database_password",
            "desc": "MySQL '${SYNOPKG_PKGNAME}' password",
            "invalidText": "Password is invalid. Ensure it includes at least one uppercase letter, one lowercase letter, one digit, one special character, and has a minimum length of 10 characters.",
            "validator": {
                "fn": "$(getPasswordValidator)"
            }
        }]
    }, {
        "type": "multiselect",
        "subitems": [{
            "key": "wizard_run_migration",
            "desc": "Run migration",
            "defaultValue": true,
            "hidden": true
        }, {
            "key": "wizard_create_db",
            "desc": "Creates initial DB",
            "defaultValue": false,
            "hidden": true
        }, {
            "key": "mysql_grant_user",
            "desc": "Initializes user rights",
            "defaultValue": true,
            "hidden": true
        }]
    }]
}
EOF
)

main () {
    local upgrade_page=""
    if checkDatabaseUpgrade; then
        upgrade_page=$(page_append "$upgrade_page" "$PAGE_MIGRATE_DATABASE")
    else
        upgrade_page=$(page_append "$upgrade_page" "$PAGE_UPGRADE_CONFIG")
    fi
    echo "[$upgrade_page]" > "${SYNOPKG_TEMP_LOGFILE}"
}

main "$@"
