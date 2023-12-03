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

PAGE_FFSYNC_SETUP=$(/bin/cat<<EOF
{
    "step_title": "Firefox Sync Server 1.5 database configuration",
    "invalid_next_disabled_v2": true,
    "items": [{
        "type": "password",
        "desc": "Enter your MySQL root password",
        "subitems": [{
            "key": "wizard_mysql_password_root",
            "desc": "Root password",
            "validator": {
                "allowBlank": false
            }
        }]
    }]
}, {
    "step_title": "Public URL",
    "items": [{
        "type": "textfield",
        "desc": "Provide the client-visible URL. The URL to configure on your device is:<br/><br>http://public-url:8132/token/1.0/sync/1.5<br/><br>Note: Configure a reverse proxy for SSL support",
        "subitems": [{
            "key": "wizard_ffsync_public_url",
            "desc": "Public URL",
            "emptyText": "http://hostname.domain:8132",
            "validator": {
                "allowBlank": false
            }
        }]
    }]
}
EOF
)

main () {
    local install_page=""
    install_page=$(page_append "$install_page" "$PAGE_FFSYNC_SETUP")
    echo "[$install_page]" > "${SYNOPKG_TEMP_LOGFILE}"
}

main "$@"
