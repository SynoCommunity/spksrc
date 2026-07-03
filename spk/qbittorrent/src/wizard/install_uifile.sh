#!/bin/bash

INTERNAL_IP=$(ip -4 route get 8.8.8.8 | awk '/8.8.8.8/ {for (i=1; i<NF; i++) if ($i=="src") print $(i+1)}')

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

PAGE_DOWNLOAD_FOLDER=$(/bin/cat<<EOF
{
    "step_title": "Download Location",
    "invalid_next_disabled_v2": true,
    "items": [{
        "type": "textfield",
        "desc": "Please select a shared folder for storing downloads. If this folder doesn't exist at the time of installation, it will be created.",
        "subitems": [{
            "key": "wizard_shared_folder_name",
            "desc": "Shared folder",
            "defaultValue": "downloads",
            "validator": {
                "allowBlank": false,
                "regex": {
                    "expr": "/^[\\\w.][\\\w. -]{0,30}[\\\w.-][\\\\$]?$|^[\\\w][\\\\$]?$/",
                    "errorText": "Subdirectories are not supported."
                }
            }
        }]
    }]
}
EOF
)

PAGE_CREDENTIALS=$(/bin/cat<<EOF
{
    "step_title": "WebUI Credentials",
    "invalid_next_disabled_v2": true,
    "items": [{
        "type": "textfield",
        "desc": "Web interface username",
        "subitems": [{
            "key": "wizard_username",
            "desc": "Username",
            "defaultValue": "admin",
            "validator": {
                "allowBlank": false,
                "minLength": 1
            }
        }]
    },
    {
        "type": "password",
        "desc": "Web interface password (minimum 6 characters, default: adminadmin)",
        "subitems": [{
            "key": "wizard_password",
            "desc": "Password",
            "defaultValue": "adminadmin",
            "validator": {
                "allowBlank": false,
                "minLength": 6
            }
        }]
    }]
}
EOF
)

PAGE_INFO=$(/bin/cat<<EOF
{
    "step_title": "Access & Permissions",
    "items": [{
        "desc": "<b>Web Interface</b><br>qBittorrent will be accessible at <b>http://${INTERNAL_IP}:8095</b><br>Downloads will be saved to <b>complete</b> and <b>incomplete</b> subfolders in your selected shared folder."
    },
    {
        "desc": "<b>Permissions</b><br>Permissions are managed via the <b>'synocommunity'</b> group on DSM 7, and the <b>'sc-download'</b> group on DSM 6.<br>Please read <a target=\"_blank\" href=\"https://github.com/SynoCommunity/spksrc/wiki/Permission-Management\">Permission Management</a> for details."
    }]
}
EOF
)

main () {
    local install_page=""
    install_page=$(page_append "$install_page" "$PAGE_DOWNLOAD_FOLDER")
    install_page=$(page_append "$install_page" "$PAGE_CREDENTIALS")
    install_page=$(page_append "$install_page" "$PAGE_INFO")
    echo "[$install_page]" > "${SYNOPKG_TEMP_LOGFILE}"
}

main "$@"
