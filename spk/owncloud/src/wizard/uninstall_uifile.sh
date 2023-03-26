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
if [ -z ${EFF_USER} ]; then
	EFF_USER="sc-owncloud"
fi

OCROOT="${WEB_DIR}/${SYNOPKG_PKGNAME}"

exec_occ() {
	PHP="/usr/local/bin/php74"
	OCC="${OCROOT}/occ"
	COMMAND="${PHP} ${OCC} $*"
	if [ ${SYNOPKG_DSM_VERSION_MAJOR} -lt 7 ]; then
		/bin/su "$EFF_USER" -s /bin/sh -c "$COMMAND"
	else
		$COMMAND
	fi
	return $?
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

CHECKBOX1_ID="wizard_export_database"
CHECKBOX2_ID="wizard_export_configs"
CHECKBOX3_ID="wizard_export_userdata"
ERROR_TEXT="Path should begin with /volume?/ with ? the number of the volume"
# Calculate size of data directory
DATADIR="$(exec_occ config:system:get datadirectory)"
# data directory fail-safe
if [ ! -d "$DATADIR" ]; then
	echo "Invalid data directory '$DATADIR'. Using the default data directory instead."
	DATADIR="${OCROOT}/data"
fi
DATASIZE="$(/bin/du -sh ${DATADIR} | /bin/cut -f1)"

getValidPath()
{
	VALID_PATH=$(/bin/cat<<EOF
{
	var exportPath = arguments[0];
	var step = arguments[2];
	var checkBox1 = step.getComponent("${CHECKBOX1_ID}");
	var checkBox2 = step.getComponent("${CHECKBOX2_ID}");
	var checkBox3 = step.getComponent("${CHECKBOX3_ID}");
	const pattern = /^\/volume[0-9]+\//;
	if (exportPath === "") {
		checkBox1.setDisabled(true);
		checkBox2.setDisabled(true);
		checkBox3.setDisabled(true);
		return true;
	} else if (pattern.test(exportPath)) {
		checkBox1.setDisabled(false);
		checkBox2.setDisabled(false);
		checkBox3.setDisabled(false);
		return true;
	} else {
		checkBox1.setDisabled(true);
		checkBox2.setDisabled(true);
		checkBox3.setDisabled(true);
		return "${ERROR_TEXT}";
	}
}
EOF
)
	echo "$VALID_PATH" | quote_json
}

PAGE_DATA_BACKUP=$(/bin/cat<<EOF
{
	"step_title": "Backup ownCloud server",
	"invalid_next_disabled_v2": true,
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
	}, {
		"type": "multiselect",
		"desc": "Please choose the items that you want to include in the backup.",
		"subitems": [{
			"key": "${CHECKBOX1_ID}",
			"desc": "Include database",
			"defaultValue": false,
			"disabled": true
		}, {
			"key": "${CHECKBOX2_ID}",
			"desc": "Include configuration files",
			"defaultValue": false,
			"disabled": true
		}, {
			"key": "${CHECKBOX3_ID}",
			"desc": "Include user data (${DATASIZE})",
			"defaultValue": false,
			"disabled": true
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
