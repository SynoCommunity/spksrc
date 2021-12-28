#!/bin/sh

#SECRET="$(dd if=/dev/urandom bs=16 count=1 2>&1 | od -tx1  | head -n1 | tail -c +9 | tr -d ' ' | tr '[:upper:]' '[:lower:]')"
#IP="$(curl -s -4 "https://digitalresistance.dog/myIp")"

UID=$(id -u sc-arr-stack)
GID=$(id -g sc-arr-stack)
TZ=$(ls -l /etc/localtime | sed -e 's#.*zoneinfo\/##g')

WIZARD_CONTENT="$(cat << 'EOF'
[{
    "step_title": "Configuration",
    "invalid_next_disabled": true,
    "items": [{
        "type": "textfield",
        "subitems": [{
            "key": "wizard_tz",
            "desc": "Timezone",
            "defaultValue": "@tz@",
            "validator": {
                "allowBlank": false
            }
        }]
    }, {
        "type": "textfield",
        "subitems": [{
            "key": "wizard_uid",
            "desc": "UID",
            "defaultValue": "@uid@",
            "validator": {
                "allowBlank": false
            }
        }]
    }, {
        "type": "textfield",
        "subitems": [{
            "key": "wizard_gid",
            "desc": "GID",
            "defaultValue": "@gid@",
            "validator": {
                "allowBlank": true
            }
        }]
    }]
}]
EOF
)"

OUTPUT=$(echo $WIZARD_CONTENT | sed "s#@uid@#${UID}#g" | sed "s#@gid@#${GID}#g" | sed "s#@tz@#${TZ}#g")

echo $OUTPUT > $SYNOPKG_TEMP_LOGFILE
exit 0
