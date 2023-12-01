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

getPasswordValidator()
{
    validator=$(/bin/cat<<EOF
{
    var password = arguments[0];
    return -1 !== password.search("(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[^A-Za-z0-9])(?=.{10,})") && ! password.includes("root");
}
EOF
)
    echo "$validator" | quote_json
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
            "invalidText": "Invalid password. Please ensure it has at least one uppercase letter, one lowercase letter, one digit, one special character, a minimum length of 10 characters, and does not contain the word 'root'.",
            "validator": {
                "fn": "$(getPasswordValidator)"
            }
        }]
    }, {
        "type": "password",
        "desc": "A 'ffsync' user and database will be created. Please enter a password for the 'ffsync' user.",
        "subitems": [{
            "key": "wizard_password_ffsync",
            "desc": "ffsync password",
            "invalidText": "Invalid password. Please ensure it has at least one uppercase letter, one lowercase letter, one digit, one special character, a minimum length of 10 characters, and does not contain the word 'root'.",
            "validator": {
                "fn": "$(getPasswordValidator)"
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
