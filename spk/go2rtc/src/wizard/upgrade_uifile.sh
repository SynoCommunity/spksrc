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
      "step_title": "go2rtc configuration",
      "items": [
         {
            "desc": "Please define the following credentials to access the go2rtc webUI:"
         },
         {
            "type": "textfield",
            "subitems": [
               {
                  "key": "wizard_root_user",
                  "desc": "go2rtc user",
                  "defaultValue": "${API_USER}",
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
                  "desc": "go2rtc password",
                  "defaultValue": "${API_PASSWORD}",
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
   }
]
EOF
exit 0

