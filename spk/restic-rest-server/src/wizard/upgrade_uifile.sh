#!/bin/sh

INST_ETC="/var/packages/${SYNOPKG_PKGNAME}/etc"
INST_VARIABLES="${INST_ETC}/installer-variables"

# Reload wizard variables stored by postinst
if [ -r "${INST_VARIABLES}" ]; then
    # we cannot source the file to reload the variables, when values have special characters like <, >, ...
    for _line in $(cat "${INST_VARIABLES}"); do
        _key="$(echo ${_line} | awk -F'=' '{print $1}')"
        _value="$(echo ${_line} | awk -F'=' '{print $2}')"
        declare "${_key}=${_value}"
    done
fi

function default_if_true(){
   if [ "$1" == "true" ]; then
      echo "true"
   else
      echo "false"
   fi
}

function default_if_false(){
   if [ "$1" == "false" ]; then
      echo "true"
   else
      echo "false"
   fi
}

cat <<EOF > $SYNOPKG_TEMP_LOGFILE
[
   {
      "step_title": "Restic rest-server configuration",
      "items": [
         {
            "type": "combobox",
            "desc": "Please select a volume to use for the data folder",
            "subitems": [
               {
                  "key": "wizard_data_volume",
                  "desc": "Volume name",
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
            "desc": "Data shared folder (using the volume chosen above)",
            "subitems": [
               {
                  "key": "wizard_data_directory",
                  "desc": "Data shared folder",
                  "defaultValue": "${WIZARD_DATA_DIRECTORY}",
                  "validator": {
                     "allowBlank": false,
                     "regex": {
                        "expr": "/^[\\\\w _-]+$/",
                        "errorText": "Subdirectories are not supported."
                     }
                  }
               }
            ]
         },
         {
            "desc": "The folder will be created on demand as regular DSM shared folder for the service user <b>sc-restic-rest-server</b>. For details about the DSM permissions see <a target=\"_blank\" href=\"https://github.com/SynoCommunity/spksrc/wiki/Permission-Management\">Permission Management</a>.<p/>"
         },
         {
            "desc": "Please define the following settings for restic rest-server:"
         },
         {
            "type": "singleselect",
            "desc": "Append only mode",
            "subitems": [
               {
                  "key": "wizard_append_only",
                  "desc": "enabled",
                  "defaultValue": $(default_if_true ${WIZARD_APPEND_ONLY})
               },
               {
                  "key": "",
                  "desc": "disabled",
                  "defaultValue": $(default_if_false ${WIZARD_APPEND_ONLY})
               }
            ]
         },
         {
            "type": "singleselect",
            "desc": "Private repositories",
            "subitems": [
               {
                  "key": "wizard_private_repos",
                  "desc": "enable",
                  "defaultValue": $(default_if_true ${WIZARD_PRIVATE_REPOS})
               },
               {
                  "key": "",
                  "desc": "disabled",
                  "defaultValue": $(default_if_false ${WIZARD_PRIVATE_REPOS})
               }
            ]
         },
         {
            "type": "singleselect",
            "desc": "Prometheus",
            "subitems": [
               {
                  "key": "wizard_prometheus",
                  "desc": "enable",
                  "defaultValue": $(default_if_true ${WIZARD_PROMETHEUS})
               },
               {
                  "key": "",
                  "desc": "disabled",
                  "defaultValue": $(default_if_false ${WIZARD_PROMETHEUS})
               }
            ]
         },
         {
            "type": "singleselect",
            "desc": "Prometheus no auth",
            "subitems": [
               {
                  "key": "wizard_prometheus_no_auth",
                  "desc": "enable",
                  "defaultValue": $(default_if_true ${WIZARD_PROMETHEUS_NO_AUTH})
               },
               {
                  "key": "",
                  "desc": "disabled",
                  "defaultValue": $(default_if_false ${WIZARD_PROMETHEUS_NO_AUTH})
               }
            ]
         }
      ]
   }
]
EOF
exit 0
