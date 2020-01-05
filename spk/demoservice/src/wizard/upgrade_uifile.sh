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
    "step_title": "Example configuration for demoservice",
    "items": [
      {
        "type": "textfield",
        "desc": "Download configuration",
        "subitems": [
          {
            "key": "wizard_download_dir",
            "desc": "Download location",
            "defaultValue": "${SHARE_PATH}",
            "validator": {
              "allowBlank": false,
              "regex": {
                "expr": "/^\\\/volume[0-9]{1,2}\\\/[^<>: */?\"]*/",
                "errorText": "Path should begin with /volume?/ where ? is volume number (1-99)"
              }
            }
          },
          {
            "key": "wizard_group",
            "desc": "DSM group",
            "defaultValue": "${GROUP}",
            "validator": {
              "allowBlank": false,
              "regex": {
                "expr": "/^[^<>:*/?\"]*$/",
                "errorText": "Not allowed character in group name"
              }
            }
          },
          {
            "key": "wizard_custom_option",
            "desc": "Demoservice custom option",
            "defaultValue": "${CUSTOM_OPTION}",
          }
        ]
      }
    ]
  },
  {
    "step_title": "Attention! DSM Permissions",
    "items": [
      {
        "desc": "Permissions are managed with the group <b>'sc-download'</b> in DSM."
      }
    ]
  }
]
EOF
exit 0
