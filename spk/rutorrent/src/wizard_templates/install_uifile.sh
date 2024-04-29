
wizard_download_share_validator()
{
  jsonify "{
  var value = arguments[0];
  var step = arguments[2];
  step.items.map['wizard_download_dir'].setValue(step.items.map['wizard_download_volume'].value + '/' + value + '/');
  return true;
}"
}

wizard_download_volume_validator()
{
  jsonify "{
  var value = arguments[0];
  var step = arguments[2];
  step.items.map['wizard_download_dir'].setValue(value + '/' + step.items.map['wizard_download_share'].value + '/');
  return true;
}"
}

base_install_step() {
  cat <<END_OF_STEP
{
    "step_title": "${BASE_INSTALL_STEP_TITLE}",
    "items": [
        {
            "type": "combobox",
            "desc": "${SELECT_VOLUME}",
            "subitems": [
                {
                    "key": "wizard_download_volume",
                    "desc": "${SELECT_VOLUME_INPUT_LABEL}",
                    "defaultValue": "/volume1",
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
                }
            ]
        },
        {
            "type": "textfield",
            "desc": "${DOWNLOAD_SHARED_FOLDER}",
            "subitems": [
                {
                    "key": "wizard_download_share",
                    "desc": "${DOWNLOAD_SHARED_FOLDER_LOCATION}",
                    "defaultValue": "downloads",
                    "validator": {
                        "allowBlank": false,
                        "regex": {
                            "expr": "$(jsonify "/^[\\w _-]+$/")",
                            "errorText": "${SUBDIRECTORIES_ARE_NOT_SUPPORTED}"
                        },
                        "fn": "$(wizard_download_share_validator)"
                    }
                },
                {
                  "key": "wizard_download_dir",
                  "desc": "Full path to the shared download folder",
                  "hidden": true,
                  "defaultValue": "/volume1/downloads/"
                }
            ]
        },
        {
            "desc": "${IF_SPECIFIED_SHARE_DOES_NOT_EXIST}"
        },
        {
            "type": "textfield",
            "desc": "${WATCH_DIR_DESC}",
            "subitems": [
                {
                    "key": "wizard_watch_dir",
                    "desc": "${WATCH_DIR_INPUT_DESC}",
                    "validator": {
                        "allowBlank": true
                    }
                }
            ]
        },
        {
            "desc": "${PERMISSION_MANAGEMENT}"
        }
    ]
}
END_OF_STEP
}

additional_configuration_step() {
  cat <<END_OF_STEP
       {
           "step_title": "${ADDITIONAL_CONFIGURATION_STEP_TITLE}",
           "items": [
               {
                   "type": "multiselect",
                   "desc": "${WEB_INTERFACE_ITEM_DESC}",
                   "subitems": [
                       {
                           "key": "wizard_disable_openbasedir",
                           "desc": "${DISABLE_OPEN_DIR_INPUT_DESC}",
                           "defaultValue": true
                       }
                   ]
               }
           ]
       }
END_OF_STEP
}

{
  echo "[";
  base_install_step;
  if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ]; then
    echo ",";
    additional_configuration_step;
  fi
  echo "]";
}> "${SYNOPKG_TEMP_LOGFILE}"
