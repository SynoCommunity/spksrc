#!/bin/bash

# for backwards compatability
if [ -z "${SYNOPKG_PKGDEST_VOL}" ]; then
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

RESTORE_BACKUP_FILE="wizard_nextcloud_restore"
BACKUP_FILE_PATH="wizard_backup_file"
RESTORE_BLANK_TEXT="{{{NEXTCLOUD_BACKUP_FILE_VALIDATION_BLANK_TEXT}}}"
RESTORE_ERROR_TEXT="{{{NEXTCLOUD_BACKUP_FILE_VALIDATION_ERROR_TEXT}}}"
SHARE_ERROR_TEXT="{{{NEXTCLOUD_DATA_DIRECTORY_VALIDATION_ERROR_TEXT}}}"
MYSQL_ROOT_PASSWORD="wizard_mysql_password_root"

checkBackupRestore()
{
	CHECK_BACKUP_RESTORE=$(/bin/cat<<EOF
{
	var backupFilePath = arguments[0];
	var step = arguments[2];
	var backupRestore = step.getComponent("${RESTORE_BACKUP_FILE}");
	const backupFileRegex = /^\/(volume|volumeUSB)[0-9]+\/([^\/]+\/)*nextcloud_backup_v\d+\.\d+\.\d+_\d{8}\.tar\.gz$/;
	if (backupRestore.checked) {
		if (backupFilePath === "") {
			return "${RESTORE_BLANK_TEXT}";
		} else if (backupFileRegex.test(backupFilePath)) {
			return true;
		} else {
			return "${RESTORE_ERROR_TEXT}";
		}
	}
	return true;
}
EOF
)
	echo "$CHECK_BACKUP_RESTORE" | quote_json
}

checkBackupFile()
{
	CHECK_BACKUP_FILE=$(/bin/cat<<EOF
{
	var backupRestore = arguments[0];
	var step = arguments[2];
	var backupFilePath = step.getComponent("${BACKUP_FILE_PATH}");
	if (backupRestore) {
		backupFilePath.setDisabled(false);
	} else {
		backupFilePath.setValue("");
		backupFilePath.setDisabled(true);
	}
	return true;
}
EOF
)
	echo "$CHECK_BACKUP_FILE" | quote_json
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
		var typeStep = findStepByTitle(wizardDialog, "{{{NEXTCLOUD_INSTALL_RESTORE_STEP_TITLE}}}");
		if (!typeStep) {
			return false;
		} else {
			return typeStep.getComponent("${RESTORE_BACKUP_FILE}").checked;
		}
	}
EOF
)

checkShareName()
{
	CHECK_SHARE_NAME=$(/bin/cat<<EOF
{
	var shareName = arguments[0];
	const shareRegex = /^[\w.][\w. -]{0,30}[\w.-]\\\$?$|^[\w]\\\$?$/;
	if (!shareRegex.test(shareName)) {
		return "${SHARE_ERROR_TEXT}";
	}
	return true;
}
EOF
)
	echo "$CHECK_SHARE_NAME" | quote_json
}

