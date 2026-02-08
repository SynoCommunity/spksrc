#!/bin/bash

WEB_DIR="/var/services/web_packages"

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

PHP_FILE="${WEB_DIR}/cops/config_local.php"
CONFIGURED_SHARE_NAME=$(sed -n "s/^\s*\$config\['calibre_directory'\] = '\([^']*\)';/\1/p" "$PHP_FILE" | xargs basename)
PACKAGE_SHARE_NAME=$(grep "^SHARE_NAME=" "/var/packages/cops/etc/installer-variables" | cut -d '=' -f 2)
SHARE_ERROR_TEXT="{{{UPGRADE_CALIBRE_DIRECTORY_VALIDATION_ERROR_TEXT}}}"

# Check for data share
check_data_share ()
{
    if [ -n "${PACKAGE_SHARE_NAME}" ]; then
        return 0  # true
    else
        return 1  # false
    fi
}

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

PAGE_LIBRARY_CONFIG=$(/bin/cat<<EOF
{
    "step_title": "{{{COPS_CONFIGURATION_UPGRADE_STEP_TITLE}}}",
    "invalid_next_disabled_v2": true,
    "items": [{
        "type": "textfield",
        "desc": "{{{UPGRADE_CALIBRE_DIRECTORY_DESCRIPTION}}}",
        "subitems": [{
            "key": "wizard_calibre_share",
            "desc": "{{{UPGRADE_CALIBRE_DIRECTORY_LABEL}}}",
            "defaultValue": "${CONFIGURED_SHARE_NAME}",
            "validator": {
                "allowBlank": false,
                "fn": "$(checkShareName)"
            }
        }]
    },{
        "desc": "{{{UPGRADE_NOTE_CALIBRE_DIRECTORY_DESCRIPTION}}}"
    }]
}
EOF
)

main () {
    local upgrade_page=""
    if ! check_data_share; then
        upgrade_page=$(page_append "$upgrade_page" "$PAGE_LIBRARY_CONFIG")
    fi
    echo "[$upgrade_page]" > "${SYNOPKG_TEMP_LOGFILE}"
}

main "$@"
