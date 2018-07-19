#!/bin/sh

gen_secret() {
    echo $(dd if=/dev/urandom bs=16 count=1 2>&1 | od -tx1  | head -n1 | tail -c +9 | tr -d ' ' | tr '[:upper:]' '[:lower:]')
}

WIZARD_CONTENT="$(cat << 'EOF'
[{
    "step_title": "Server configuration",
    "invalid_next_disabled": true,
    "items": [{
        "type": "textfield",
        "subitems": [{
            "key": "wizard_proxy_port",
            "desc": "Proxy port",
            "defaultValue": "1984",
            "validator": {
                "allowBlank": false,
                "regex": {
                    "expr": "/^[1-9][0-9]{2,4}$/",
                    "errorText": "Port must be in range 100-65535"
                }
            }
        }]
    }, {
        "type": "textfield",
        "subitems": [{
            "key": "wizard_proxy_workers",
            "desc": "Number of workers",
            "defaultValue": "2",
            "validator": {
                "allowBlank": false,
                "regex": {
                    "expr": "/^([1-9]|1[0-6])$/",
                    "errorText": "Can be between 1 and 16 workers"
                }
            }
        }]
    }]
}, {
    "step_title": "MTProto configuration",
    "invalid_next_disabled": true,
    "activate": "{console.log('activate', arguments);}",
    "items": [{
        "type": "textfield",
        "subitems": [{
            "key": "wizard_proxy_secrets",
            "desc": "Secret keys (comma-separated)",
            "defaultValue": "@proxy_secret@",
            "validator": {
                "allowBlank": false,
                "regex": {
                    "expr": "/^[0-9a-fA-F]{32}(,[0-9a-fA-F]{32}){0,15}$/",
                    "errorText": "Bad secret format: should be 32 hex chars (for 16 bytes) for every secret; secrets should be comma-separated"
                }
            }
        }]
    }, {
        "type": "textfield",
        "subitems": [{
            "key": "wizard_proxy_tag",
            "desc": "Tag",
            "defaultValue": "",
            "validator": {
                "allowBlank": true,
                "regex": {
                    "expr": "/^[0-9a-fA-F]{32}$/",
                    "errorText": "Bad tag format: should be 32 hex chars (for 16 bytes)"
                }
            }
        }]
    }, {
        "desc": "You can get tag from <a href=\"https://t.me/MTProxybot\" target=\"_blank\">@MTProxybot</a> after registering proxy"
    }]
}]
EOF
)"

SECRET=$(gen_secret)
OUTPUT=$(echo $WIZARD_CONTENT | sed "s#@proxy_secret@#${SECRET}#g")

echo $OUTPUT > $SYNOPKG_TEMP_LOGFILE
exit 0
