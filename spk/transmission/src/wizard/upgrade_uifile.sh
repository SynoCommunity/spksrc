#!/bin/bash

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

# get existing data share
CONFIG_FILE="/var/packages/transmission/etc/installer-variables"
PACKAGE_SHARE_NAME=$(grep "^SHARE_NAME=" "$CONFIG_FILE" | cut -d '=' -f 2)
PACKAGE_SHARE_PATH=$(grep "^SHARE_PATH=" "$CONFIG_FILE" | cut -d '=' -f 2)

# if SHARE_NAME is empty and SHARE_PATH is not empty and doesn't start with '/volume'
if [ -z "$PACKAGE_SHARE_NAME" ] && [ -n "$PACKAGE_SHARE_PATH" ] && [[ ! "$PACKAGE_SHARE_PATH" =~ ^/volume ]]; then
    PACKAGE_SHARE_NAME="$PACKAGE_SHARE_PATH"
    PACKAGE_SHARE_PATH="$SYNOPKG_PKGDEST_VOL/$PACKAGE_SHARE_PATH"
	# update values in the config file
	echo "SHARE_NAME=$PACKAGE_SHARE_NAME" >> "$CONFIG_FILE"
	sed -i "s|^SHARE_PATH=.*|SHARE_PATH=$PACKAGE_SHARE_PATH|" "$CONFIG_FILE"
fi

PAGE_BASE_CONFIG=$(/bin/cat<<EOF
{
	"step_title": "DSM Permissions",
	"items": [{
		"desc": "Please read <a target=\"_blank\" href=\"https://github.com/SynoCommunity/spksrc/wiki/Permission-Management\">Permission Management</a> for details."
	},{
		"type": "textfield",
		"subitems": [{
			"defaultValue": "${PACKAGE_SHARE_NAME}",
			"hidden": true,
			"key": "wizard_shared_folder_name"
		}]
	}]
}
EOF
)

main () {
	local upgrade_page=""
	upgrade_page=$(page_append "$upgrade_page" "$PAGE_BASE_CONFIG")
	echo "[$upgrade_page]" > "${SYNOPKG_TEMP_LOGFILE}"
}

main "$@"
