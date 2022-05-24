#!/bin/sh

ADMIN_TOKEN="$(openssl rand -base64 48)"

cat <<EOF > $SYNOPKG_TEMP_LOGFILE
[{
    "step_title": "Vaultwarden server configuration",
    "items": [{
        "type": "textfield",
        "subitems": [{
            "key": "wizard_domain",
            "desc": "Domain",
            "defaultValue": "https://localhost",
            "validator": {
              "allowBlank": false,
              "minLength": 3
            }
          }
        ]
      }, {
        "type": "textfield",
        "subitems": [{
            "key": "wizard_admin_token",
            "desc": "Admin token: ",
            "defaultValue": "${ADMIN_TOKEN}",
            "validator": {
              "allowBlank": true,
              "minLength": 63
            }
          }
        ]
      }, {
        "desc": "The admin token is required to access the admin interface. Leave empty to disable admin interface."
      }, {
        "desc": "You need the token to access the admin UI for futher configuration, please copy it now."
      }
    ]
  }
]
EOF
exit 0
