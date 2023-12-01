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
	return -1 !== password.search("(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[^A-Za-z0-9])(?=.{10,})") && ! password.includes("root");
}
EOF
)
	echo "$validator" | quote_json
}

PAGE_FFSYNC_REMOVE=$(/bin/cat<<EOF
{
	"step_title": "Remove Firefox Sync Server 1.5 database",
	"invalid_next_disabled_v2": true,
	"items": [{
		"desc": "Attention: The Firefox Sync Server 1.5 database will be removed during package uninstallation. All users and sync data will be deleted."
	}, {
		"type": "password",
		"desc": "Enter your MySQL password",
		"subitems": [{
			"key": "wizard_mysql_password_root",
			"desc": "Root password",
			"invalidText": "Invalid password. Please ensure it has at least one uppercase letter, one lowercase letter, one digit, one special character, a minimum length of 10 characters, and does not contain the word 'root'.",
			"validator": {
				"fn": "$(getPasswordValidator)"
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
					"expr": "/^\\\/volume[0-9]+\\\//",
					"errorText": "Path should begin with /volume?/ with ? the number of the volume"
				}
			}
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
