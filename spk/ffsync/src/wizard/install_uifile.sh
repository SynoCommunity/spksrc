#!/bin/bash

INTERNAL_IP=$(ip -4 route get 8.8.8.8 | awk '/8.8.8.8/ && /src/ {print $NF}')

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

checkPublicUrl()
{
    CHECK_PUBLIC_URL=$(/bin/cat<<EOF
{
    var publicUrl = arguments[0];
    var step = arguments[2];
    var clientUrl = step.getComponent("client_ffsync_public_url");
    var ipRegex = /^http:\/\/(\d{1,3}\.){3}\d{1,3}:8132$/;
    var domainRegex = /^http:\/\/((?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}):8132$/;
    if (ipRegex.test(publicUrl) || domainRegex.test(publicUrl)) {
        clientUrl.setReadOnly(false);
        clientUrl.setValue(publicUrl + "/1.0/sync/1.5");
        clientUrl.setReadOnly(true);
    } else {
        return "Invalid URL format. Please provide a valid URL.";
    }
    return true;
}
EOF
)
    echo "$CHECK_PUBLIC_URL" | quote_json
}

PAGE_FFSYNC_SETUP=$(/bin/cat<<EOF
{
    "step_title": "Mozilla Sync Server database configuration",
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
    "invalid_next_disabled_v2": true,
    "items": [{
        "type": "textfield",
        "desc": "Please provide the client-visible URL. If utilizing a domain, ensure it follows the format http://hostname.domain:8132",
        "subitems": [{
            "key": "wizard_ffsync_public_url",
            "desc": "Public URL",
            "defaultValue": "http://${INTERNAL_IP}:8132",
            "validator": {
                "fn": "$(checkPublicUrl)"
            }
        }]
    }, {
        "type": "textfield",
        "desc": "To configure your Firefox browser, go to <code>about:config</code>. Change <code>identity.sync.tokenserver.uri</code> to the following URL:",
        "subitems": [{
            "key": "client_ffsync_public_url",
            "grow": true
        }]
    }, {
        "desc": "Note: For SSL support, set up a reverse proxy"
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
