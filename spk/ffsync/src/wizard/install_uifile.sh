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
    var ipRegex = /^http:\/\/(?:\d{1,3}\.){3}\d{1,3}:8132$/;
    var domainRegex = /^https?:\/\/(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}(?::813[23])?$/;
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
        "desc": "Enter your MariaDB root password",
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
        "desc": "<b>Client URL:</b> Enter the publicly accessible URL. If using a domain, ensure it follows the format <nobr><code>http[s]://hostname.domain[:8132|:8133]</code></nobr>.",
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
        "desc": "<b>Firefox Desktop Configuration:</b> In Firefox, navigate to <code>about:config</code>, then update <nobr><code>identity.sync.tokenserver.uri</code></nobr> with the following URL.",
        "subitems": [{
            "key": "client_ffsync_public_url",
            "desc": "Desktop Config"
        }]
    }, {
        "desc": "<b>Additional Configuration:</b> For SSL setup with a reverse proxy and Firefox mobile configuration, visit our <a href=\"https://github.com/SynoCommunity/spksrc/wiki/Mozilla-Sync-Server\" target=\"_blank\">Mozilla Sync Server wiki</a>."
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
