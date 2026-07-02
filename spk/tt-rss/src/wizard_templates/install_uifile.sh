#!/bin/bash

INTERNAL_IP=$(ip -4 route get 8.8.8.8 | awk '/8.8.8.8/ {for (i=1; i<NF; i++) if ($i=="src") print $(i+1)}')

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

getPasswordValidator()
{
	validator=$(/bin/cat<<EOF
{
    var password = arguments[0];
    return -1 !== password.search("(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[^A-Za-z0-9])(?=.{10,})");
}
EOF
)
	echo "$validator" | quote_json
}

PAGE_POSTGRESQL=$(/bin/cat<<EOF
{
    "step_title": "{{POSTGRESQL_TITLE}}",
    "invalid_next_disabled_v2": true,
    "items": [{
        "type": "textfield",
        "desc": "{{POSTGRESQL_USERNAME_DESC}}",
        "subitems": [{
            "key": "wizard_pg_username_admin",
            "desc": "{{POSTGRESQL_USERNAME_LABEL}}",
            "defaultValue": "pgadmin"
        }]
    }, {
        "type": "password",
        "desc": "{{POSTGRESQL_PASSWORD_DESC}}",
        "subitems": [{
            "key": "wizard_pg_password_admin",
            "desc": "{{POSTGRESQL_PASSWORD_LABEL}}",
            "validator": {
                "allowBlank": false
            }
        }]
    }, {
        "type": "textfield",
        "desc": "{{POSTGRESQL_PORT_DESC}}",
        "subitems": [{
            "key": "wizard_pg_port",
            "desc": "{{POSTGRESQL_PORT_LABEL}}",
            "defaultValue": "5433"
        }]
    }]
}
EOF
)

PAGE_TTRSS=$(/bin/cat<<EOF
{
    "step_title": "{{TTRSS_TITLE}}",
    "invalid_next_disabled_v2": true,
    "items": [{
        "type": "password",
        "desc": "{{TTRSS_PASSWORD_DESC}}",
        "subitems": [{
            "key": "wizard_pg_password_ttrss",
            "desc": "{{TTRSS_PASSWORD_LABEL}}",
            "invalidText": "{{TTRSS_PASSWORD_INVALID}}",
            "validator": {
                "fn": "$(getPasswordValidator)"
            }
        }]
    }, {
        "type": "textfield",
        "desc": "{{TTRSS_DOMAIN_DESC}}",
        "subitems": [{
            "key": "wizard_domain_name",
            "desc": "{{TTRSS_DOMAIN_LABEL}}",
            "defaultValue": "${INTERNAL_IP}",
            "validator": {
                "allowBlank": false
            }
        }]
    }, {
        "type": "multiselect",
        "desc": "{{TTRSS_SINGLE_USER_DESC}}",
        "subitems": [{
            "key": "wizard_single_user",
            "desc": "{{TTRSS_SINGLE_USER_LABEL}}"
        }]
    }]
}
EOF
)

main ()
{
	local install_page=""
	install_page=$(page_append "$install_page" "$PAGE_POSTGRESQL")
	install_page=$(page_append "$install_page" "$PAGE_TTRSS")
	echo "[$install_page]" > "${SYNOPKG_TEMP_LOGFILE}"
}

main "$@"
