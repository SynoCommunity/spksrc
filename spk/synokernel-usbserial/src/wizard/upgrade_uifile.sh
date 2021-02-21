#!/bin/sh
set +x

CFG_FILE="/usr/local/${SYNOPKG_PKGNAME}/etc/${SYNOPKG_PKGNAME}.ini"
. ${CFG_FILE}

FIRST=`/bin/cat<<EOF
{
    "step_title": "SynoKernel USB Serial kernel module configuration",
    "items": [{
        "type": "multiselect",
        "subitems": [{
            "key": "default",
            "desc": "USB Serial (usbserial.ko)",
            "disabled": true,
            "defaultValue": true
        },
        {
            "key": "ch341",
            "desc": "Winchiphead CH341 USB-RS232 Converter (ch341.ko)",
            "defaultValue": $ch341
        },
        {
            "key": "cdc_acm",
            "desc": "CDC-ACM - Communication Device Class Abstract Control Model (cdc-acm.ko)",
            "defaultValue": $cdc_acm
        },
        {
            "key": "cp210x",
            "desc": "Silicon Laboratories CP210x USB to RS232 Serial Adaptor (cp210x.ko)",
            "defaultValue": $cp210x
        },
        {
            "key": "ftdi_sio",
            "desc": "FTDI Single Port DB-25 Serial Adaptor (ftdi_sio.ko)",
            "defaultValue": $ftdi_sio
        },
        {
            "key": "pl2303",
            "desc": "Prolific PL2303 USB to Serial Converter (pl2303.ko)",
            "defaultValue": $pl2303
        },
        {
            "key": "ti_usb_3410_5052",
            "desc": "TI 3410-5052 USB Serial (ti_usb_3410_5052.ko)",
            "defaultValue": $ti_usb_3410_5052
        }]
    }]
}

EOF`

echo "[$FIRST]" > $SYNOPKG_TEMP_LOGFILE

exit 0
