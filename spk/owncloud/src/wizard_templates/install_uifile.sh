#!/bin/bash

# for backwards compatability
if [ -z ${SYNOPKG_PKGDEST_VOL} ]; then
	SYNOPKG_PKGDEST_VOL="/volume1"
fi
SHAREDIR="${SYNOPKG_PKGNAME}"

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

RESTORE_BACKUP_FILE="wizard_owncloud_restore"
BACKUP_FILE_PATH="wizard_backup_file"
ERROR_TEXT="{{{OWNCLOUD_BACKUP_FILE_VALIDATION_ERROR_TEXT}}}"

checkBackupFile()
{
	CHECK_BACKUP_FILE=$(/bin/cat<<EOF
{
	var backupFileCheck = arguments[0];
	var step = arguments[2];
	var fileRestore = step.getComponent("${RESTORE_BACKUP_FILE}");
	if (fileRestore.checked) {
		if (backupFileCheck === "") {
			return "${ERROR_TEXT}";
		}
	}
	return true;
}
EOF
)
	echo "$CHECK_BACKUP_FILE" | quote_json
}

getBackupFile()
{
	BACKUP_FILE=$(/bin/cat<<EOF
{
	var backupFile = arguments[0];
	var step = arguments[2];
	var filePath = step.getComponent("${BACKUP_FILE_PATH}");
	if (backupFile) {
		filePath.setDisabled(false);
	} else {
		filePath.setValue("");
		filePath.setDisabled(true);
	}
	return true;
}
EOF
)
	echo "$BACKUP_FILE" | quote_json
}

jsFunction=$(/bin/cat<<EOF
	function findStepByTitle(wizardDialog, title) {
		for (var i = wizardDialog.customuiIds.length - 1 ; i >= 0 ; i--) {
			var step = wizardDialog.getStep(wizardDialog.customuiIds[i]);
			if (title === step.headline) {
				return step;
			}
		}
		return null;
	}
	function isRestoreChecked(wizardDialog) {
		var typeStep = findStepByTitle(wizardDialog, "{{{OWNCLOUD_INSTALL_RESTORE_STEP_TITLE}}}");
		if (!typeStep) {
			return false;
		} else {
			return typeStep.getComponent("${RESTORE_BACKUP_FILE}").checked;
		}
	}
EOF
)

getActiveate()
{
	ACTIVAETE=$(/bin/cat<<EOF
{
	${jsFunction}
	var currentStep = arguments[0];
	var wizardDialog = currentStep.owner;
	var typeStep = findStepByTitle(wizardDialog, "{{{OWNCLOUD_INSTALL_RESTORE_STEP_TITLE}}}");
	var adminStep = findStepByTitle(wizardDialog, "{{{OWNCLOUD_ADMIN_CONFIGURATION_STEP_TITLE}}}");
	var confirmStep = findStepByTitle(wizardDialog, "{{{OWNCLOUD_CONFIRM_RESTORE_STEP_TITLE}}}");
	var checked = isRestoreChecked(wizardDialog);
	if (currentStep.headline === "{{{OWNCLOUD_ADMIN_CONFIGURATION_STEP_TITLE}}}") {
		if (checked) {
			wizardDialog.goBack(typeStep.itemId);
			wizardDialog.goNext(confirmStep.itemId);
		}
	} else if (currentStep.headline === "{{{OWNCLOUD_CONFIRM_RESTORE_STEP_TITLE}}}") {
		if (!checked) {
			wizardDialog.goBack(typeStep.itemId);
			wizardDialog.goNext(adminStep.itemId);
		}
	}
}
EOF
)
	echo "$ACTIVAETE" | quote_json
}

getDeActiveate()
{
	DEACTIVAETE=$(/bin/cat<<EOF
{
	${jsFunction}
	var currentStep = arguments[0];
	var wizardDialog = currentStep.owner;
	var adminStep = findStepByTitle(wizardDialog, "{{{OWNCLOUD_ADMIN_CONFIGURATION_STEP_TITLE}}}");
	var domainStep = findStepByTitle(wizardDialog, "{{{OWNCLOUD_TRUSTED_DOMAINS_STEP_TITLE}}}");
	var confirmStep = findStepByTitle(wizardDialog, "{{{OWNCLOUD_CONFIRM_RESTORE_STEP_TITLE}}}");
	var phpStep = findStepByTitle(wizardDialog, "{{{PHP_PROFILES_TITLE}}}");
	var checked = isRestoreChecked(wizardDialog);
	if (currentStep.headline === "{{{OWNCLOUD_INSTALL_RESTORE_STEP_TITLE}}}") {
		if (!phpStep) {
			domainStep.nextId = "applyStep";
		} else {
			domainStep.nextId = phpStep.itemId;
		}
		if (checked) {
			currentStep.nextId = confirmStep.itemId;
		} else {
			currentStep.nextId = adminStep.itemId;
		}
	}
}
EOF
)
	echo "$DEACTIVAETE" | quote_json
}

# Check for multiple PHP profiles
check_php_profiles ()
{
	SC_PKG_PREFIX="com-synocommunity-packages-"
	SC_PKG_NAME="${SC_PKG_PREFIX}${SYNOPKG_PKGNAME}"
	PHP_CFG_PATH="/usr/syno/etc/packages/WebStation/PHPSettings.json"
	if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ] && \
		jq -e 'to_entries | map(select((.key | startswith("'"${SC_PKG_PREFIX}"'")) and .key != "'"${SC_PKG_NAME}"'")) | length > 0' "${PHP_CFG_PATH}" >/dev/null; then
		return 0  # true
	else
		return 1  # false
	fi
}

