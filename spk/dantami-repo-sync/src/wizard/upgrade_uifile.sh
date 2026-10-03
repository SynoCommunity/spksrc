#!/bin/sh
if [ -f /var/packages/dantami-repo-sync/var/private/accounts.json ]; then
 cat > "$SYNOPKG_TEMP_LOGFILE" <<'EXISTING'
[{"step_title": "Preserve app accounts", "items": [{"desc": "Existing app accounts and passwords will be preserved."}]}]
EXISTING
else
 cat > "$SYNOPKG_TEMP_LOGFILE" <<'WIZARDJSON'
[
  {
    "step_title": "Create an app administrator",
    "items": [
      {
        "desc": "Create an app account separate from DSM. If app accounts already exist, they are preserved and these fields do not reset them."
      },
      {
        "type": "textfield",
        "subitems": [
          {
            "key": "app_admin_user",
            "desc": "Administrator username",
            "validator": {
              "allowBlank": false,
              "regex": {
                "expr": "/^[a-zA-Z0-9][a-zA-Z0-9_.-]{2,39}$/",
                "errorText": "Use 3–40 characters: letters, numbers, dots, underscores or hyphens"
              }
            }
          }
        ]
      },
      {
        "type": "password",
        "subitems": [
          {
            "key": "app_admin_password",
            "desc": "Password · 12–72 bytes",
            "validator": {
              "allowBlank": false
            }
          },
          {
            "key": "app_admin_confirm",
            "desc": "Confirm password",
            "validator": {
              "allowBlank": false
            }
          }
        ]
      }
    ]
  }
]

WIZARDJSON
fi
