#!/bin/sh

NEW_UID=$(id -u sc-$SYNOPKG_PKGNAME)
NEW_GID=$(id -g sc-$SYNOPKG_PKGNAME)
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
            "hidden": true,
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
            "hidden": true,
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
            "hidden": true,
            "validator": {
                "allowBlank": false
            }
        }]
    }]
}]
EOF
)"

OUTPUT=$(echo $WIZARD_CONTENT | sed "s#@uid@#${NEW_UID}#g" | sed "s#@gid@#${NEW_GID}#g" | sed "s#@tz@#${TZ}#g")

echo $OUTPUT > $SYNOPKG_TEMP_LOGFILE
exit 0
