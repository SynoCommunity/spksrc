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

PAGE_FFSYNC_REMOVE=$(/bin/cat<<EOF
{
	"step_title": "Remove Mozilla Sync Server database",
	"invalid_next_disabled_v2": true,
	"items": [{
		"desc": "Attention: The Mozilla Sync Server database will be removed during package uninstallation. All users and sync data will be deleted."
	}, {
		"type": "password",
		"desc": "Enter your MySQL password",
		"subitems": [{
			"key": "wizard_mysql_password_root",
			"desc": "Root password",
			"validator": {
				"allowBlank": false
			}
		}]
	}, {
		"type": "textfield",
		"desc": "Optional: Provide directory for database export. Leave blank to skip export. The directory will be created if it does not exist",
		"subitems": [{
			"key": "wizard_dbexport_path",
			"desc": "Database export location",
			"validator": {
				"allowBlank": true,
				"regex": {
					"expr": "/^\\\/(volume|volumeUSB)[0-9]+\\\//",
					"errorText": "Path should begin with /volume?/ with ? the number of the volume"
				}
			}
		}]
	}, {
		"type": "singleselect",
		"subitems": [{
			"defaultValue": true,
			"hidden": true,
			"key": "wizard_delete_data"
		}]
	}]
}
EOF
)

main () {
	local uninstall_page=""
	uninstall_page=$(page_append "$uninstall_page" "$PAGE_FFSYNC_REMOVE")
	echo "[$uninstall_page]" > "${SYNOPKG_TEMP_LOGFILE}"
}

main "$@"
