#!/bin/bash

quote_json ()
{
    sed -e 's|\\|\\\\|g' -e 's|\"|\\\"|g'
}

page_append ()
{
    if [ -z "$1" ]; then
        echo "$2"
    elif [ -z "$2" ]; then
        echo "$1"
    else
        echo "$1,$2"
    fi
}

IMMICH_ENABLE_ML="wizard_enable_ml"
PIP_MIRROR_ENABLE="wizard_enable_pip_mirror"
PIP_MIRROR_URL="wizard_pip_index_url"


toggleML()
{
    TOGGLE_ML=$(/bin/cat <<EOF
{
    var selected = arguments[0];
    var step = arguments[2];
    var mirrorEnable = step.getComponent("${PIP_MIRROR_ENABLE}");
    var mirrorEnableLabel = mirrorEnable.previousSibling();
    var mirrorUrl = step.getComponent("${PIP_MIRROR_URL}");
    var mirrorUrlLabel = mirrorUrl.previousSibling();

    if (selected && mirrorEnable && mirrorEnable.hidden) {
        mirrorEnable.setVisible(true);
        mirrorEnableLabel.setVisible(true);
        mirrorEnable.setDisabled(false);
    } else if (!selected) {
        mirrorEnable.setValue(false);
        mirrorEnable.setVisible(false);
        mirrorEnableLabel.setVisible(false);
        mirrorEnable.setDisabled(true);
        mirrorUrl.setValue("");
        mirrorUrl.setVisible(false);
        mirrorUrlLabel.setVisible(false);
        mirrorUrl.setDisabled(true);
    }

    return true;
}
EOF
)
    echo "$TOGGLE_ML" | quote_json
}


togglePipMirror()
{
    TOGGLE_PIP_MIRROR=$(/bin/cat <<EOF
{
    var checked = arguments[0];
    var step = arguments[2];
    var enableMl = step.getComponent("${IMMICH_ENABLE_ML}");
    var mirrorEnable = step.getComponent("${PIP_MIRROR_ENABLE}");
    var mirrorEnableLabel = mirrorEnable.previousSibling();
    var mirrorUrl = step.getComponent("${PIP_MIRROR_URL}");
    var mirrorUrlLabel = mirrorUrl.previousSibling();

    if (checked && mirrorUrl.hidden && enableMl) {
        mirrorUrl.setVisible(true);
        mirrorUrlLabel.setVisible(true);
        mirrorUrl.setDisabled(false);
    } else if (!checked && !mirrorUrl.hidden) {
        mirrorUrl.setValue("");
        mirrorUrl.setVisible(false);
        mirrorUrlLabel.setVisible(false);
        mirrorUrl.setDisabled(true);
    }

    return true;
}
EOF
)
    echo "$TOGGLE_PIP_MIRROR" | quote_json
}


validatePipMirror()
{
    VALIDATE_PIP_MIRROR=$(/bin/cat <<'EOF'
{
    var url = arguments[0];

    if (url === "") {
        return "Mirror URL cannot be empty.";
    }

    if (/^https?:\/\/.+/.test(url)) {
        return true;
    }

    return "Mirror URL must start with http:// or https://";
}
EOF
)
    echo "$VALIDATE_PIP_MIRROR" | quote_json
}


PW_REGEX=$(/bin/cat <<'REGEX'
/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*?{}()\[\]\-=_+\;'":<>/,.])[A-Za-z\d!@#$%^&*?{}()\[\]\-=_+\;'":<>/,.]{10,}$/
REGEX
)
PW_REGEX=$(echo "$PW_REGEX" | quote_json)

MEDIA_REGEX=$(/bin/cat <<'REGEX'
/^[\w _-]+$/
REGEX
)
MEDIA_REGEX=$(echo "$MEDIA_REGEX" | quote_json)


PAGE_POSTGRESQL=$(/bin/cat <<EOF
{
    "step_title": "PostgreSQL Configuration",
	"invalid_next_disabled_v2": true,
    "items": [{
        "desc": "Immich requires a PostgreSQL database. Enter the admin credentials to create the database, and a password for the Immich database user."
    }, {
        "type": "textfield",
        "desc": "Admin username (default: pgadmin)",
        "subitems": [{
            "key": "wizard_pg_username_admin",
            "desc": "Username",
            "defaultValue": "pgadmin",
            "validator": {
                "allowBlank": false
            }
        }]
    }, {
        "type": "password",
        "desc": "Admin password",
        "subitems": [{
            "key": "wizard_pg_password_admin",
            "desc": "Password",
            "validator": {
                "allowBlank": false
            }
        }]
    }, {
        "type": "password",
        "desc": "Immich database password",
        "subitems": [{
            "key": "wizard_pg_password_immich",
            "desc": "Database password",
            "validator": {
                "allowBlank": false,
                "regex": {
                    "expr": "${PW_REGEX}",
                    "errorText": "Password must be at least 10 characters and include: uppercase, lowercase, number, and special character."
                }
            }
        }]
    }]
}
EOF
)


PAGE_MEDIA=$(/bin/cat <<EOF
{
    "step_title": "Media Storage",
	"invalid_next_disabled_v2": true,
    "items": [{
        "desc": "Specify a shared folder for photo and video storage. This share is created if it does not already exist."
    }, {
        "type": "textfield",
        "subitems": [{
            "key": "wizard_media_share",
            "desc": "Shared folder",
            "defaultValue": "immich-media",
            "validator": {
                "allowBlank": false,
                "regex": {
                    "expr": "${MEDIA_REGEX}",
                    "errorText": "Shared folder name must not contain path separators or special characters."
                }
            }
        }]
    }]
}
EOF
)


PAGE_MACHINE_LEARNING=$(/bin/cat <<EOF
{
    "step_title": "Machine Learning",
	"invalid_next_disabled_v2": true,
    "items": [{
        "desc": "Optional: enables smart search, facial recognition, and OCR. Downloads ~300 MB of ML dependencies on first install."
    }, {
        "type": "singleselect",
        "desc": "Enable Machine Learning",
        "subitems": [{
            "key": "${IMMICH_ENABLE_ML}",
            "desc": "Enabled",
            "defaultValue": false,
            "validator": {
                "fn": "$(toggleML)"
            }
        }, {
            "key": "wizard_disable_ml",
            "desc": "Disabled",
            "defaultValue": true
        }]
    }, {
        "type": "multiselect",
        "desc": "PyPI mirror",
        "subitems": [{
            "key": "${PIP_MIRROR_ENABLE}",
            "desc": "Use custom mirror",
            "defaultValue": false,
            "validator": {
                "fn": "$(togglePipMirror)"
            }
        }]
    }, {
        "type": "textfield",
        "desc": "Mirror URL",
        "subitems": [{
            "key": "${PIP_MIRROR_URL}",
            "emptyText": "https://pypi.example.com/simple",
            "validator": {
                "fn": "$(validatePipMirror)"
            }
        }]
    }]
}
EOF
)


main ()
{
    local install_page=""

    install_page=$(page_append "$install_page" "$PAGE_POSTGRESQL")
    install_page=$(page_append "$install_page" "$PAGE_MEDIA")
    install_page=$(page_append "$install_page" "$PAGE_MACHINE_LEARNING")

    echo "[$install_page]" > "${SYNOPKG_TEMP_LOGFILE}"
}

main "$@"
