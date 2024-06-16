#!/bin/bash

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

# Check for multiple PHP profiles
check_php_profiles ()
{
    PACKAGE="cops"
    SC_PKG_PREFIX="com-synocommunity-packages-"
    PACKAGE_NAME="${SC_PKG_PREFIX}${PACKAGE}"
    PHP_CFG_PATH="/usr/syno/etc/packages/WebStation/PHPSettings.json"
    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ] && \
        jq -e 'to_entries | map(select((.key | startswith("'"${SC_PKG_PREFIX}"'")) and .key != "'"${PACKAGE_NAME}"'")) | length > 0' "${PHP_CFG_PATH}" >/dev/null; then
        return 0  # true
    else
        return 1  # false
    fi
}

PAGE_ADMIN_CONFIG=$(/bin/cat<<EOF
{
    "step_title": "{{{COPS_CONFIGURATION_FIRST_STEP_TITLE}}}",
    "invalid_next_disabled_v2": true,
    "items": [{
        "type": "textfield",
        "desc": "{{{EXISTING_CALIBRE_DIRECTORY_DESCRIPTION}}}",
        "subitems": [{
            "key": "wizard_calibre_share",
            "desc": "{{{EXISTING_CALIBRE_DIRECTORY_LABEL}}}",
            "defaultValue": "calibre",
            "validator": {
                "allowBlank": false,
                "regex": {
                    "expr": "/^[\\\w.][\\\w. -]{0,30}[\\\w.-][\\\\$]?$|^[\\\w][\\\\$]?$/",
                    "errorText": "{{{EXISTING_CALIBRE_DIRECTORY_VALIDATION_ERROR_TEXT}}}"
                }
            }
        }]
    }, {
        "type": "textfield",
        "desc": "{{{COPS_CATALOG_TITLE_DESCRIPTION}}}",
        "subitems": [{
            "key": "wizard_cops_title",
            "defaultValue": "COPS",
            "desc": "{{{COPS_CATALOG_TITLE_LABEL}}}",
            "validator": {
                "allowBlank": false
            }
        }]
    }]
},{
    "step_title": "{{{COPS_CONFIGURATION_SECOND_STEP_TITLE}}}",
    "items": [{
        "type": "multiselect",
        "desc": "{{{DO_YOU_WANT_TO_USE_COPS_WITH_A_KOBO_DESCRIPTION}}}",
        "subitems": [{
            "key": "wizard_use_url_rewriting",
            "desc": "{{{DO_YOU_WANT_TO_USE_COPS_WITH_A_KOBO_LABEL}}}"
        }]
    }]
},{
    "step_title": "{{{DSM_PERMISSIONS_TITLE}}}",
    "items": [
        {
            "desc": "{{{DSM_PERMISSIONS_TEXT}}}"
        }
    ]
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
