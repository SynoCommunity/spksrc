#!/bin/sh

INST_ETC="/var/packages/${SYNOPKG_PKGNAME}/etc"
INST_VARIABLES="${INST_ETC}/installer-variables"

# Reload wizard variables stored by postinst
if [ -r "${INST_VARIABLES}" ]; then
    . "${INST_VARIABLES}"
fi

cat <<EOF > $SYNOPKG_TEMP_LOGFILE
[
	{
		"step_title": "MinIO configuration",
		"items": [
			{
                "type": "combobox",
                "desc": "Please select a volume to use for the data folder",
                "subitems": [
                    {
                        "key": "wizard_data_volume",
                        "desc": "volume name",
						"defaultValue": "${WIZARD_DATA_VOLUME}",
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
                            "fn": "{console.log(arguments);return true;}"
                        }
                    }
                ]
            },
			{
                "type": "textfield",
                "desc": "data shared folder (using the volume chosen above)",
                "subitems": [
                    {
                        "key": "wizard_data_directory",
                        "desc": "data shared folder",
						"defaultValue": "${WIZARD_DATA_DIRECTORY}",
                        "validator": {
                            "allowBlank": false,
                            "regex": {
                                "expr": "/^[\\w _-]+$/",
                                "errorText": "Subdirectories are not supported."
                            }
                        }
                    }
                ]
            },
			{
				"type": "textfield",
				"subitems": [
					{
						"key": "wizard_root_user",
						"desc": "MinIO root user",
						"defaultValue": "${WIZARD_ROOT_USER}",
						"validator": {
							"allowBlank": false,
							"minLength": 3,
							"regex": {
								"expr": "/^[^<>:*/?\"|]*$/",
								"errorText": "Not allowed character in username"
							}
						}
					},
					{
						"key": "wizard_root_password",
						"desc": "MinIO root password",
						"defaultValue": "${WIZARD_ROOT_PASSWORD}",
						"validator": {
							"allowBlank": false,
							"minLength": 8,
							"regex": {
								"expr": "/^[^\"|]*$/",
								"errorText": "Not allowed character in password"
							}
						}
					}
				]
			}
		]
	},
	{
        "step_title": "DSM Permissions",
        "items": [
            {
                "desc": "Please read <a target=\"_blank\" href=\"https://github.com/SynoCommunity/spksrc/wiki/Permission-Management\">Permission Management</a> for details."
            }
        ]
    }
]




[
	{
		"step_title": "MinIO configuration",
		"items": [
		  {
			"type": "textfield",
			"subitems": [
			  {
				"key": "wizard_data_directory",
				"desc": "Data directory location",
				"defaultValue": "${WIZARD_DATA_DIRECTORY}",
				"validator": {
				  "allowBlank": false,
				  "regex": {
					"expr": "/^\\\/volume[0-9]{1,2}\\\/[^<>: */?\"]*/",
					"errorText": "Path should begin with /volume?/ where ? is volume number (1-99)"
				  }
				}
			  },
			  {
				"key": "wizard_access_key",
				"desc": "MinIO access key",
				"defaultValue": "${WIZARD_ACCESS_KEY}",
				"validator": {
				  "allowBlank": false,
				  "minLength": 3,
				  "regex": {
					"expr": "/^[^<>:*/?\"|]*$/",
					"errorText": "Not allowed character in key"
				  }
				}
			  },
			  {
				"key": "wizard_secret_key",
				"desc": "MinIO secret key",
				"defaultValue": "${WIZARD_SECRET_KEY}",
				"validator": {
				  "allowBlank": false,
				  "minLength": 8,
				  "regex": {
					"expr": "/^[^\"|]*$/",
					"errorText": "Not allowed character in key"
				  }
				}
			  }
			]
		  }
		]
	},
	{
		"step_title": "Attention! DSM6 Permissions",
		"items": [{
			"desc": "Permissions for this package are handled by the <b>'sc-minio'</b> group. <br>Using File Station, add this group to every folder minio should be allowed to access.<br>Please read <a <a target=\"_blank\" href=\"https://github.com/SynoCommunity/spksrc/wiki/Permission-Management\">Permission Management</a> for details."
		}]
	}
]
EOF
exit 0
