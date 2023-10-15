#!/bin/bash

WEB_DIR="/var/services/web_packages"
# for backwards compatability
if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ]; then
	WEB_DIR="/var/services/web"
fi
if [ -z ${SYNOPKG_PKGDEST_VOL} ]; then
	SYNOPKG_PKGDEST_VOL="/volume1"
fi
OCROOT="${WEB_DIR}/${SYNOPKG_PKGNAME}"
SHAREDIR="${SYNOPKG_PKGNAME}"
DIR_VALID="/^[\\w _-]+$/"

quote_json () {
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

PAGE_ADMIN_CONFIG=$(/bin/cat<<EOF
{
	"step_title": "{{{OWNCLOUD_ADMIN_CONFIGURATION_STEP_TITLE}}}",
	"invalid_next_disabled_v2": true,
	"items": [{
		"type": "textfield",
		"desc": "{{{OWNCLOUD_ADMIN_USER_NAME_DESCRIPTION}}}",
		"subitems": [{
			"key": "wizard_owncloud_admin_username",
			"desc": "{{{OWNCLOUD_ADMIN_USER_NAME_LABEL}}}",
			"defaultValue": "admin",
			"validator": {
				"allowBlank": false
			}
		}]
	}, {
		"type": "password",
		"desc": "{{{OWNCLOUD_ADMIN_PASSWORD_DESCRIPTION}}}",
		"subitems": [{
			"key": "wizard_owncloud_admin_password",
			"desc": "{{{OWNCLOUD_ADMIN_PASSWORD_LABEL}}}",
			"defaultValue": "admin",
			"validator": {
				"allowBlank": false
			}
		}]
	}, {
		"type": "textfield",
		"desc": "{{{OWNCLOUD_DATA_DIRECTORY_DESCRIPTION}}}",
		"subitems": [{
			"key": "wizard_data_share",
			"desc": "{{{OWNCLOUD_DATA_DIRECTORY_LABEL}}}",
			"defaultValue": "${SHAREDIR}",
			"validator": {
				"allowBlank": false,
				"regex": {
					"expr": "$(echo ${DIR_VALID} | quote_json)",
					"errorText": "{{{OWNCLOUD_DATA_DIRECTORY_VALIDATION_ERROR_TEXT}}}"
				}
			}
		}]
	}]
}, {
	"step_title": "{{{OWNCLOUD_TRUSTED_DOMAINS_STEP_TITLE}}}",
	"items": [{
		"type": "textfield",
		"desc": "{{{OWNCLOUD_TRUSTED_DOMAINS_DESCRIPTION}}}",
		"subitems": [{
			"key": "wizard_owncloud_trusted_domain_1",
			"desc": "{{{OWNCLOUD_TRUSTED_DOMAIN_1_LABEL}}}",
			"emptyText": "localhost"
		}, {
			"key": "wizard_owncloud_trusted_domain_2",
			"desc": "{{{OWNCLOUD_TRUSTED_DOMAIN_2_LABEL}}}",
			"emptyText": "server1.example.com"
		}, {
			"key": "wizard_owncloud_trusted_domain_3",
			"desc": "{{{OWNCLOUD_TRUSTED_DOMAIN_3_LABEL}}}",
			"emptyText": "192.168.1.50"
		}]
	}]
}
EOF
)

main () {
	local install_page=""
	install_page=$(page_append "$install_page" "$PAGE_ADMIN_CONFIG")
	echo "[$install_page]" > "${SYNOPKG_TEMP_LOGFILE}"
}

main "$@"
