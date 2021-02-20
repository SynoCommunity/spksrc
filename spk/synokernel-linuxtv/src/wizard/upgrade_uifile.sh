#!/bin/sh
set +x

CFG_FILE="/usr/local/${SYNOPKG_PKGNAME}/etc/synokernel-linuxtv.ini"
. ${CFG_FILE}

FIRST=`/bin/cat<<EOF
{
    "step_title": "SynoKernel USB Serial kernel module configuration",
    "items": [{
        "type": "multiselect",
        "subitems": [{
            "key": "default",
            "desc": V4L2-core (mc.ko, videodev.ko, tveeprom.ko, videobuf2-*.ko, dvb-core.ko)",
            "disabled": true,
            "defaultValue": true
        },
        {
            "key": "HAUPPAUGE_WINTV_DUALHD",
            "desc": "Hauppauge WinTV Dual-HD (si2157.ko, lgdt3306a.ko, em28xx.ko, em28xx-dvb.ko)",
            "defaultValue": false
        },
        {
            "key": "MYGICA_T230A",
            "desc": "Mygica T230A (si2157.ko, si2168.ko, dvb_usb_v2.ko)",
            "defaultValue": false
        }]
    }]
}

EOF`

echo "[$FIRST]" > $SYNOPKG_TEMP_LOGFILE

exit 0
