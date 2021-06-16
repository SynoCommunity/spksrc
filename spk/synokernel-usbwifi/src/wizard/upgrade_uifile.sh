#!/bin/sh
set +x

CFG_FILE="/usr/local/${SYNOPKG_PKGNAME}/etc/${SYNOPKG_PKGNAME}.ini"
. ${CFG_FILE}

# Ensure to add any new entries in the $OPTIONS
# variable below so it always get a value
# even though it didn't exist previously in the
# .ini configuration file
OPTIONS=( AT76C50X MT7601U RT2570 RT73 RT2800 RTL88XXAU RTL8814AU ZD1201 )

for option in "${OPTIONS[@]}"; do
   var=${option%%=*}
   [ -z "${!var}" ] \
      && eval ${var}=false
done

FIRST=`/bin/cat<<EOF
{
    "step_title": "SynoKernel USB WI-FI kernel module configuration",
    "items": [{
        "type": "multiselect",
        "subitems": [{
            "key": "default",
            "desc": "USB WI-FI (cfg80211.ko, mac80211.ko)",
            "disabled": true,
            "defaultValue": true
        },
        {
            "key": "AT76C50X",
            "desc": "Atmel AT76c503/AT76c505/AT76c505a USB",
            "defaultValue": $AT76C50X
        },
        {
            "key": "MT7601U",
            "desc": "MediaTek MT7601U USB",
            "defaultValue": $MT7601U
        },
        {
            "key": "RT2570",
            "desc": "Ralink RT2500 USB",
            "defaultValue": $RT2570
        },
        {
            "key": "RT73",
            "desc": "Ralink RT2501/RT73 USB",
            "defaultValue": $RT73
        },
        {
            "key": "RT2800",
            "desc": "Ralink RT27xx/RT28xx/RT30xx USB",
            "defaultValue": $RT2800
        },
        {
            "key": "RTL88XXAU",
            "desc": "RTL8812AU/21AU Wireless",
            "defaultValue": $RTL88XXAU
        },
        {
            "key": "RTL8814AU",
            "desc": "RTL8814AU Wireless",
            "defaultValue": $RTL8814AU
        },
        {
            "key": "ZD1201",
            "desc": "ZyDAS ZD1211/ZD1211B USB",
            "defaultValue": $ZD1201
        }]
    }]
}

EOF`

echo "[$FIRST]" > $SYNOPKG_TEMP_LOGFILE

exit 0
