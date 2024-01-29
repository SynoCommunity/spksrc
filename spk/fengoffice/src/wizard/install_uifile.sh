#!/bin/bash

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
    "step_title": "Feng Office database configuration",
    "invalid_next_disabled_v2": true,
    "items": [{
        "type": "password",
        "desc": "Enter your MySQL password.",
        "subitems": [{
            "key": "wizard_mysql_password_root",
            "desc": "Root password",
            "validator": {
                "allowBlank": false
            }
        }]
    }, {
        "type": "password",
        "desc": "A 'fengoffice' MySQL user and database will be created. Please enter a password for the 'fengoffice' user.",
        "subitems": [{
            "key": "wizard_mysql_password_fengoffice",
            "desc": "fengoffice password",
            "invalidText": "Password is invalid. Ensure it includes at least one uppercase letter, one lowercase letter, one digit, one special character, and has a minimum length of 10 characters.",
            "validator": {
                "fn": "$(getPasswordValidator)"
            }
        }]
    }]
}, {
    "step_title": "Feng Office configuration",
    "invalid_next_disabled_v2": true,
    "items": [{
        "type": "textfield",
        "desc": "Domain name of your DiskStation. For example: you.synology.me.",
        "subitems": [{
            "key": "wizard_domain_name",
            "desc": "Domain name",
            "defaultValue": "${INTERNAL_IP}",
            "validator": {
                "allowBlank": false
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
