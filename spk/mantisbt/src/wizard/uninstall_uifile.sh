#!/bin/bash

# for backwards compatability
if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
	if [ -z "${SYNOPKG_PKGDEST_VOL}" ]; then
		SYNOPKG_PKGDEST_VOL="/volume1"
	fi
	if [ -z "${SYNOPKG_PKGNAME}" ]; then
		SYNOPKG_PKGNAME="mantisbt"
	fi
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
	"step_title": "Remove MantisBT database",
	"invalid_next_disabled_v2": true,
	"items": [{
		"desc": "Attention: The '${SYNOPKG_PKGNAME}' database will be removed during package uninstallation. All bug reports will be deleted."
	}, {
		"type": "password",
		"desc": "Enter your MySQL superuser account password",
		"subitems": [{
			"key": "wizard_mysql_password_root",
			"desc": "MySQL 'root' password",
			"validator": {
				"allowBlank": false
			}
		}]
	}, {
		"type": "textfield",
		"desc": "Before uninstalling, if you want to keep a backup of your data, please specify the directory where you would like to export to. Ensure that the user 'sc-mantisbt' has write permissions to that directory. To skip exporting, leave this field blank.",
		"subitems": [{
			"key": "wizard_export_path",
			"desc": "Export location",
			"emptyText": "${SYNOPKG_PKGDEST_VOL}/${SYNOPKG_PKGNAME}/backup",
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
