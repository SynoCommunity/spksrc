
# The profile of the network of the installation wizard, if one is given
service_postinst ()
{
    [ -n "${wizard_wifi_ssid}" ] || return 0

    security=wpa2
    [ "${wizard_wifi_wpa3}" = "true" ] && security=wpa3
    [ "${wizard_wifi_open}" = "true" ] && security=open
    psk=
    if [ "${security}" != "open" ]; then
        psk=$(${SYNOPKG_PKGDEST}/sbin/wpa_passphrase "${wizard_wifi_ssid}" "${wizard_wifi_passphrase}" | sed -n 's/^\tpsk=//p')
        if [ -z "${psk}" ]; then
            echo "No profile for ${wizard_wifi_ssid}: a passphrase has 8 to 63 characters"
            return 0
        fi
    fi
    dhcp=yes
    [ "${wizard_wifi_static}" = "true" ] && dhcp=no
    route=no
    [ "${wizard_wifi_default_route}" = "true" ] && route=yes

    ${SYNOPKG_PKGDEST}/bin/synocli-wifi --write-profile "${wizard_wifi_ssid}" "${security}" "${psk}" \
        "${wizard_wifi_passphrase}" "${dhcp}" "${wizard_wifi_address}" "${wizard_wifi_gateway}" \
        "${wizard_wifi_dns}" "${route}" "${wizard_wifi_country}"
}
