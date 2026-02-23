#!/bin/sh

# Check if admin ACL is properly configured in existing ejabberd.yml
# Show wizard only if admin ACL is missing or has no users defined

# On DSM 6: /var/packages/ejabberd/var -> /volume1/@appstore/ejabberd/var
# On DSM 7: /var/packages/ejabberd/var -> /volume1/@appdata/ejabberd
#           /var/packages/ejabberd/target/var -> /volume1/@appstore/ejabberd/var
# Check both locations to find the config file
CONFIG_FILE=""
if [ -f "/var/packages/ejabberd/var/ejabberd.yml" ]; then
    CONFIG_FILE="/var/packages/ejabberd/var/ejabberd.yml"
elif [ -f "/var/packages/ejabberd/target/var/ejabberd.yml" ]; then
    CONFIG_FILE="/var/packages/ejabberd/target/var/ejabberd.yml"
fi

# Default: don't show wizard
SHOW_WIZARD=false

if [ -n "${CONFIG_FILE}" ]; then
    # Extract the admin ACL section and check for user entries
    # Looking for pattern:
    #   admin:
    #     user:
    #       - "user@domain"
    
    # Check if admin section exists with user entries (not placeholder)
    ADMIN_USERS=$(awk '
        /^  admin:/ { in_admin=1; next }
        in_admin && /^    user:/ { in_user=1; next }
        in_admin && /^  [a-z]/ { in_admin=0; in_user=0 }
        in_user && /^      - "[^@]+@[^"]+"/ { if ($0 !~ /@@adminuser@@/) print }
    ' "${CONFIG_FILE}")
    
    # Show wizard if no valid admin users found
    if [ -z "${ADMIN_USERS}" ]; then
        SHOW_WIZARD=true
    fi
fi

if [ "${SHOW_WIZARD}" = "true" ]; then
    cat <<EOF > $SYNOPKG_TEMP_LOGFILE
[{
    "step_title": "ejabberd Admin Account Migration",
    "items": [{
        "desc": "Web admin access requires an admin ACL in the configuration file. Please enter your existing ejabberd administrator account details to configure web admin access.<br><br>The account will be validated against the ejabberd database before the upgrade proceeds."
      }, {
        "type": "textfield",
        "desc": "Administrator username (without @domain)",
        "subitems": [{
            "key": "wizard_ejabberd_admin_username",
            "desc": "Username",
            "defaultValue": "admin",
            "validator": {
                "allowBlank": false
            }
        }]
      }, {
        "type": "textfield",
        "desc": "Domain (must match your existing ejabberd configuration)",
        "subitems": [{
            "key": "wizard_ejabberd_hostname",
            "desc": "Domain",
            "defaultValue": "localhost",
            "validator": {
                "allowBlank": false
            }
        }]
      }
    ]
  }
]
EOF

fi
exit 0
