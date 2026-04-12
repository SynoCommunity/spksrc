#!/bin/bash

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

PAGE_ADMIN=$(/bin/cat<<EOF
{
    "step_title": "{{UNINSTALL_TITLE}}",
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
    }]
}
EOF
)

PAGE_EXPORT=$(/bin/cat<<EOF
{
    "step_title": "{{REMOVE_TT_RSS_TITLE}}",
    "invalid_next_disabled_v2": true,
    "items": [{
        "desc": "{{REMOVE_TT_RSS_DESC}}"
    }, {
        "type": "textfield",
        "desc": "{{DB_EXPORT_PATH_DESC}}",
        "subitems": [{
            "key": "wizard_dbexport_path",
            "desc": "{{DB_EXPORT_PATH_LABEL}}",
            "validator": {
                "allowBlank": true,
                "regex": {
                    "expr": "/^\\\\/(volume|volumeUSB)[0-9]+\\\\//",
                    "errorText": "{{DB_EXPORT_PATH_ERROR}}"
                }
            }
        }]
    }, {
        "type": "password",
        "desc": "{{DB_EXPORT_PASSWORD_DESC}}",
        "subitems": [{
            "key": "wizard_pg_password_ttrss",
            "desc": "{{DB_EXPORT_PASSWORD_LABEL}}"
        }]
    }, {
        "type": "singleselect",
        "subitems": [{
            "key": "wizard_delete_data",
            "hidden": true,
            "defaultValue": true
        }]
    }]
}
EOF
)

main ()
{
	local uninstall_page=""
	uninstall_page=$(page_append "$uninstall_page" "$PAGE_ADMIN")

	# Add export screen - always show it to allow skipping export
	uninstall_page=$(page_append "$uninstall_page" "$PAGE_EXPORT")

	echo "[$uninstall_page]" > "${SYNOPKG_TEMP_LOGFILE}"
}

main "$@"
