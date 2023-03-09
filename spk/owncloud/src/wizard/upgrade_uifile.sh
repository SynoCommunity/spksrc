#!/bin/bash

WEB_DIR="/var/services/web_packages"
# for backwards compatability
if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ]; then
	WEB_DIR="/var/services/web"
	if [ -z ${SYNOPKG_PKGNAME} ]; then
		SYNOPKG_PKGNAME="owncloud"
	fi
fi
OCROOT="${WEB_DIR}/${SYNOPKG_PKGNAME}"
OC_NEW_VER=$(echo ${SYNOPKG_PKGVER} | cut -d'-' -f1)
OC_OLD_VER=$(echo ${SYNOPKG_OLD_PKGVER} | cut -d'-' -f1)

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

is_upgrade_possible ()
{
	# ownCloud upgrades only possible from 8.2.11, 9.0.9, 9.1.X, or 10.X.Y
	valid_versions=("8.2.11" "9.0.9" "9.1.*" "10.*.*")
	previous=${OC_OLD_VER}
	for version in "${valid_versions[@]}"; do
		if echo "$previous" | grep -q "$version"; then
			return 0  # Success or true
		fi
	done
	return 1  # Failure or false
}

PAGE_NO_UPDATE=$(/bin/cat<<EOF
{
	"step_title": "Incompatible upgrade",
	"invalid_next_disabled_v2": true,
	"items": [{
		"type": "textfield",
		"desc": "<strong>NOTICE:</strong> Version ${OC_OLD_VER} of ownCloud cannot be updated to version ${OC_NEW_VER}. Please uninstall the previous version and remember to save your <code>${OCROOT}/data</code> files before doing so.",
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
		<td valign="top">Cron jobs cannot be managed during the upgrade process. We recommend that you disable them manually before upgrading.</td>
	</tr>
	<tr>
		<td valign="top">2.</td>
		<td valign="top">The web server cannot be managed during the upgrade process. While the upgrade is in progress, the web server will be placed in maintenance mode. We recommend stopping Web Station before upgrading.</td>
	</tr>
	<tr>
		<td valign="top">3.</td>
		<td valign="top">Compatibility of third-party apps cannot be automatically validated during the upgrade process. Please check app compatibility manually before upgrading as apps will be migrated.</td>
	</tr>
</table>
EOF
)

PAGE_LIMITATIONS=$(/bin/cat<<EOF
{
	"step_title": "Upgrade limitations",
	"items": [{
		"desc": "Please note the following limitations when upgrading the ownCloud package:"
	}, {
		"desc": "$(echo $TEXT_LIMITATIONS | quote_json)"
	}]
}
EOF
)

main ()
{
	local upgrade_page=""
	if is_upgrade_possible; then
		upgrade_page=$(page_append "$upgrade_page" "$PAGE_LIMITATIONS")
	else
		upgrade_page=$(page_append "$upgrade_page" "$PAGE_NO_UPDATE")
	fi
	echo "[$upgrade_page]" > "${SYNOPKG_TEMP_LOGFILE}"
}

main "$@"