PAGE_ADMIN_CONFIG=$(/bin/cat<<EOF
{
	"step_title": "{{{OWNCLOUD_INSTALL_RESTORE_STEP_TITLE}}}",
	"invalid_next_disabled_v2": true,
	"deactivate_v2": "$(getDeActiveate)",
	"items": [{
		"type": "singleselect",
		"desc": "{{{OWNCLOUD_INSTALL_RESTORE_DESCRIPTION}}}",
		"subitems": [{
			"key": "wizard_owncloud_install",
			"desc": "{{{OWNCLOUD_INSTALL_LABEL}}}",
			"defaultValue": true
		}, {
			"key": "${RESTORE_BACKUP_FILE}",
			"desc": "{{{OWNCLOUD_RESTORE_LABEL}}}",
			"defaultValue": false,
			"validator": {
				"fn": "$(getBackupFile)"
			}
		}]
	}, {
		"type": "textfield",
		"desc": "{{{OWNCLOUD_BACKUP_FILE_LOCATION_DESCRIPTION}}}",
		"subitems": [{
			"key": "${BACKUP_FILE_PATH}",
			"desc": "{{{OWNCLOUD_BACKUP_FILE_LOCATION_LABEL}}}",
			"disabled": true,
			"emptyText": "${SYNOPKG_PKGDEST_VOL}/${SYNOPKG_PKGNAME}/backup",
			"validator": {
				"fn": "$(checkBackupFile)"
			}
		}]
	}, {
		"type": "textfield",
		"desc": "{{{OWNCLOUD_DATA_DIRECTORY_DESCRIPTION}}}",
		"subitems": [{
			"key": "wizard_data_share",
			"desc": "{{{OWNCLOUD_DATA_DIRECTORY_LABEL}}}",
			"defaultValue": "${SHAREDIR}",
			"validator": {
				"allowBlank": false,
				"regex": {
					"expr": "/^[\\\w.][\\\w. -]{0,30}[\\\w.-][\\\\$]?$|^[\\\w][\\\\$]?$/",
					"errorText": "{{{OWNCLOUD_DATA_DIRECTORY_VALIDATION_ERROR_TEXT}}}"
				}
			}
		}]
	}]
}, {
	"step_title": "{{{OWNCLOUD_ADMIN_CONFIGURATION_STEP_TITLE}}}",
	"invalid_next_disabled_v2": true,
	"activate_v2": "$(getActiveate)",
	"items": [{
		"type": "textfield",
		"desc": "{{{OWNCLOUD_ADMIN_USER_NAME_DESCRIPTION}}}",
		"subitems": [{
			"key": "wizard_owncloud_admin_username",
			"desc": "{{{OWNCLOUD_ADMIN_USER_NAME_LABEL}}}",
			"defaultValue": "admin",
			"validator": {
				"allowBlank": false
			}
		}]
	}, {
		"type": "password",
		"desc": "{{{OWNCLOUD_ADMIN_PASSWORD_DESCRIPTION}}}",
		"subitems": [{
			"key": "wizard_owncloud_admin_password",
			"desc": "{{{OWNCLOUD_ADMIN_PASSWORD_LABEL}}}",
			"defaultValue": "admin",
			"validator": {
				"allowBlank": false
			}
		}]
	}]
}, {
	"step_title": "{{{OWNCLOUD_TRUSTED_DOMAINS_STEP_TITLE}}}",
	"items": [{
		"type": "textfield",
		"desc": "{{{OWNCLOUD_TRUSTED_DOMAINS_DESCRIPTION}}}",
		"subitems": [{
			"key": "wizard_owncloud_trusted_domain_1",
			"desc": "{{{OWNCLOUD_TRUSTED_DOMAIN_1_LABEL}}}",
			"emptyText": "localhost"
		}, {
			"key": "wizard_owncloud_trusted_domain_2",
			"desc": "{{{OWNCLOUD_TRUSTED_DOMAIN_2_LABEL}}}",
			"emptyText": "server1.example.com"
		}, {
			"key": "wizard_owncloud_trusted_domain_3",
			"desc": "{{{OWNCLOUD_TRUSTED_DOMAIN_3_LABEL}}}",
			"emptyText": "192.168.1.50"
		}]
	}]
}, {
	"step_title": "{{{OWNCLOUD_CONFIRM_RESTORE_STEP_TITLE}}}",
	"activate_v2": "$(getActiveate)",
	"items": [{
		"desc": "{{{OWNCLOUD_CONFIRM_RESTORE_DESCRIPTION}}}"
	}]
}
EOF
)

PAGE_PHP_PROFILES=$(/bin/cat<<EOF
{
	"step_title": "{{{PHP_PROFILES_TITLE}}}",
	"items": [{
		"desc": "{{{PHP_PROFILES_DESCRIPTION}}}"
	}]
}
EOF
)

main () {
	local install_page=""
	install_page=$(page_append "$install_page" "$PAGE_ADMIN_CONFIG")
	if check_php_profiles; then
		install_page=$(page_append "$install_page" "$PAGE_PHP_PROFILES")
	fi
	echo "[$install_page]" > "${SYNOPKG_TEMP_LOGFILE}"
}

main "$@"