getActiveate()
{
	ACTIVAETE=$(/bin/cat<<EOF
{
	${jsFunction}
	var currentStep = arguments[0];
	var wizardDialog = currentStep.owner;
	var typeStep = findStepByTitle(wizardDialog, "{{{NEXTCLOUD_INSTALL_RESTORE_STEP_TITLE}}}");
	var adminStep = findStepByTitle(wizardDialog, "{{{NEXTCLOUD_ADMIN_CONFIGURATION_STEP_TITLE}}}");
	var confirmStep = findStepByTitle(wizardDialog, "{{{NEXTCLOUD_CONFIRM_RESTORE_STEP_TITLE}}}");
	var restoreChecked = isRestoreChecked(wizardDialog);
	if (currentStep.headline === "{{{NEXTCLOUD_ADMIN_CONFIGURATION_STEP_TITLE}}}") {
		if (restoreChecked) {
			wizardDialog.goBack(typeStep.itemId);
			wizardDialog.goNext(confirmStep.itemId);
		}
	} else if (currentStep.headline === "{{{NEXTCLOUD_CONFIRM_RESTORE_STEP_TITLE}}}") {
		if (!restoreChecked) {
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
	var adminStep = findStepByTitle(wizardDialog, "{{{NEXTCLOUD_ADMIN_CONFIGURATION_STEP_TITLE}}}");
	var domainStep = findStepByTitle(wizardDialog, "{{{NEXTCLOUD_TRUSTED_DOMAINS_STEP_TITLE}}}");
	var confirmStep = findStepByTitle(wizardDialog, "{{{NEXTCLOUD_CONFIRM_RESTORE_STEP_TITLE}}}");
	var restoreChecked = isRestoreChecked(wizardDialog);
	if (currentStep.headline === "{{{NEXTCLOUD_INSTALL_RESTORE_STEP_TITLE}}}") {
		domainStep.nextId = "applyStep";
		if (restoreChecked) {
			currentStep.nextId = confirmStep.itemId;
		} else {
			currentStep.nextId = adminStep.itemId;
		}
	}
	if (currentStep.headline === "{{{NEXTCLOUD_ADMIN_CONFIGURATION_STEP_TITLE}}}") {
		var setRootPassword = adminStep.getComponent("${MYSQL_ROOT_PASSWORD}");
		var confirmRootPassword = confirmStep.getComponent("${MYSQL_ROOT_PASSWORD}");
		if (!restoreChecked) {
			confirmRootPassword.setValue(setRootPassword.getValue());
		}
	}
}
EOF
)
	echo "$DEACTIVAETE" | quote_json
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

PAGE_ADMIN_CONFIG=$(/bin/cat<<EOF
{
	"step_title": "{{{NEXTCLOUD_INSTALL_RESTORE_STEP_TITLE}}}",
	"invalid_next_disabled_v2": true,
	"deactivate_v2": "$(getDeActiveate)",
	"items": [{
		"type": "singleselect",
		"desc": "{{{NEXTCLOUD_INSTALL_RESTORE_DESCRIPTION}}}",
		"subitems": [{
			"key": "wizard_nextcloud_install",
			"desc": "{{{NEXTCLOUD_INSTALL_LABEL}}}",
			"defaultValue": true
		}, {
			"key": "${RESTORE_BACKUP_FILE}",
			"desc": "{{{NEXTCLOUD_RESTORE_LABEL}}}",
			"defaultValue": false,
			"validator": {
				"fn": "$(checkBackupFile)"
			}
		}]
	}, {
		"type": "textfield",
		"desc": "{{{NEXTCLOUD_BACKUP_FILE_LOCATION_DESCRIPTION}}}",
		"subitems": [{
			"key": "${BACKUP_FILE_PATH}",
			"desc": "{{{NEXTCLOUD_BACKUP_FILE_LOCATION_LABEL}}}",
			"disabled": true,
			"emptyText": "${SYNOPKG_PKGDEST_VOL}/backup/${SYNOPKG_PKGNAME}_backup_v10.15.0_20241015.tar.gz",
			"validator": {
				"fn": "$(checkBackupRestore)"
			}
		}]
	}, {
		"type": "textfield",
		"desc": "{{{NEXTCLOUD_DATA_DIRECTORY_DESCRIPTION}}}",
		"subitems": [{
			"key": "wizard_data_share",
			"desc": "{{{NEXTCLOUD_DATA_DIRECTORY_LABEL}}}",
			"defaultValue": "${SHAREDIR}",
			"validator": {
				"allowBlank": false,
				"fn": "$(checkShareName)"
			}
		}]
	}]
}, {
	"step_title": "{{{NEXTCLOUD_ADMIN_CONFIGURATION_STEP_TITLE}}}",
	"invalid_next_disabled_v2": true,
	"activate_v2": "$(getActiveate)",
	"deactivate_v2": "$(getDeActiveate)",
	"items": [{
		"type": "textfield",
		"desc": "{{{NEXTCLOUD_ADMIN_USER_NAME_DESCRIPTION}}}",
		"subitems": [{
			"key": "wizard_nextcloud_admin_username",
			"desc": "{{{NEXTCLOUD_ADMIN_USER_NAME_LABEL}}}",
			"defaultValue": "admin",
			"validator": {
				"allowBlank": false
			}
		}]
	}, {
		"type": "password",
		"desc": "{{{NEXTCLOUD_ADMIN_PASSWORD_DESCRIPTION}}}",
		"subitems": [{
			"key": "wizard_nextcloud_admin_password",
			"desc": "{{{NEXTCLOUD_ADMIN_PASSWORD_LABEL}}}",
			"defaultValue": "admin",
			"validator": {
				"allowBlank": false
			}
		}]
	}, {
		"type": "password",
		"desc": "{{{MYSQL_NEXTCLOUD_PASSWORD_DESCRIPTION}}}",
		"subitems": [{
			"key": "wizard_mysql_password_nextcloud",
			"desc": "{{{MYSQL_NEXTCLOUD_PASSWORD_LABEL}}}",
			"invalidText": "{{{MYSQL_NEXTCLOUD_PASSWORD_VALIDATION_ERROR_TEXT}}}",
			"validator": {
				"fn": "$(getPasswordValidator)"
			}
		}]
	}, {
		"type": "password",
		"desc": "{{{MYSQL_ROOT_PASSWORD_DESCRIPTION}}}",
		"subitems": [{
			"key": "${MYSQL_ROOT_PASSWORD}",
			"desc": "{{{MYSQL_ROOT_PASSWORD_LABEL}}}",
			"validator": {
				"allowBlank": false
			}
		}]
	}]
}, {
	"step_title": "{{{NEXTCLOUD_TRUSTED_DOMAINS_STEP_TITLE}}}",
	"items": [{
		"type": "textfield",
		"desc": "{{{NEXTCLOUD_TRUSTED_DOMAINS_DESCRIPTION}}}",
		"subitems": [{
			"key": "wizard_nextcloud_trusted_domain_1",
			"desc": "{{{NEXTCLOUD_TRUSTED_DOMAIN_1_LABEL}}}",
			"emptyText": "localhost"
		}, {
			"key": "wizard_nextcloud_trusted_domain_2",
			"desc": "{{{NEXTCLOUD_TRUSTED_DOMAIN_2_LABEL}}}",
			"emptyText": "server1.example.com"
		}, {
			"key": "wizard_nextcloud_trusted_domain_3",
			"desc": "{{{NEXTCLOUD_TRUSTED_DOMAIN_3_LABEL}}}",
			"emptyText": "192.168.1.50"
		}]
	}]
}, {
	"step_title": "{{{NEXTCLOUD_CONFIRM_RESTORE_STEP_TITLE}}}",
	"invalid_next_disabled_v2": true,
	"activate_v2": "$(getActiveate)",
	"items": [{
		"desc": "{{{NEXTCLOUD_CONFIRM_RESTORE_DESCRIPTION}}}"
	}, {
		"type": "password",
		"desc": "{{{MYSQL_ROOT_PASSWORD_DESCRIPTION}}}",
		"subitems": [{
			"key": "${MYSQL_ROOT_PASSWORD}",
			"desc": "{{{MYSQL_ROOT_PASSWORD_LABEL}}}",
			"validator": {
				"allowBlank": false
			}
		}]
	}]
}
EOF
)

main () {
	local install_page=""
	install_page=$(page_append "$install_page" "$PAGE_ADMIN_CONFIG")
	echo "[$install_page]" > "${SYNOPKG_TEMP_LOGFILE}"
}

main "$@"
