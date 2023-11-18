#!/bin/sh

INST_ETC="/var/packages/${SYNOPKG_PKGNAME}/etc"
INST_VARIABLES="${INST_ETC}/installer-variables"

# Reload wizard variables stored by postinst
if [ -r "${INST_VARIABLES}" ]; then
    # we cannot source the file to reload variables, when values have special characters.
    # This works even with following characers (e.g. for passwords): " ' < \ > :space: = $ | ...
    while read -r _line; do
        _key="$(echo ${_line} | cut --fields=1 --delimiter='=')"
        _value="$(echo ${_line} | cut --fields=2- --delimiter='=')"
        declare -g "${_key}=${_value}"
    done < ${INST_VARIABLES}
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
            "desc": "The folder will be created on demand as regular DSM shared folder for the service user <b>sc-minio</b>. For details about the DSM permissions see <a target=\"_blank\" href=\"https://github.com/SynoCommunity/spksrc/wiki/Permission-Management\">Permission Management</a>.<p/>"
         },
         {
            "desc": "Please define the following credentials to access the MinIO services:"
         },
         {
            "type": "textfield",
            "subitems": [
               {
                  "key": "wizard_root_user",
                  "desc": "MinIO root user",
                  "defaultValue": "${MINIO_ROOT_USER}",
                  "validator": {
                     "allowBlank": false,
                     "minLength": 3,
                     "regex": {
                        "expr": "/^[^<>:*/?\"|]*$/",
                        "errorText": "Not allowed character in username"
                     }
                  }
               }
            ]
         },
         {
            "type": "password",
            "subitems": [
               {
                  "key": "wizard_root_password",
                  "desc": "MinIO root password",
                  "defaultValue": "${MINIO_ROOT_PASSWORD}",
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
      "step_title": "MinIO - end of life for filesystem mode",
      "items": [
         {
            "desc": "MinIO removed support for the filesystem mode which is a 1:1 mapping of buckets to files on disk. If your deployment uses filesystem mode you need to manually migrate to single-node single-drive deployment setup. This is the only way to receive future updates of MinIO. A new MinIO package with a different name will be provided in future."
         },
         {
            "desc": "To check if you're affected by this change check your buckets manually by looking into each folder on your diskstation. If there is exactly a single file per S3 object you need to migrate your data. Otherwise you're already running a single-node single-drive deployment an can upgrade to the new MinIO package in future without a migration."
         },
         {
            "desc": "Because of the complexity and risks involved an automatic upgrade process is not available. The official MinIO documentation provides a guide for doing so called 'Migrate from Gateway or Filesystem Mode'"
         },
         {
            "desc": "For a regular user it is suggested to run an instance of MinIO on a separate system and migrate your data to this new instance. This system could be a desktop, single board computer or a server. If possible you can mount the storage from your diskstation over the network and use it directly during the migration process. After a successful migration replace the data of your current MinIO installation on your diskstation. Please stop MinIO before replacing your data and restart it afterwards."
         }
      ]
   }
]
EOF
exit 0
