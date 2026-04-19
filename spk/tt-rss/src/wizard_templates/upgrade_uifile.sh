#!/bin/bash

quote_json ()
{
	sed -e 's|\\|\\\\|g' -e 's|\"|\\\"|g'
}

page_append ()
{
	if [ -z "$1" ]; then
		echo "$2"
	elif [ -z "$2" ]; then
		echo "$1"
	else
		echo "$1,$2"
	fi
}

getPasswordValidator()
{
	validator=$(/bin/cat<<EOF
{
    var password = arguments[0];
    return -1 !== password.search("(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[^A-Za-z0-9])(?=.{10,})");
}
EOF
)
	echo "$validator" | quote_json
}

PAGE_MIGRATION=$(/bin/cat<<EOF
{
    "step_title": "{{MIGRATION_SETTINGS_TITLE}}",
    "invalid_next_disabled_v2": true,
    "items": [{
        "desc": "{{MIGRATION_NOTICE_DESC}}"
    }, {
        "type": "password",
        "desc": "{{MARIADB_ROOT_PASSWORD_DESC}}",
        "subitems": [{
            "key": "wizard_mysql_password_root",
            "desc": "{{ENTER_MARIADB_ROOT_PASSWORD}}"
        }]
    }]
}
EOF
)

PAGE_POSTGRESQL=$(/bin/cat<<EOF
{
    "step_title": "{{POSTGRESQL_SETTINGS_TITLE}}",
    "invalid_next_disabled_v2": true,
    "items": [{
        "type": "textfield",
        "desc": "{{POSTGRESQL_USERNAME_DESC}}",
        "subitems": [{
            "key": "wizard_pg_username_admin",
            "desc": "{{POSTGRESQL_USERNAME_LABEL}}",
            "defaultValue": "pgadmin"
        }]
    }, {
        "type": "password",
        "desc": "{{POSTGRESQL_PASSWORD_DESC}}",
        "subitems": [{
            "key": "wizard_pg_password_admin",
            "desc": "{{POSTGRESQL_PASSWORD_LABEL}}",
            "validator": {
                "allowBlank": false
            }
        }]
    }, {
        "type": "textfield",
        "desc": "{{POSTGRESQL_PORT_DESC}}",
        "subitems": [{
            "key": "wizard_pg_port",
            "desc": "{{POSTGRESQL_PORT_LABEL}}",
            "defaultValue": "5433"
        }]
    }, {
        "type": "password",
        "desc": "{{TTRSS_PASSWORD_DESC}}",
        "subitems": [{
            "key": "wizard_pg_password_ttrss",
            "desc": "{{ENTER_TTRSS_PASSWORD}}",
            "invalidText": "{{INVALID_TTRSS_PASSWORD}}",
            "validator": {
                "fn": "$(getPasswordValidator)"
            }
        }]
    }]
}
EOF
)

main ()
{
	local upgrade_page=""

	# Only show wizard for upgrades from MariaDB version (rev < 21)
	SPK_REV="${SYNOPKG_OLD_PKGVER//[0-9]*-/}"
	if [ -n "$SPK_REV" ] && [ "$SPK_REV" -lt 21 ] 2>/dev/null; then
		upgrade_page=$(page_append "$upgrade_page" "$PAGE_MIGRATION")
		upgrade_page=$(page_append "$upgrade_page" "$PAGE_POSTGRESQL")
	fi

	echo "[$upgrade_page]" > "${SYNOPKG_TEMP_LOGFILE}"
}

main "$@"
