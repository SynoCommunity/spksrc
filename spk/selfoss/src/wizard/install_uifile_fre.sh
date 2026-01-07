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

# Check for multiple PHP profiles
check_php_profiles ()
{
	PHP_CFG_PATH="/usr/syno/etc/packages/WebStation/PHPSettings.json"
	if [ "${SYNOPKG_DSM_VERSION_MAJOR}" -lt 7 ] && \
		jq -e 'to_entries | map(select((.key | startswith("com-synocommunity-packages-")) and .key != "com-synocommunity-packages-selfoss")) | length > 0' "${PHP_CFG_PATH}" >/dev/null; then
		return 0  # true
	else
		return 1  # false
	fi
}

PAGE_PHP_PROFILES=$(/bin/cat<<EOF
{
	"step_title": "Plusieurs profils PHP",
	"items": [{
		"desc": "Attention : Plusieurs profils PHP détectés ; la page Web du package ne s'affichera pas tant qu'un redémarrage de DSM n'aura pas été effectué pour charger de nouvelles configurations."
	}]
}
EOF
)

main () {
	local install_page=""
	if check_php_profiles; then
		install_page=$(page_append "$install_page" "$PAGE_PHP_PROFILES")
	fi
	echo "[$install_page]" > "${SYNOPKG_TEMP_LOGFILE}"
}

main "$@"
