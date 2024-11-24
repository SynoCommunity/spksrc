#!/bin/bash

# for backwards compatability
if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
	if [ -z "${SYNOPKG_PKGDEST_VOL}" ]; then
		SYNOPKG_PKGDEST_VOL="/volume1"
	fi
	if [ -z "${SYNOPKG_PKGNAME}" ]; then
		SYNOPKG_PKGNAME="owncloud"
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

ERROR_TEXT="{{{OWNCLOUD_PATH_VALIDATION_ERROR_TEXT}}}"

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

PAGE_DATA_BACKUP=$(/bin/cat<<EOF
{
	"step_title": "{{{OWNCLOUD_BACKUP_SERVER_STEP_TITLE}}}",
	"invalid_next_disabled_v2": true,
	"items": [{
		"desc": "{{{OWNCLOUD_BACKUP_SERVER_DESCRIPTION}}}"
	}, {
		"type": "password",
		"desc": "{{{MYSQL_ROOT_PASSWORD_DESCRIPTION}}}",
		"subitems": [{
			"key": "wizard_mysql_password_root",
			"desc": "{{{MYSQL_ROOT_PASSWORD_LABEL}}}",
			"validator": {
				"allowBlank": false
			}
		}]
	}, {
		"type": "textfield",
		"desc": "{{{OWNCLOUD_BACKUP_EXPORT_LOCATION_DESCRIPTION}}}",
		"subitems": [{
			"key": "wizard_export_path",
			"desc": "{{{OWNCLOUD_BACKUP_EXPORT_LOCATION_LABEL}}}",
			"emptyText": "${SYNOPKG_PKGDEST_VOL}/${SYNOPKG_PKGNAME}/backup",
			"validator": {
				"allowBlank": true,
				"fn": "$(getValidPath)"
			}
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

main () {
	local uninstall_page=""
	uninstall_page=$(page_append "$uninstall_page" "$PAGE_DATA_BACKUP")
	echo "[$uninstall_page]" > "${SYNOPKG_TEMP_LOGFILE}"
}

main "$@"
