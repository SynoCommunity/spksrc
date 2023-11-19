#!/bin/bash

OC_NEW_VER=$(echo ${SYNOPKG_PKGVER} | cut -d '-' -f 1)
OC_OLD_VER=$(echo ${SYNOPKG_OLD_PKGVER} | cut -d '-' -f 1)

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
