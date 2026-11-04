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

NEED_HOSTNAME=false
case "${HOSTNAME_VALUE}" in
    ""|localhost|@hostname@) NEED_HOSTNAME=true ;;
esac

NEED_LOCATION=false
case "${LOCATION_VALUE}" in
    ""|Earth|@location@) NEED_LOCATION=true ;;
esac

NEED_ADMIN=false
case "${ADMIN_VALUE}" in
    ""|icemaster@localhost|@admin@) NEED_ADMIN=true ;;
esac

if [ "${NEED_HOSTNAME}" = false ] && [ "${NEED_LOCATION}" = false ] && [ "${NEED_ADMIN}" = false ]; then
    exit 0
fi

{
    cat <<'EOJSON'
[{
    "step_title": "Icecast server settings",
    "items": [{
        "desc": "Update the unconfigured server details. Leave a field blank to keep its current value."
    }
EOJSON

    if [ "${NEED_HOSTNAME}" = true ]; then
        cat <<'EOJSON'
, {
        "type": "textfield",
        "desc": "Public hostname clients use to reach this server. A fully qualified domain name is preferred.",
        "subitems": [{
            "key": "wizard_ic_hostname",
            "desc": "Hostname",
            "defaultValue": ""
        }]
    }
EOJSON
    fi

    if [ "${NEED_LOCATION}" = true ]; then
        cat <<'EOJSON'
, {
        "type": "textfield",
        "desc": "Location shown in the server information.",
        "subitems": [{
            "key": "wizard_ic_location",
            "desc": "Location",
            "defaultValue": ""
        }]
    }
EOJSON
    fi

    if [ "${NEED_ADMIN}" = true ]; then
        cat <<'EOJSON'
, {
        "type": "textfield",
        "desc": "Administrator contact email for directory listings.",
        "subitems": [{
            "key": "wizard_ic_admin",
            "desc": "Admin email",
            "defaultValue": ""
        }]
    }
EOJSON
    fi

    cat <<'EOJSON'
    ]
  }
]
EOJSON
} > "${SYNOPKG_TEMP_LOGFILE}"

exit 0
