#!/bin/bash

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

CFG_FILE="/var/packages/${SYNOPKG_PKGNAME}/var/config.ini"
# Extract share path and name from application config
CONFIGURED_SHARE_PATH=$(awk -F' = ' '/^download_dir/{split($2, path, "/"); print "/" path[2] "/" path[3]}' "${CFG_FILE}")
CONFIGURED_SHARE_NAME=$(echo "${CONFIGURED_SHARE_PATH}" | awk -F'/' '{print $NF}')

VAR_FILE="/var/packages/${SYNOPKG_PKGNAME}/etc/installer-variables"
# Extract share path from installer variables or configured shares
PACKAGE_SHARE_PATH=$(awk -F'=' '/^SHARE_PATH=/{print $2}' "${VAR_FILE}" 2>/dev/null || echo "")
if [ -z "$PACKAGE_SHARE_PATH" ] && [ -d "/var/packages/${SYNOPKG_PKGNAME}/shares" ]; then
    PACKAGE_SHARE_PATH=$(realpath "/var/packages/${SYNOPKG_PKGNAME}/shares/${CONFIGURED_SHARE_NAME}" 2>/dev/null || echo "")
fi
# Extract share name from installer variables or configured shares
PACKAGE_SHARE_NAME=$(awk -F'=' '/^SHARE_NAME=/{print $2}' "${VAR_FILE}" 2>/dev/null || echo "")
if [ -z "$PACKAGE_SHARE_NAME" ] && [ -d "/var/packages/${SYNOPKG_PKGNAME}/shares/${CONFIGURED_SHARE_NAME}" ]; then
    PACKAGE_SHARE_NAME=${CONFIGURED_SHARE_NAME}
fi

# Check for data share
check_data_share ()
{
    if [ -n "${PACKAGE_SHARE_NAME}" ]; then
        return 0  # true
    elif [ -n "$CONFIGURED_SHARE_PATH" ] && [ -n "$PACKAGE_SHARE_PATH" ] && [ "$CONFIGURED_SHARE_PATH" = "$PACKAGE_SHARE_PATH" ]; then
        # If consistent data share path, assume share name is correct
        return 0  # true
    else
        return 1  # false
    fi
}

PAGE_SHARE_UPGRADE=$(/bin/cat<<EOF
{
    "step_title": "Shared Folder Upgrade",
    "invalid_next_disabled_v2": true,
    "items": [{
        "type": "textfield",
        "desc": "The download folder for this package must now be located within a data share. As per the existing configuration, the identified data share for your downloads is:",
        "subitems": [{
            "key": "wizard_shared_folder_name",
            "desc": "Shared Folder",
            "defaultValue": "${CONFIGURED_SHARE_NAME}",
            "validator": {
                "allowBlank": false,
                "regex": {
                    "expr": "/^[\\\w _-]+$/",
                    "errorText": "Subdirectories are not supported."
                }
            }
        }]
    },{
        "desc": "IMPORTANT: If your download folder is not currently located in the specified share, a new share will be created. After the upgrade, you may need to manually update your configuration to reflect this new location."
    }]
}
EOF
)

PAGE_DSM_PERMISSIONS=$(/bin/cat<<EOF
{
    "step_title": "DSM Permissions",
    "items": [{
        "desc": "Please read <a target=\"_blank\" href=\"https://github.com/SynoCommunity/spksrc/wiki/Permission-Management\">Permission Management</a> for details."
    },{
        "type": "textfield",
        "subitems": [{
            "key": "wizard_shared_folder_name",
            "defaultValue": "${CONFIGURED_SHARE_NAME}",
            "hidden": true
        }]
    }]
}
EOF
)

main () {
    local upgrade_page=""
    if ! check_data_share; then
        upgrade_page=$(page_append "$upgrade_page" "$PAGE_SHARE_UPGRADE")
    else
        upgrade_page=$(page_append "$upgrade_page" "$PAGE_DSM_PERMISSIONS")
    fi
    echo "[$upgrade_page]" > "${SYNOPKG_TEMP_LOGFILE}"
}

main "$@"
