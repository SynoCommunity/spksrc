#!/bin/bash

# for backwards compatability
if [ "$SYNOPKG_DSM_VERSION_MAJOR" -lt 7 ] && [ -z "${SYNOPKG_PKGDEST_VOL}" ]; then
	SYNOPKG_PKGDEST_VOL="/volume1"
fi

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

ERROR_TEXT="Path should begin with /volume?/ with ? the number of the volume"

getValidPath()
{
	VALID_PATH=$(/bin/cat<<EOF
{
	var exportPath = arguments[0];
	const pattern = /^\/(volume|volumeUSB)[0-9]+\//;
	if (exportPath === "") {
		return true;
	} else if (pattern.test(exportPath)) {
		return true;
	} else {
		return "${ERROR_TEXT}";
	}
}
EOF
)
	echo "$VALID_PATH" | quote_json
}

PAGE_UNINSTALL_CONFIG=$(/bin/cat<<EOF
{
	"step_title": "Remove fengoffice database",
	"invalid_next_disabled_v2": true,
	"items": [{
		"desc": "Attention: The fengoffice database will be removed during package uninstallation. All users and projects will be deleted."
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
			"emptyText": "${SYNOPKG_PKGDEST_VOL}/backup",
			"validator": {
				"allowBlank": true,
				"fn": "$(getValidPath)"
			}
		}]
	}, {
		"type": "multiselect",
		"subitems": [{
			"key": "wizard_delete_data",
			"hidden": true,
			"defaultValue": true
		}]
	}]
}
EOF
)

main () {
	local uninstall_page=""
	uninstall_page=$(page_append "$uninstall_page" "$PAGE_UNINSTALL_CONFIG")
	echo "[$uninstall_page]" > "${SYNOPKG_TEMP_LOGFILE}"
}

main "$@"
