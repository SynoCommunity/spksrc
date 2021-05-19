#!/bin/sh

SPKETC="/var/packages/${SYNOPKG_PKGNAME}/etc"
INSTALLER_VARIABLES="${SPKETC}/installer-variables"

# Reload wizard variables stored by postinst
if [ -r "${INSTALLER_VARIABLES}" ]; then
    . "${INSTALLER_VARIABLES}"
fi

cat <<EOF > $SYNOPKG_TEMP_LOGFILE
[{
    "step_title": "Set country and region",
    "items": [{
        "type": "singleselect",
        "desc": "Location",
        "subitems": [{
            "key": "zap2it_CAN",
            "desc": "Canada",
            "defaultValue": "${ZAP2IT_CAN}"
        },{
            "key": "zap2it_US",
            "desc": "United States",
            "defaultValue": "${ZAP2IT_US}"
        }]
    },{
        "type": "textfield",
        "subitems": [{
            "key": "zap2it_code",
            "desc": "Postal or ZIP code",
            "emptyText": "90210 or J9J1Z1",
            "defaultValue": "${ZAP2IT_CODE}",
            "validator": {
                "vtype": "alphanum",
                "regex": {
                    "expr": "/^[0-9]{5}$|^[A-Z][0-9][A-Z][ ]?[0-9][A-Z][0-9]$/i"
                }
            }
        }]
    },{
        "type": "textfield",
        "subitems": [{
            "key": "zap2it_days",
            "desc": "TV Guide Numbers of days (max. 14)",
            "defaultValue": "${ZAP2IT_DAYS}",
            "validator": {
                "vtype": "alphanum",
                "regex": {
                    "expr": "/^[1-9]$|^1[0-4]$/i"
                }
            }
        }]
    }]
}, {
    "step_title": "Set username and password",
    "items": [{
        "type": "textfield",
        "desc": "User account to connect to <a target=\"_blank\" href=\"https://tvlistings.zap2it.com\">tvlistings.zap2it.com</a>",
        "subitems": [{
            "key": "zap2it_user",
            "desc": "Username",
            "emptyText": "abc@xyz.com",
            "defaultValue": "${ZAP2IT_USER}",
            "validator": {
                "vtype": "email"
            }
        }]
    },{
        "type": "password",
        "desc": " ",
        "subitems": [{
            "key": "zap2it_password",
            "desc": "Password",
            "emptyText": "(leave blank to keep existing password)",
            "defaultValue": ""
        }]
    }]
}]
EOF
exit 0
