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
    PHP_CFG_PATH="/usr/syno/etc/packages/WebStation/PHPSettings.json"
    if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ] && \
        jq -e 'to_entries | map(select((.key | startswith("com-synocommunity-packages-")) and .key != "com-synocommunity-packages-tt-rss")) | length > 0' "${PHP_CFG_PATH}" >/dev/null; then
        return 0  # true
    else
        return 1  # false
    fi
}

PAGE_TTRSS_SETUP=$(/bin/cat<<EOF
{
    "step_title": "{{DB_CONFIGURATION_TITLE}}",
    "invalid_next_disabled_v2": true,
    "items": [{
        "type": "multiselect",
        "subitems": [{
            "key": "wizard_run_migration",
            "desc": "Run migration",
            "defaultValue": false,
            "hidden": true
        }, {
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
    }, {
        "type": "password",
        "desc": "{{ENTER_MYSQL_PASSWORD}}",
        "subitems": [{
            "key": "wizard_mysql_password_root",
            "desc": "{{ROOT_PASSWORD_DESCRIPTION}}",
            "validator": {
                "allowBlank": false
            }
        }]
    }, {
        "type": "password",
        "desc": "{{ENTER_TTRSS_PASSWORD}}",
        "subitems": [{
            "key": "wizard_mysql_password_ttrss",
            "desc": "{{TT-RSS_PASSWORD_DESCRIPTION}}",
            "invalidText": "{{INVALID_TT-RSS_PASSWORD}}",
            "validator": {
                "fn": "$(getPasswordValidator)"
            }
        }]
    }]
}, {
    "step_title": "{{TT-RSS_CONFIGURATION_TITLE}}",
    "invalid_next_disabled_v2": true,
    "items": [{
        "type": "textfield",
        "desc": "{{DOMAIN_NAME_SECTION_LABEL}}",
        "subitems": [{
            "key": "wizard_domain_name",
            "desc": "{{DOMAIN_NAME_INPUT_LABEL}}",
            "defaultValue": "${INTERNAL_IP}",
            "validator": {
                "allowBlank": false
            }
        }]
    }, {
        "type": "multiselect",
        "desc": "{{SINGLE_USER_SECTION_LABEL}}",
        "subitems": [{
            "key": "wizard_single_user",
            "desc": "{{SINGLE_USER_CHECKBOX_LABEL}}"
        }]
    }]
}
EOF
)

PAGE_PHP_PROFILES=$(/bin/cat<<EOF
{
    "step_title": "{{PHP_PROFILES_TITLE}}",
    "items": [{
        "desc": "{{PHP_PROFILES_DESCRIPTION}}"
    }]
}
EOF
)

main () {
    local install_page=""
    install_page=$(page_append "$install_page" "$PAGE_TTRSS_SETUP")
    if check_php_profiles; then
        install_page=$(page_append "$install_page" "$PAGE_PHP_PROFILES")
    fi
    echo "[$install_page]" > "${SYNOPKG_TEMP_LOGFILE}"
}

main "$@"
