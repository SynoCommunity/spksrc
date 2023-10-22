#!/bin/bash

# for backwards compatability
if [ -z ${SYNOPKG_PKGDEST_VOL} ]; then
	SYNOPKG_PKGDEST_VOL="/volume1"
fi
SHAREDIR="${SYNOPKG_PKGNAME}"
DIR_VALID="/^[\\w _-]+$/"

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

BACKUP_FILE_PATH="wizard_backup_file"

getBackupFile()
{
	BACKUP_FILE=$(/bin/cat<<EOF
{
	var backupFile = arguments[0];
	var step = arguments[2];
	var filePath = step.getComponent("${BACKUP_FILE_PATH}");
	if (backupFile) {
		filePath.setDisabled(false);
		return true;
	} else {
		filePath.setDisabled(true);
		return true;
	}
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
        var restoreStep = findStepByTitle(wizardDialog, "{{{OWNCLOUD_INSTALL_RESTORE_STEP_TITLE}}}");
        if (!restoreStep) {
            return false;
        } else {
            return restoreStep.items.items[1].checked;
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
    var restoreStep = findStepByTitle(wizardDialog, "{{{OWNCLOUD_INSTALL_RESTORE_STEP_TITLE}}}");
    var adminStep = findStepByTitle(wizardDialog, "{{{OWNCLOUD_ADMIN_CONFIGURATION_STEP_TITLE}}}");
    var domainStep = findStepByTitle(wizardDialog, "{{{OWNCLOUD_TRUSTED_DOMAINS_STEP_TITLE}}}");
    var checked = isRestoreChecked(wizardDialog);
    adminStep.items.items[0].setVisible(!checked);
    adminStep.items.items[1].setVisible(!checked);
    domainStep.items.items[0].setVisible(!checked);
}
EOF
)
    echo "$ACTIVAETE" | quote_json
}

PAGE_ADMIN_CONFIG=$(/bin/cat<<EOF
{
	"step_title": "{{{OWNCLOUD_INSTALL_RESTORE_STEP_TITLE}}}",
	"invalid_next_disabled_v2": true,
	"items": [{
		"type": "singleselect",
		"desc": "{{{OWNCLOUD_INSTALL_RESTORE_DESCRIPTION}}}",
		"subitems": [{
			"key": "wizard_owncloud_install",
			"desc": "{{{OWNCLOUD_INSTALL_LABEL}}}",
			"defaultValue": true
		}, {
			"key": "wizard_owncloud_restore",
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
				"allowBlank": true
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
					"expr": "$(echo ${DIR_VALID} | quote_json)",
					"errorText": "{{{OWNCLOUD_DATA_DIRECTORY_VALIDATION_ERROR_TEXT}}}"
				}
			}
		}]
	}]
}, {
	"step_title": "{{{OWNCLOUD_ADMIN_CONFIGURATION_STEP_TITLE}}}",
	"invalid_next_disabled_v2": true,
    "activeate": "$(getActiveate)",
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
    "activeate": "$(getActiveate)",
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
}
EOF
)

main () {
	local install_page=""
	install_page=$(page_append "$install_page" "$PAGE_ADMIN_CONFIG")
	echo "[$install_page]" > "${SYNOPKG_TEMP_LOGFILE}"
}

main "$@"
