#!/bin/sh
set +x 

GetShares()
{
	for share in `sudo /usr/syno/sbin/synoshare  --enum ALL|tail -n +3`; do 
		echo "[\"$share\", \"$share (`sudo /usr/syno/sbin/synoshare --get "${share}"|sed -n 's/.*Path.*\[\(.*\)\]/\1/p'`)\"]"
	done  | tr -s '\n' ',' | sed -e 's/,$//'
}


FIRST=`/bin/cat<<EOF
{
		"step_title": "Choose data location",
		"items": [{
                "desc": "The installer will download and build the latest versions of hass.io and homeassistant. <br/>Please fill the desired storage location for the data directory below."
            },{
			"type": "combobox",
			"subitems": [{
				"key": "share_path",
				"desc": "Shared Folder to store hass.io data in",
				"editable": false,
				"mode": "local",
				"value": "null",
				"valueField": "name",
				"displayField": "display_name",
				"store": {
					"xtype": "arraystore",
					"fields": ["name", "display_name"],
					"data": [$(GetShares)]
				}
			}]
		}, {
			"type": "textfield",
			"subitems": [{
				"key": "folder_name",
				"desc": "Data folder name",
				"value": "hass.io",
				"disabled": false
			}]
		}]
	}
EOF`

echo "[$FIRST]" > $SYNOPKG_TEMP_LOGFILE

exit 0
[
    {
        "step_title": "Configuration location",
        "items": [
            {
                "desc": "The installer will download and build the latest versions of hass.io and homeassistant. <br/>Please fill the desired storage location for the data directory below."
            },
            {
                "type": "textfield",
                "subitems": [{
                        "key": "data_dir",
                        "desc": "Data directory",
                        "defaultValue": "/volume1/hass.io",
                        "validator": {
                            "allowBlank": false,
                            "regex": {
                                "expr": "/^\\\/volume\\w*[0-9]{1,2}\\\/[^<>: */?\"]*/",
                                "errorText": "Path should begin with /volumename?/ where volumename can be 'volume' or also 'volumeUSB' and ? is the volume number (1-99)."
                            }
                        }
                    }]
            }
        ]
    }
]
