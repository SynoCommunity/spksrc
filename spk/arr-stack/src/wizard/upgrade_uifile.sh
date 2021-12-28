#!/bin/sh

IP="$(curl -qs4 https://icanhazip.com)"
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
                "allowBlank": false
            }
        }]
    }, {
        "type": "textfield",
        "subitems": [{
            "key": "wizard_plex_claim",
            "desc": "Plex Claim",
            "defaultValue": "",
            "validator": {
                "allowBlank": true
            }
        }]
    }, {
        "type": "textfield",
        "subitems": [{
            "key": "wizard_plex_ip",
            "desc": "Plex Advertise IP",
            "defaultValue": "@public_ip@",
            "validator": {
                "allowBlank": true
            }
        }]
    }, {
        "type": "textfield",
        "subitems": [{
            "key": "wizard_allowed_networks",
            "desc": "Plex Allowed Networks",
            "defaultValue": "",
            "validator": {
                "allowBlank": true
            }
        }]
    }, {
        "type": "textfield",
        "subitems": [{
            "key": "wizard_plex_pass",
            "desc": "Plex Pass",
            "defaultValue": "",
            "validator": {
                "allowBlank": true
            }
        }]
    }]
}]
EOF
)"

OUTPUT=$(echo $WIZARD_CONTENT | sed "s#@uid@#${NEW_UID}#g" | sed "s#@gid@#${NEW_GID}#g" | sed "s#@tz@#${TZ}#g" | sed "s#@public_ip@#${IP}#g")

echo $OUTPUT > $SYNOPKG_TEMP_LOGFILE
exit 0
