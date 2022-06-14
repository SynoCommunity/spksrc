#!/bin/sh

OLD_SPK_REV="${SYNOPKG_OLD_PKGVER##*-}"

# display this wizard page only for updates from mosquitto < 2.x
if [ -n ${OLD_SPK_REV} ] && [ ${OLD_SPK_REV} -lt 13 ]; then

cat <<EOF > $SYNOPKG_TEMP_LOGFILE
[{
    "step_title": "Update Configuration from ${SYNOPKG_OLD_PKGVER}",
    "items": [{
        "desc": "The configuration file for Mosquitto v2 will be installed as <code>/var/packages/mosquitto/var/mosquitto.conf.new</code>."
      }, {
        "desc": "After the package is updated, please make a copy of your current <code>mosquitto.conf</code> file and use the new configuration file as a template, apply your custom settings and save it as <code>mosquitto.conf</code>. Finally restart mosquitto to apply the updated configuration."
      }, {
        "desc": "<b>Note:</b> The new default configuration is for anonymous access and restricted to localhost (127.0.0.1)."
      }
    ]
  }
]
EOF

fi
exit 0
