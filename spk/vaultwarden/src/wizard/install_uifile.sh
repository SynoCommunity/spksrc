#!/bin/sh

ADMIN_TOKEN="$(openssl rand -base64 48)"

cat <<EOF > $SYNOPKG_TEMP_LOGFILE
[{
    "step_title": "Vaultwarden server configuration",
    "items": [{
        "desc": "<span style='color:#cc0000;font-weight:bold'>&#9888; HTTPS Required:</span> Vaultwarden uses the Web Crypto API which requires a secure context. You must configure a reverse proxy with SSL before accessing the web interface.<br><br>See the <a href='https://github.com/SynoCommunity/spksrc/wiki/Vaultwarden' target='_blank'>Vaultwarden wiki page</a> for setup instructions."
      }, {
        "type": "textfield",
        "subitems": [{
            "key": "wizard_domain",
            "desc": "Domain URL (must be HTTPS)",
            "defaultValue": "https://your-domain.com",
            "validator": {
              "allowBlank": false,
              "minLength": 8
            }
          }
        ]
      }, {
        "type": "textfield",
        "subitems": [{
            "key": "wizard_admin_token",
            "desc": "Admin token",
            "defaultValue": "${ADMIN_TOKEN}",
            "validator": {
              "allowBlank": true,
              "minLength": 63
            }
          }
        ]
      }, {
        "desc": "Admin token grants access to /admin interface. Leave empty to disable. <b>Copy this token now</b> - it will not be shown again."
      }
    ]
  }
]
EOF
exit 0
