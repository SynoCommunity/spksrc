#!/bin/sh

LOCAL_BASE_URL=$(ip -4 addr show | awk '/inet / && !/127.0.0.1/ {sub(/\/.*/, "", $2); print "http://"$2; exit}')

WIZARD_CONTENT="$(cat << 'EOF'
[{
    "step_title": "Server configuration",
    "invalid_next_disabled": true,
    "items": [{
        "type": "textfield",
        "desc": "Public facing base URL of the service. This setting is required for any of the following features:<br/>&nbsp;&bull; attachments (to return a download URL)<br/>&nbsp;&bull; e-mail sending (for the topic URL in the email footer)<br/>&nbsp;&bull; iOS push notifications for self-hosted servers (to calculate the Firebase poll_request topic)<br/>&nbsp;&bull; Matrix Push Gateway (to validate that the pushkey is correct)",
        "subitems": [{
            "key": "wizard_base_url",
            "desc": "Base URL",
            "defaultValue": "@@_local_base_url_@@",
            "validator": {
                "allowBlank": true
            }
        }]
    }]
}]
EOF
)"

OUTPUT=$(echo $WIZARD_CONTENT | sed "s#@@_local_base_url_@@#${LOCAL_BASE_URL}#g")

echo $OUTPUT > $SYNOPKG_TEMP_LOGFILE

exit 0
