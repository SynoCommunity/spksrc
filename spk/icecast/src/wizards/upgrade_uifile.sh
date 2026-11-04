#!/bin/sh

CONFIG_FILE=""
for candidate in \
    /var/packages/icecast/var/icecast.xml \
    /var/packages/icecast/target/var/icecast.xml
do
    if [ -f "${candidate}" ]; then
        CONFIG_FILE="${candidate}"
        break
    fi
done

[ -n "${CONFIG_FILE}" ] || exit 0

get_value ()
{
    sed -n "s:.*<$1>\\(.*\\)</$1>.*:\\1:p" "${CONFIG_FILE}" | head -1
}

HOSTNAME_VALUE=$(get_value hostname)
LOCATION_VALUE=$(get_value location)
ADMIN_VALUE=$(get_value admin)

ITEMS=""
add_item ()
{
    [ -n "${ITEMS}" ] && ITEMS="${ITEMS},"
    ITEMS="${ITEMS}$1"
}

if [ -z "${HOSTNAME_VALUE}" ] || [ "${HOSTNAME_VALUE}" = "localhost" ] || [ "${HOSTNAME_VALUE}" = "@hostname@" ]; then
    add_item '{"type":"textfield","desc":"Public hostname clients use to reach this server. A fully qualified domain name is preferred.","subitems":[{"key":"wizard_ic_hostname","desc":"Hostname","defaultValue":""}]}'
fi

if [ -z "${LOCATION_VALUE}" ] || [ "${LOCATION_VALUE}" = "Earth" ] || [ "${LOCATION_VALUE}" = "@location@" ]; then
    add_item '{"type":"textfield","desc":"Location shown in the server information.","subitems":[{"key":"wizard_ic_location","desc":"Location","defaultValue":""}]}'
fi

if [ -z "${ADMIN_VALUE}" ] || [ "${ADMIN_VALUE}" = "icemaster@localhost" ] || [ "${ADMIN_VALUE}" = "@admin@" ]; then
    add_item '{"type":"textfield","desc":"Administrator contact email for directory listings.","subitems":[{"key":"wizard_ic_admin","desc":"Admin email","defaultValue":""}]}'
fi

[ -n "${ITEMS}" ] || exit 0

cat <<EOJSON > "${SYNOPKG_TEMP_LOGFILE}"
[{
    "step_title": "Icecast server settings",
    "items": [{
        "desc": "Update the unconfigured server details. Leave a field blank to keep its current value."
    }, ${ITEMS}
    ]
  }
]
EOJSON

exit 0
