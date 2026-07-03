#!/bin/sh

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

DEFAULT_SHARED_FOLDER_NAME=PS3

CFG_FILE="/var/packages/${SYNOPKG_PKGNAME}/var/ps3netsrv.conf"
# Extract share path and name from application config
CONFIGURED_SHARE_PATH=$(grep "^PS3_DIR" "${CFG_FILE}" | cut -d= -f2 | tr -d '"')
CONFIGURED_SHARE_NAME=$(basename "${CONFIGURED_SHARE_PATH}")

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

# Check for data share and initialize default for wizard_shared_folder_name
check_data_share ()
{
    if [ -d "${CONFIGURED_SHARE_PATH}" -a -n "${CONFIGURED_SHARE_NAME}" ]; then
        DEFAULT_SHARED_FOLDER_NAME=${CONFIGURED_SHARE_NAME}
        return 0  # true
    elif [ -d "${PACKAGE_SHARE_PATH}" -a -n "${PACKAGE_SHARE_NAME}" ]; then
        DEFAULT_SHARED_FOLDER_NAME=${PACKAGE_SHARE_NAME}
        return 0  # true
    else
        if [ -n "${CONFIGURED_SHARE_NAME}" ]; then
            DEFAULT_SHARED_FOLDER_NAME=${CONFIGURED_SHARE_NAME}
        elif [ -n "${PACKAGE_SHARE_NAME}" ]; then
            DEFAULT_SHARED_FOLDER_NAME=${PACKAGE_SHARE_NAME}
        elif [ -n "${PACKAGE_SHARE_PATH}" ]; then
            DEFAULT_SHARED_FOLDER_NAME=${PACKAGE_SHARE_PATH}
        fi
        return 1  # false
    fi
}

PAGE_SHARE_UPGRADE=$(/bin/cat<<EOF
{
    "step_title": "Shared Folder Upgrade",
    "invalid_next_disabled_v2": true,
    "items": [{
        "type": "textfield",
        "desc": "The shared folder for this package must now be located within a data share. As per the existing configuration, the identified data share for your downloads is:",
        "subitems": [{
            "key": "wizard_shared_folder_name",
            "desc": "Shared Folder",
            "defaultValue": "${DEFAULT_SHARED_FOLDER_NAME}",
            "validator": {
                "allowBlank": false,
                "regex": {
                    "expr": "/^[\\\w _-]+$/",
                    "errorText": "Subdirectories are not supported."
                }
            }
        }]
    },{
        "desc": "IMPORTANT: If your shared folder is not currently located in the specified share, a new share will be created. After the upgrade, you may need to manually update your configuration to reflect this new location."
    }]
}
EOF
)


main () {
    local upgrade_page=""
    if ! check_data_share; then
        upgrade_page=$(page_append "$upgrade_page" "$PAGE_SHARE_UPGRADE")
    fi
    echo "[$upgrade_page]" > "${SYNOPKG_TEMP_LOGFILE}"
}

main "$@"
