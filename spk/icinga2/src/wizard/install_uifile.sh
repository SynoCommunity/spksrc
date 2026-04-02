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

PAGE_DATABASE_SETUP=$(/bin/cat<<EOF
{
    "step_title": "Icinga 2 IDO Database Configuration",
    "invalid_next_disabled_v2": true,
    "items": [{
        "desc": "Icinga 2 uses an IDO (Icinga Data Output) database to store monitoring data. This database is required for Icinga Web 2 to display monitoring information. A MariaDB database and user will be created automatically."
    }, {
        "type": "password",
        "desc": "Enter your MariaDB 'root' password to create the IDO database.",
        "subitems": [{
            "key": "wizard_mysql_password_root",
            "desc": "MariaDB 'root' password",
            "validator": {
                "allowBlank": false
            }
        }]
    }, {
        "type": "password",
        "desc": "Set a password for the icinga2 database user.",
        "subitems": [{
           "key": "wizard_ido_db_password",
            "desc": "IDO database password",
              "validator": {
                  "allowBlank": false,
                  "minLength": 10,
                 "regex": {
                     "expr": "/^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[^a-zA-Z0-9]).{10,}$/",
                     "errorText": "Password must be 10+ characters with uppercase, lowercase, number, and special character"
                 }
             }
        }]
    }, {
        "desc": "<b>Note:</b> After installation, run the following commands as root to enable ping checks:<br><code>sudo chmod +s /bin/ping</code> and <code>sudo chmod +s /bin/ping6</code>"
    }]
}
EOF
)

main () {
    local install_page=""
    install_page=$(page_append "$install_page" "$PAGE_DATABASE_SETUP")
    echo "[$install_page]" > "${SYNOPKG_TEMP_LOGFILE}"
}

main "$@"
