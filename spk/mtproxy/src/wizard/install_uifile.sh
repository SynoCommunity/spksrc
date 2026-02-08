#!/bin/sh

SECRET="$(dd if=/dev/urandom bs=16 count=1 2>&1 | od -tx1  | head -n1 | tail -c +9 | tr -d ' ' | tr '[:upper:]' '[:lower:]')"
IP="$(curl -s -4 "https://digitalresistance.dog/myIp")"

WIZARD_CONTENT="$(cat << 'EOF'
[{
    "step_title": "Server configuration",
    "invalid_next_disabled": true,
    "items": [{
        "desc": "Please read <a href=\"https://github.com/TelegramMessenger/MTProxy/blob/master/README.md\" target=\"_blank\">MTProxy documentation</a> before you start"
    }, {
        "type": "textfield",
        "subitems": [{
            "key": "wizard_proxy_internal_ip",
            "desc": "Internal IP address",
            "defaultValue": "",
            "validator": {
                "allowBlank": true,
                "regex": {
                    "expr": "/^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/",
                    "errorText": "Incorrect IP address"
                }
            }
        }]
    }, {
        "type": "textfield",
        "subitems": [{
            "key": "wizard_proxy_external_ip",
            "desc": "External IP address",
            "defaultValue": "",
            "validator": {
                "allowBlank": true,
                "regex": {
                    "expr": "/^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/",
                    "errorText": "Incorrect IP address"
                }
            }
        }]
    }, {
        "desc": "Leave IP addresses blank if you don't know them or your addresses are dynamic"
    }, {
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
}, {
    "step_title": "Information",
    "invalid_next_disabled": true,
    "activeate": "{(function(step,ip){if(step.getNext()!=='applyStep'){return}var d=document,p=d.querySelector('input[name=\"wizard_proxy_port\"]').value,$l=d.getElementById('wizard_proxy_tg_link'),$t=d.getElementById('wizard_proxy_tg_links'),r=d.querySelector('input[name=\"wizard_proxy_secrets\"]').value.split(',').map(function(k){return 'tg://proxy?server='+ip+'&port='+p+'&secret='+k}).join(\"\\n\");$t.value=r;$l.href=URL.createObjectURL(new Blob([r]))}).call(this,arguments[0],'@proxy_ip@');}",
    "items": [{
        "desc": "<h3>Your proxy links, please save them:</h3>"
    }, {
        "desc": "<textarea readonly wrap=\"off\" id=\"wizard_proxy_tg_links\" class=\"x-form-text x-form-field syno-ux-textfield x-item-disabled\" style=\"width:100%;height:10em;overflow:auto;background-image:none;margin-bottom:4px\"></textarea><a href=\"#\" id=\"wizard_proxy_tg_link\" download=\"MTProxy.txt\">Download proxy links as file</a>"
    }, {
        "type": "multiselect",
        "subitems": [{
            "key": "wizard_proxy_confirm",
            "desc": "I saved the links",
            "defaultVaule": false,
            "validator": {
                "fn": "{return arguments[0];}"
             }
        }]
    }]
}]
EOF
)"

OUTPUT=$(echo $WIZARD_CONTENT | sed "s#@proxy_secret@#${SECRET}#g" | sed "s#@proxy_ip@#${IP}#g")

echo $OUTPUT > $SYNOPKG_TEMP_LOGFILE
exit 0
