#!/bin/sh

INST_ETC="/var/packages/${SYNOPKG_PKGNAME}/etc"
INST_VARIABLES="${INST_ETC}/installer-variables"

# Reload wizard variables stored by postinst
if [ -r "${INST_VARIABLES}" ]; then
    . "${INST_VARIABLES}"
fi

cat <<EOF > $SYNOPKG_TEMP_LOGFILE
[{
    "step_title": "Setting PostgreSQL parameters",
    "items": [{
        "type": "textfield",
        "desc": "User's login. Defaults to pgadmin",
        "subitems": [{
            "key": "wizard_pg_username",
            "desc": "Login",
            "defaultValue": "${SAVE_PG_USERNAME}"
        }]
    }, {
        "type": "password",
        "desc": "User's password. Defaults to changepassword",
        "subitems": [{
            "key": "wizard_pg_password",
            "desc": "Password",
            "defaultValue": "${SAVE_PG_PASSWORD}"
        }]
    }, {
        "type": "textfield",
        "desc": "Server Port. Defaults to 5433 (5432 already used by Synology)",
        "subitems": [{
            "key": "wizard_pg_port",
            "desc": "Server Port",
            "defaultValue": "${SAVE_PG_PORT}"
        }]
    }]
}]
EOF
exit 0
