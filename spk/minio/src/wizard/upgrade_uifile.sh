#!/bin/sh

INST_ETC="/var/packages/${SYNOPKG_PKGNAME}/etc"
INST_VARIABLES="${INST_ETC}/installer-variables"
MINIO_DATA_FORMAT="unknown"

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


# Evaluate the current data path
FORMER_SHARE_NAME="${SHARE_NAME}"
FORMER_SHARE_PATH="${SHARE_PATH}"
if [ -n "${WIZARD_DATA_VOLUME}" -a -n "${WIZARD_DATA_DIRECTORY}" ]; then
   FORMER_SHARE_NAME="${WIZARD_DATA_DIRECTORY}"
   FORMER_SHARE_PATH="${WIZARD_DATA_VOLUME}/${WIZARD_DATA_DIRECTORY}"
fi


# Evaluate the current data format
if [ -d "${FORMER_SHARE_PATH}" ]; then
   if [ -d "${FORMER_SHARE_PATH}/.minio.sys" ]; then
      if [ -r "${FORMER_SHARE_PATH}/.minio.sys/format.json" ]; then
         MINIO_DATA_FORMAT=$(cat "${FORMER_SHARE_PATH}/.minio.sys/format.json" | jq '.format' | tr -d '"')
      fi
   fi
fi


TITLE_STEP_1="MinIO configuration"
TITLE_STEP_2="MinIO - Migration Notes"

UPDATE_TEXT_INFO="<b>This MinIO installation uses already the new data format.</b><br/> <b style=\\\"color: green\\\">You will be able to update to future minio package versions.</b>"
UPDATE_TEXT_WARNING1="<b>This MinIO installation uses the FS data format.</b><br/> <b style=\\\"color: red\\\">Future minio versions will not be installable without prior manual data migration.</b>"
UPDATE_TEXT_WARNING2="<b>You changed the MinIO data directory or the data format could not be evaluated.</b><br/> <b style=\\\"color: orange\\\">Future minio versions will only be installable when the folder does not contain MinIO data in the FS Format.</b>"

quote_json ()
{
   sed -e 's|\\|\\\\|g' -e 's|\"|\\\"|g'
}

# when leaving step1 set first text in step2
deactivateFunction ()
{
   DEACTIVATE=$(/bin/cat<<EOF
{
   function findStepByTitle(wizardDialog, title) {
      for (var i = 0; i < wizardDialog.customuiIds.length; i++) {
         var step = wizardDialog.getStep(wizardDialog.customuiIds[i]);
         if (title === step.headline) {
            return step;
         }
      }
      return null;
   }
   function getValue(wizardDialog, stepTitle, key)
   {
      var step = findStepByTitle(wizardDialog, stepTitle);
      if (!step) {
         return null;
      } else {
         var component = step.getComponent(key);
         if (!component) {
            return null;
         } else {
            return component.getValue();
         }
      }
   }
   function getDataFormat(wizardDialog) {
      var wizard_data_dir = getValue(wizardDialog,"${TITLE_STEP_1}","wizard_data_directory");
      if (wizard_data_dir === "${FORMER_SHARE_NAME}") {
         return "${MINIO_DATA_FORMAT}";
      } else {
         return "unknown";
      }
   }
   var currentStep = arguments[0];
   var wizardDialog = currentStep.owner;
   var step2 = findStepByTitle(wizardDialog, "${TITLE_STEP_2}");
   var dataFormat = getDataFormat(wizardDialog);
   if (currentStep.headline === "${TITLE_STEP_1}") {
      var textComponent = step2.getComponent(0);
      if (textComponent) {
         if ( dataFormat == "xl" || dataFormat == "xl-single" ) {
            textComponent.setValue("${UPDATE_TEXT_INFO}");
         } else if (dataFormat == "fs") {
            textComponent.setValue("${UPDATE_TEXT_WARNING1}");
         } else {
            textComponent.setValue("${UPDATE_TEXT_WARNING2}");
         }
      } else {
         console.log("ERROR:", "textComponent not found");
      }
   }
}
EOF
)
   echo "${DEACTIVATE}" | quote_json
}

cat <<EOF > $SYNOPKG_TEMP_LOGFILE
[
   {
      "step_title": "${TITLE_STEP_1}",
      "deactivate_v2": "$(deactivateFunction)",
      "items": [
         {
            "type": "textfield",
            "desc": "Data shared folder. This must be a name for the shared folder only, without any path. This share is created at installation when it does not already exist.",
            "subitems": [
               {
                  "key": "wizard_data_directory",
                  "desc": "Data shared folder",
                  "defaultValue": "${FORMER_SHARE_NAME}",
                  "validator": {
                     "allowBlank": false,
                     "regex": {
                        "expr": "/^[^<>: */?\"]*/",
                        "errorText": "Share name must be a folder name only. Path separators, spaces and other special chars are not allowed."
                     }
                  }
               }
            ]
         },
         {
            "desc": "If you let the installer create the shared folder, it is created under the same volume as the package is installed. If you want to use a different volume for the share, you must create the shared folder in DSM Control Panel before, and enter the name of the existing share in the field above."
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
      "step_title": "${TITLE_STEP_2}",
      "items": [
         {
            "desc": "This text is set before activating this page."
         },
         {
            "desc": "MinIO removed support for the filesystem mode which is a 1:1 mapping of buckets to files on disk. If your deployment uses filesystem mode you need to manually migrate to single-node single-drive deployment setup. Future MinIO packages will support the new format only."
         },
         {
            "desc": "Because of the complexity and risks involved, an automatic upgrade process is not available. The official MinIO documentation provides a guide for doing so, see <a target=\"_blank\" href=\"https://min.io/docs/minio/linux/operations/install-deploy-manage/migrate-fs-gateway.html\">Migrate from Gateway or Filesystem Mode</a>."
         }
      ]
   }
]
EOF
exit 0
