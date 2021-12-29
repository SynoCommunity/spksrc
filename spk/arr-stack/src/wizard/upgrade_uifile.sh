#!/bin/sh

IP=$(cat /run/dms.ip)
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
    }, {
        "type": "textfield",
        "desc": "If you already have a server, you can claim it by grabbing the code at <a href=\"https://plex.tv/claim\">plex.tv/claim</a>",
        "subitems": [{
            "key": "wizard_plex_claim",
            "desc": "Plex claim code",
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
                "allowBlank": false
            }
        }]
    }, {
        "type": "textfield",
        "subitems": [{
            "key": "wizard_allowed_networks",
            "desc": "Plex Allowed Networks",
            "defaultValue": "192.168.0.0/24",
            "validator": {
                "allowBlank": true
            }
        }]
    }, {
        "type": "combobox",
        "subitems": [{
            "key": "wizard_plex_pass",
            "desc": "Plex Pass",
            "editable": false,
            "displayField": "display_name",
            "valueField": "value",
            "mode": "local",
            "store": {
                "xtype": "arraystore",
                "fields": ["value", "display_name"],
                "data": [["yes", "Yes"], ["no", "No"]]
            },
            "validator": {
                "fn": "{var v=arguments[0]; console.log(v);if (!v) return 'Select an option';return true;}"
            }
        }]
    }]
}]
EOF
)"

OUTPUT=$(echo $WIZARD_CONTENT | sed "s#@uid@#${NEW_UID}#g" | sed "s#@gid@#${NEW_GID}#g" | sed "s#@tz@#${TZ}#g" | sed "s#@public_ip@#${IP}#g")

echo $OUTPUT > $SYNOPKG_TEMP_LOGFILE
exit 0
