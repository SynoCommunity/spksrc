#!/bin/sh

OLD_SPK_REV="${SYNOPKG_OLD_PKGVER##*-}"

# display this wizard page only for updates from mosquitto < 2.x
if [ -n ${OLD_SPK_REV} ] && [ ${OLD_SPK_REV} -lt 13 ]; then

cat <<EOF > $SYNOPKG_TEMP_LOGFILE
[{
    "step_title": "Update Configuration from ${SYNOPKG_OLD_PKGVER}",
    "items": [{
        "desc": "The configuration file for Mosquitto v2 will be installed as <strong>/var/packages/mosquitto/var/mosquitto.conf.new</strong>. Please make a copy of your current mosquitto.conf file and use the new configuration file as template, apply your custom settings and save it as mosquitto.conf."
      }, {
        "desc": "Note: the new default configuration is for anonymous access and restricted to localhost (127.0.0.1)."
      }
    ]
  }
]
EOF

fi
exit 0
