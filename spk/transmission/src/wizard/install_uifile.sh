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

wizard_download_share_validator()
{
    DOWNLOAD_SHARE=$(/bin/cat<<EOF
{
    var value = arguments[0];
    var step = arguments[2];
    step.items.map['wizard_download_dir'].setValue(step.items.map['wizard_download_volume'].value + '/' + value);
    return true;
}
EOF
)
    echo "$DOWNLOAD_SHARE" | quote_json
}

wizard_download_volume_validator()
{
    DOWNLOAD_VOLUME=$(/bin/cat<<EOF
{
    var value = arguments[0];
    var step = arguments[2];
    step.items.map['wizard_download_dir'].setValue(value + '/' + step.items.map['wizard_download_share'].value);
    return true;
}
EOF
)
    echo "$DOWNLOAD_VOLUME" | quote_json
}

DIR_VALID="/^[\\w _-]+$/"

PAGE_BASE_CONFIG=$(/bin/cat<<EOF
{
    "step_title": "Basic configuration",
    "invalid_next_disabled_v2": true,
    "items": [{
            "type": "combobox",
            "desc": "Please select a volume to use for the download folder",
            "subitems": [{
                "key": "wizard_download_volume",
                "desc": "Volume name",
                "defaultValue": "volume1",
                "displayField": "display_name",
                "valueField": "volume_path",
                "editable": false,
                "mode": "remote",
                "api_store": {
                    "api": "SYNO.Core.Storage.Volume",
                    "method": "list",
                    "version": 1,
                    "baseParams": {
                        "limit": -1,
                        "offset": 0,
                        "location": "internal"
                    },
                    "root": "volumes",
                    "idProperty": "volume_path",
                    "fields": [
                        "display_name",
                        "volume_path"
                    ]
                },
                "validator": {
                    "fn": "$(wizard_download_volume_validator)"
                }
            }]
        },
        {
            "type": "textfield",
            "desc": "Download shared folder (using the volume chosen above)",
            "subitems": [{
                    "key": "wizard_download_share",
                    "desc": "Download shared folder",
                    "defaultValue": "downloads",
                    "validator": {
                        "allowBlank": false,
                        "regex": {
                            "expr": "$(echo ${DIR_VALID} | quote_json)",
                            "errorText": "Subdirectories are not supported."
                        },
                        "fn": "$(wizard_download_share_validator)"
                    }
                },
                {
                    "key": "wizard_download_dir",
                    "desc": "Full path to the shared download folder",
                    "defaultValue": "/volume1/downloads",
                    "hidden": true
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
