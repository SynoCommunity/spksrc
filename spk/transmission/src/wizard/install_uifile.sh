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

PAGE_BASE_CONFIG=$(/bin/cat<<EOF
{
    "step_title": "Basic configuration",
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
                }
            ]
        }
    ]
},
{
    "step_title": "Basic configuration",
    "items": [{
            "type": "textfield",
            "desc": "Web interface username. Defaults to admin",
            "subitems": [{
                "key": "wizard_username",
                "desc": "Username"
            }]
        },
        {
            "type": "password",
            "desc": "Web interface password. Defaults to admin",
            "subitems": [{
                "key": "wizard_password",
                "desc": "Password"
            }]
        }
    ]
},
{
    "step_title": "DSM Permissions",
    "items": [{
        "desc": "Please read <a target=\"_blank\" href=\"https://github.com/SynoCommunity/spksrc/wiki/Permission-Management\">Permission Management</a> for details."
    }]
}
EOF
)

main () {
    local install_page=""
    install_page=$(page_append "$install_page" "$PAGE_BASE_CONFIG")
    echo "[$install_page]" > "${SYNOPKG_TEMP_LOGFILE}"
}

main "$@"
