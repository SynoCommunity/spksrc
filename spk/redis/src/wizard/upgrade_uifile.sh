#!/bin/sh

OLD_SPK_REV="${SYNOPKG_OLD_PKGVER##*-}"

# display this wizard page only for updates from redis < 7.x
if [ -n ${OLD_SPK_REV} ] && [ ${OLD_SPK_REV} -lt 11 ]; then

cat <<EOF > $SYNOPKG_TEMP_LOGFILE
[{
    "step_title": "Update Configuration from ${SYNOPKG_OLD_PKGVER}",
    "items": [{
        "desc": "The configuration file for Redis v7.x will be installed as <code>/var/packages/redis/var/redis.conf.new</code>."
      }, {
        "desc": "After the package is updated, please make a copy of your current <code>redis.conf</code> file and use the new configuration file as a template, apply your custom settings and save it as <code>redis.conf</code>. When you use Redis Sentinel, do likewise with <code>sentinel.conf</code>. Finally restart redis to apply the updated configuration."
      }, {
        "desc": "<b>Note:</b> Check <code>/var/packages/redis/var/redis.log</code> to find configuration issues."
      }
    ]
  }
]
EOF

fi
exit 0
