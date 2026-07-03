#!/bin/sh

# Extract version components from SYNOPKG_OLD_PKGVER (format: X.Y.Z-R)
OLD_VERSION="${SYNOPKG_OLD_PKGVER%-*}"
OLD_MAJOR="${OLD_VERSION%%.*}"
OLD_MINOR_PATCH="${OLD_VERSION#*.}"
OLD_MINOR="${OLD_MINOR_PATCH%%.*}"

# Display wizard only for upgrades from versions < 2.1.0
# v2.1.0 introduced the built-in monitoring dashboard
if [ -n "${OLD_MAJOR}" ] && [ "${OLD_MAJOR}" -eq 2 ] && [ "${OLD_MINOR}" -lt 1 ]; then

cat <<EOF > "${SYNOPKG_TEMP_LOGFILE}"
[{
    "step_title": "New Monitoring Dashboard",
    "items": [{
        "desc": "This update replaces the configuration editor with a built-in monitoring dashboard that displays real-time DNS query statistics.<br><br>Set your dashboard credentials below. Leave password blank to disable authentication.<br>The dashboard will be accessible on port 8153."
    }, {
        "type": "textfield",
        "subitems": [{
            "key": "wizard_ui_user",
            "desc": "Username",
            "defaultValue": "admin",
            "validator": {
                "allowBlank": false,
                "minLength": 1
            }
        }]
    }, {
        "type": "password",
        "subitems": [{
            "key": "wizard_ui_pass",
            "desc": "Password",
            "defaultValue": "",
            "validator": {
                "allowBlank": true
            }
        }]
    }, {
        "desc": "Your existing DNS configuration will be preserved."
    }]
}]
EOF

fi
exit 0
