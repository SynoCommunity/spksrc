#!/bin/bash

# for backwards compatability
if [ -z "${SYNOPKG_PKGDEST_VOL}" ]; then
	SYNOPKG_PKGDEST_VOL="/volume1"
fi
INTERNAL_IP=$(ip -4 route get 8.8.8.8 | awk '/8.8.8.8/ && /src/ {print $NF}')

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

RESTORE_BACKUP_FILE="wizard_fengoffice_restore"
BACKUP_FILE_PATH="wizard_backup_file"
RESTORE_ERROR_TEXT="An empty file path is not allowed when restore is enabled."
INSTALL_NEW_INSTANCE="wizard_fengoffice_install"
DOMAIN_NAME="wizard_domain_name"
INSTALL_ERROR_TEXT="An empty domain name is not allowed when install is enabled."

checkNewInstall()
{
	CHECK_NEW_INSTALL=$(/bin/cat<<EOF
{
	var domainName = arguments[0];
	var step = arguments[2];
	var installNew = step.getComponent("${INSTALL_NEW_INSTANCE}");
	if (installNew.checked) {
		if (domainName === "") {
			return "${INSTALL_ERROR_TEXT}";
		}
	}
	return true;
}
EOF
)
	echo "$CHECK_NEW_INSTALL" | quote_json
}

checkDomainName()
{
	CHECK_DOMAIN_NAME=$(/bin/cat<<EOF
{
	var installNew = arguments[0];
	var step = arguments[2];
	var domainName = step.getComponent("${DOMAIN_NAME}");
	if (installNew) {
		if (domainName.getValue() === "") {
			domainName.setValue("${INTERNAL_IP}");
		}
		domainName.setDisabled(false);
	} else {
		domainName.setValue("");
		domainName.setDisabled(true);
	}
	return true;
}
EOF
)
	echo "$CHECK_DOMAIN_NAME" | quote_json
}

checkBackupRestore()
{
	CHECK_BACKUP_RESTORE=$(/bin/cat<<EOF
{
	var backupFilePath = arguments[0];
	var step = arguments[2];
	var backupRestore = step.getComponent("${RESTORE_BACKUP_FILE}");
	if (backupRestore.checked) {
		if (backupFilePath === "") {
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

PAGE_INSTALL_CONFIG=$(/bin/cat<<EOF
{
	"step_title": "Feng Office installation type",
	"invalid_next_disabled_v2": true,
	"items": [{
		"type": "singleselect",
		"desc": "For the installation, you have the option to either create a new instance or restore from a backup archive.",
		"subitems": [{
			"key": "${INSTALL_NEW_INSTANCE}",
			"desc": "Install new deployment",
			"defaultValue": true,
			"validator": {
				"fn": "$(checkDomainName)"
			}
		}, {
			"key": "${RESTORE_BACKUP_FILE}",
			"desc": "Restore from archive",
			"defaultValue": false,
			"validator": {
				"fn": "$(checkBackupFile)"
			}
		}]
	}, {
        "type": "textfield",
        "desc": "For a new installation, please provide the domain name of your DiskStation (e.g., you.synology.me).",
        "subitems": [{
            "key": "${DOMAIN_NAME}",
            "desc": "Domain name",
            "emptyText": "${INTERNAL_IP}",
            "validator": {
                "fn": "$(checkNewInstall)"
            }
        }]
	}, {
		"type": "textfield",
		"desc": "For restoring, please provide the full path to the archive you want to restore.",
		"subitems": [{
			"key": "${BACKUP_FILE_PATH}",
			"desc": "Backup file location",
			"disabled": true,
			"emptyText": "${SYNOPKG_PKGDEST_VOL}/${SYNOPKG_PKGNAME}/backup",
			"validator": {
				"fn": "$(checkBackupRestore)"
			}
		}]
	}]
}, {
    "step_title": "Feng Office database configuration",
    "invalid_next_disabled_v2": true,
    "items": [{
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
        "type": "password",
        "desc": "A '${SYNOPKG_PKGNAME}' MySQL user and database will be created. Please provide a password for the '${SYNOPKG_PKGNAME}' user.",
        "subitems": [{
            "key": "wizard_mysql_password_fengoffice",
            "desc": "MySQL '${SYNOPKG_PKGNAME}' password",
            "invalidText": "Password is invalid. Ensure it includes at least one uppercase letter, one lowercase letter, one digit, one special character, and has a minimum length of 10 characters.",
            "validator": {
                "fn": "$(getPasswordValidator)"
            }
        }]
    }, {
        "type": "multiselect",
        "subitems": [{
            "key": "wizard_create_db",
            "desc": "Creates initial DB",
            "defaultValue": true,
            "hidden": true
        }, {
            "key": "mysql_grant_user",
            "desc": "Configures user rights",
            "defaultValue": true,
            "hidden": true
        }]
    }]
}
EOF
)

PAGE_PHP_PROFILES=$(/bin/cat<<EOF
{
    "step_title": "Multiple PHP profiles",
    "items": [{
        "desc": "Attention: Multiple PHP profiles detected; the package webpage will not display until a DSM restart is performed to load new configurations."
    }]
}
EOF
)

main () {
    local install_page=""
    install_page=$(page_append "$install_page" "$PAGE_INSTALL_CONFIG")
    if check_php_profiles; then
        install_page=$(page_append "$install_page" "$PAGE_PHP_PROFILES")
    fi
    echo "[$install_page]" > "${SYNOPKG_TEMP_LOGFILE}"
}

main "$@"
