#!/bin/bash

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

PAGE_ADMIN=$(cat <<EOF
{
    "step_title": "PostgreSQL Configuration",
    "invalid_next_disabled_v2": true,
    "items": [{
        "type": "textfield",
        "desc": "PostgreSQL admin username",
        "subitems": [{
            "key": "wizard_pg_username_admin",
            "desc": "Username",
            "defaultValue": "pgadmin"
        }]
    }, {
        "type": "password",
        "desc": "PostgreSQL admin password",
        "subitems": [{
            "key": "wizard_pg_password_admin",
            "desc": "Password",
            "validator": {
                "allowBlank": false
            }
        }]
    }]
}
EOF
)

PAGE_EXPORT=$(cat <<EOF
{
    "step_title": "Remove Immich Database",
    "invalid_next_disabled_v2": true,
    "items": [{
        "desc": "Immich will remove the PostgreSQL database. You can optionally export a backup first."
    }, {
        "type": "textfield",
        "desc": "Export path (leave empty to skip backup)",
        "subitems": [{
            "key": "wizard_dbexport_path",
            "desc": "Export path",
            "validator": {
                "allowBlank": true,
                "regex": {
                    "expr": "/^\\\\\\/(volume|volumeUSB)[0-9]+\\\\\\//",
                    "errorText": "Path must start with /volumeX/ or /volumeUSBX/"
                }
            }
        }]
    }, {
        "type": "password",
        "desc": "Immich database user password (required for export)",
        "subitems": [{
            "key": "wizard_pg_password_immich",
            "desc": "Database password"
        }]
    }, {
        "type": "singleselect",
        "subitems": [{
            "key": "wizard_delete_data",
            "hidden": true,
            "defaultValue": true
        }]
    }]
}
EOF
)

main ()
{
    local uninstall_page=""
    uninstall_page=$(page_append "$uninstall_page" "$PAGE_ADMIN")
    uninstall_page=$(page_append "$uninstall_page" "$PAGE_EXPORT")
    echo "[$uninstall_page]" > "${SYNOPKG_TEMP_LOGFILE}"
}

main "$@"
