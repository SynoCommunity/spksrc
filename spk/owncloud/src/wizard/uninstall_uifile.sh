#!/bin/bash

WEB_DIR="/var/services/web_packages"
# for backwards compatability
if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ]; then
	WEB_DIR="/var/services/web"
	if [ -z ${SYNOPKG_PKGDEST_VOL} ]; then
		SYNOPKG_PKGDEST_VOL="/volume1"
	fi
	if [ -z ${SYNOPKG_PKGNAME} ]; then
		SYNOPKG_PKGNAME="owncloud"
	fi
fi
OCROOT="${WEB_DIR}/${SYNOPKG_PKGNAME}"

exec_occ() {
	PHP="/usr/local/bin/php74"
	OCC="${OCROOT}/occ"
	PKGUSER="sc-${SYNOPKG_PKGNAME}"
	OCC_ARGS=()
	for arg in "$@"; do
		OCC_ARGS+=("$arg")
	done
	COMMAND="${PHP} ${OCC} ${OCC_ARGS[@]}"
	if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
		OCC_OUTPUT=$(/bin/su "$PKGUSER" -s /bin/sh -c "$COMMAND")
	else
		OCC_OUTPUT=$($COMMAND)
	fi
	OCC_EXIT_CODE=$?
	echo "$OCC_OUTPUT"
	return $OCC_EXIT_CODE
}

quote_json () {
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

# Calculate size of data directory
DATADIR="$(exec_occ config:system:get datadirectory)"
# data directory fail-safe
if [ ! -d "$DATADIR" ]; then
	echo "Invalid data directory '$DATADIR'. Using the default data directory instead."
	DATADIR="${OCROOT}/data"
fi
DATASIZE="$(/bin/du -sh ${DATADIR} | /bin/cut -f1)"

PAGE_DATA_BACKUP=$(/bin/cat<<EOF
{
	"step_title": "Backup ownCloud server",
	"items": [{
		"desc": "<strong>WARNING:</strong> Uninstalling the ownCloud package will result in the removal of the ownCloud server, along with all associated user accounts, data, and configurations."
	}, {
		"type": "textfield",
		"desc": "Before uninstalling, if you want to keep a backup of your data, please specify the directory where you would like to export to. Ensure that the user 'sc-owncloud' has write permissions to that directory. To skip exporting, leave this field blank.",
		"subitems": [{
			"key": "wizard_export_path",
			"desc": "Export location",
			"emptyText": "${SYNOPKG_PKGDEST_VOL}/backup",
			"validator": {
				"allowBlank": true,
				"regex": {
					"expr": "/^\\\/volume[0-9]+\\\//",
					"errorText": "Path should begin with /volume?/ with ? the number of the volume"
				}
			}
		}]
	}, {
		"type": "singleselect",
		"subitems": [{
			"key": "wizard_delete_data",
			"hidden": true,
			"defaultValue": true
		}]
	}, {
		"type": "multiselect",
		"desc": "Please choose the items that you want to include in the backup.",
		"subitems": [{
			"key": "wizard_export_database",
			"desc": "Include database",
			"defaultValue": true
		}, {
			"key": "wizard_export_configs",
			"desc": "Include configuration files",
			"defaultValue": true
		}, {
			"key": "wizard_export_userdata",
			"desc": "Include user data ($DATASIZE)",
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
