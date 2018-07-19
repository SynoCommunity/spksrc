#!/bin/sh

SECRET="$(dd if=/dev/urandom bs=16 count=1 2>&1 | od -tx1  | head -n1 | tail -c +9 | tr -d ' ' | tr '[:upper:]' '[:lower:]')"
IP="$(curl -s -4 "https://digitalresistance.dog/myIp")"

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
    "activeate": "{(function(step,ip){if(step.getNext()!=='applyStep'){return}var d=document,$s=d.querySelector('input[name=\"wizard_proxy_secrets\"]'),$p=d.querySelector('input[name=\"wizard_proxy_port\"]'),$l=d.getElementById('wizard_proxy_tg_links'),s=$s.value.split(','),p=$p.value,c='';s.forEach(function(k){var link='tg://proxy?server='+ip+'&port='+p+'&secret='+k;c+='<p><a href=\"'+link+'\" target=\"_blank\">'+link+'</a></p>'});$l.innerHTML=c;}).call(this,arguments[0],'@proxy_ip@');}",
    "items": [{
        "desc": "Your proxy links, please save them:"
    }, {
        "desc": "<span id=\"wizard_proxy_tg_links\"></span>"
    }]
}]
EOF
)"

OUTPUT=$(echo $WIZARD_CONTENT | sed "s#@proxy_secret@#${SECRET}#g" | sed "s#@proxy_ip@#${IP}#g")

echo $OUTPUT > $SYNOPKG_TEMP_LOGFILE
exit 0
