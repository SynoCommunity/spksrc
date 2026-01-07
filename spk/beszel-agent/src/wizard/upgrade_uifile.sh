#!/bin/sh

# Path to existing config files
VAR_DIR="/var/packages/beszel-agent/var"
KEY_FILE="${VAR_DIR}/key.pub"
FS_FILE="${VAR_DIR}/extra_fs.conf"

# Read current values if they exist
CURRENT_KEY=""
[ -f "${KEY_FILE}" ] && CURRENT_KEY=$(cat "${KEY_FILE}")

CURRENT_FS=""
[ -f "${FS_FILE}" ] && CURRENT_FS=$(cat "${FS_FILE}")

# The Package Center expects the JSON to be written to SYNOPKG_TEMP_LOGFILE
# If SYNOPKG_TEMP_LOGFILE is not set (e.g., manual testing), we fall back to stdout
[ -z "$SYNOPKG_TEMP_LOGFILE" ] && SYNOPKG_TEMP_LOGFILE="/dev/stdout"

cat << EOF > "${SYNOPKG_TEMP_LOGFILE}"
[
  {
    "step_title": "Beszel Agent Configuration (Update/Modify)",
    "items": [
      {
        "type": "textfield",
        "desc": "Provide the SSH public key of the Beszel Hub you want to add this system to.",
        "subitems": [
          {
            "key": "wizard_pub_key",
            "desc": "Public Key",
            "defaultValue": "${CURRENT_KEY}",
            "validator": {
              "allowBlank": false,
              "regex": {
                "expr": "/^(ssh-(rsa|ed25519)|ecdsa-sha2-nistp(256|384|521)) [A-Za-z0-9+/]+={0,3}( .+)?$/",
                "errorText": "Please enter a valid SSH public key."
              }
            }
          }
        ]
      },
      {
        "desc": "The Beszel agent listens on port 45876 by default. Make sure this port is accessible from your Beszel Hub."
      },
      {
        "type": "textfield",
        "desc": "Enter additional filesystems to monitor (comma-separated, e.g., /volume1,/volumeUSB1/usbshare).",
        "subitems": [
          {
            "key": "wizard_extra_fs",
            "desc": "Extra Filesystems",
            "defaultValue": "${CURRENT_FS}"
          }
        ]
      }
    ]
  }
]
EOF

exit 0