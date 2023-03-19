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
	"step_title": "ownCloud admin configuration",
	"invalid_next_disabled_v2": true,
	"items": [{
		"type": "textfield",
		"desc": "Administrator's login. Defaults to 'admin'",
		"subitems": [{
			"key": "wizard_owncloud_admin_username",
			"desc": "User name",
			"defaultValue": "admin",
			"validator": {
				"allowBlank": false
			}
		}]
	}, {
		"type": "password",
		"desc": "Administrator's password. Defaults to 'admin'",
		"subitems": [{
			"key": "wizard_owncloud_admin_password",
			"desc": "Password",
			"defaultValue": "admin",
			"validator": {
				"allowBlank": false
			}
		}]
	}, {
		"type": "textfield",
		"desc": "ownCloud data directory",
		"subitems": [{
			"key": "wizard_data_share",
			"desc": "Share name",
			"defaultValue": "${SHAREDIR}",
			"validator": {
				"allowBlank": false,
				"regex": {
					"expr": "$(echo ${DIR_VALID} | quote_json)",
					"errorText": "Subdirectories are not supported."
				}
			}
		}, {
			"key": "wizard_volume",
			"desc": "Dummy value for DSM6 compatibility, to be fixed by PR #5649",
			"hidden": true,
			"defaultValue": "/volume1"
		}]
	}]
}, {
	"step_title": "ownCloud trusted domains",
	"items": [{
		"type": "textfield",
		"desc": "To access your ownCloud server, you must whitelist all URLs in your settings, including any additional URLs you want to use besides the current hostname.",
		"subitems": [{
			"key": "wizard_owncloud_trusted_domain_1",
			"desc": "Domain or IP address",
			"emptyText": "localhost"
		}, {
			"key": "wizard_owncloud_trusted_domain_2",
			"desc": "Domain or IP address",
			"emptyText": "server1.example.com"
		}, {
			"key": "wizard_owncloud_trusted_domain_3",
			"desc": "Domain or IP address",
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
