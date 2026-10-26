#!/bin/bash

OC_NEW_VER=$(echo "${SYNOPKG_PKGVER}" | cut -d '-' -f 1)
OC_OLD_VER=$(echo "${SYNOPKG_OLD_PKGVER}" | cut -d '-' -f 1)

WEB_ROOT="/var/services/web_packages/${SYNOPKG_PKGNAME}"

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

version_number ()
{
	echo "$1" | awk -F. '{ printf "%d%03d%03d\n", $1, $2, $3 }'
}

version_greater_equal ()
{
	[ "$(version_number "$1")" -ge "$(version_number "$2")" ]
}

version_less_equal ()
{
	[ "$(version_number "$1")" -le "$(version_number "$2")" ]
}

is_upgrade_possible ()
{
	# Mirrors ownCloud's version.php OC_VersionCanBeUpgradedFrom
	# [[8,2,11],[9,0,9],[9,1]] and Updater::isUpgradePossible():
	# the previous version must be >= one of the allowed entries and <= the new one.
	previous=${OC_OLD_VER}
	new=${OC_NEW_VER}
	version_less_equal "${previous}" "${new}" || return 1
	if echo "${previous}" | grep -q '^8\.2\.' && version_greater_equal "${previous}" "8.2.11"; then
		return 0
	fi
	if echo "${previous}" | grep -q '^9\.0\.' && version_greater_equal "${previous}" "9.0.9"; then
		return 0
	fi
	version_greater_equal "${previous}" "9.1" && return 0
	return 1
}

is_database_mysql ()
{
	config_file="${WEB_ROOT}/config/config.php"
	if [ -f "$config_file" ] && grep -q "'dbtype' => 'mysql'" "$config_file"; then
		return 0
	else
		return 1
	fi
}

getUpgradeLimitations()
{
	echo "$TEXT_LIMITATIONS" | quote_json
}

PAGE_NO_UPDATE=$(/bin/cat<<EOF
{
	"step_title": "{{{OWNCLOUD_INCOMPATIBLE_UPGRADE_STEP_TITLE}}}",
	"invalid_next_disabled_v2": true,
	"items": [{
		"type": "textfield",
		"desc": "{{{OWNCLOUD_INCOMPATIBLE_UPGRADE_DESCRIPTION}}}",
		"subitems": [{
			"hidden": true,
			"validator": {
				"fn": "{return false;}"
			}
		}]
	}]
}
EOF
)

PAGE_MIGRATE_DB=$(/bin/cat<<EOF
{
	"step_title": "{{{OWNCLOUD_MIGRATE_DATABASE_STEP_TITLE}}}",
	"invalid_next_disabled_v2": true,
	"items": [{
		"desc": "{{{OWNCLOUD_MIGRATE_DATABASE_DESCRIPTION}}}"
	}, {
		"type": "textfield",
		"desc": "{{{OWNCLOUD_MIGRATE_DATABASE_DETAILS}}}",
		"subitems": [{
			"hidden": true,
			"validator": {
				"fn": "{return false;}"
			}
		}]
	}]
}
EOF
)

TEXT_LIMITATIONS=$(/bin/cat<<EOF
<table>
	<tr>
		<td valign="top">1.</td>
		<td valign="top">{{{OWNCLOUD_UPGRADE_LIMITATION_1_TEXT}}}</td>
	</tr>
	<tr>
		<td valign="top">2.</td>
		<td valign="top">{{{OWNCLOUD_UPGRADE_LIMITATION_2_TEXT}}}</td>
	</tr>
	<tr>
		<td valign="top">3.</td>
		<td valign="top">{{{OWNCLOUD_UPGRADE_LIMITATION_3_TEXT}}}</td>
	</tr>
</table>
EOF
)

PAGE_LIMITATIONS=$(/bin/cat<<EOF
{
	"step_title": "{{{OWNCLOUD_UPGRADE_LIMITATIONS_STEP_TITLE}}}",
	"items": [{
		"desc": "{{{OWNCLOUD_UPGRADE_LIMITATIONS_DESCRIPTION}}}"
	}, {
		"desc": "$(getUpgradeLimitations)"
	}]
}
EOF
)

main ()
{
	local upgrade_page=""
	if ! is_upgrade_possible; then
		upgrade_page=$(page_append "$upgrade_page" "$PAGE_NO_UPDATE")
	elif ! is_database_mysql; then
		upgrade_page=$(page_append "$upgrade_page" "$PAGE_MIGRATE_DB")
	else
		upgrade_page=$(page_append "$upgrade_page" "$PAGE_LIMITATIONS")
	fi
	echo "[$upgrade_page]" > "${SYNOPKG_TEMP_LOGFILE}"
}

main "$@"
