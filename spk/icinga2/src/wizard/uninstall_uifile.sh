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

PAGE_DATABASE_REMOVE=$(/bin/cat<<EOF
{
    "step_title": "Remove Icinga 2 Database",
    "invalid_next_disabled_v2": true,
    "items": [{
        "desc": "<b>Warning:</b> The IDO database '${IDO_DB_NAME:-icinga_ido}' and user '${IDO_DB_USER:-icinga2}' will be removed during uninstallation.<br><br>All monitoring history data will be permanently deleted."
    }, {
        "type": "password",
        "desc": "Enter your MariaDB 'root' password to remove the database.",
        "subitems": [{
            "key": "wizard_mysql_password_root",
            "desc": "MariaDB 'root' password",
            "validator": {
                "allowBlank": false
            }
        }]
    }, {
        "type": "multiselect",
        "subitems": [{
            "key": "wizard_delete_data",
            "hidden": true,
            "defaultValue": true
        }]
    }]
}
EOF
)

main () {
    local uninstall_page=""
    uninstall_page=$(page_append "$uninstall_page" "$PAGE_DATABASE_REMOVE")
    echo "[$uninstall_page]" > "${SYNOPKG_TEMP_LOGFILE}"
}

main "$@"
