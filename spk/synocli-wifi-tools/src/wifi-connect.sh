#!/bin/bash

#########################################################################
# Part of SynoCommunity Developpers
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#########################################################################

# Connects the NAS to a WiFi network, by profile: one JSON file per network in
# var/networks of this package. Every connection starts from a clean state:
# the DHCP client and wpa_supplicant of the interface are stopped first.

PACKAGE=synocli-wifi-tools
TARGET=/var/packages/${PACKAGE}/target
NETWORKS_DIR=/var/packages/${PACKAGE}/var/networks
RUN_DIR=/var/run/${PACKAGE}
CTRL_DIR=/var/run/wpa_supplicant
SBIN=${TARGET}/sbin
UDHCPC_SCRIPT=${TARGET}/etc/udhcpc.script
LOG=/var/log/packages/wifi-connect.log

usage() {
   cat <<EOF

Usage: $(basename $0) [options] <list|new|start|stop|restart|status>

Run as root: sudo -i $(basename $0) ...

  list                 the profiles
  new                  ask for a network, and write its profile
  start                connect with the profile, from a clean interface
  stop                 disconnect: stop the DHCP client and wpa_supplicant
  restart              the same as start
  status               the state of the connection

Options:
  --profile <network>  the profile of the network, for start and restart
  -i <interface>       the WiFi interface, the first one of 'iw dev' otherwise

Example: sudo -i $(basename $0) --profile MyNetwork start

Profiles: ${NETWORKS_DIR}/<network>.json
Log: ${LOG}

EOF
   exit 1
}

die() {
   echo "ERROR: $*" >&2
   exit 1
}

log() {
   echo "$*"
   echo "$(date '+%Y-%m-%d %H:%M:%S') ${IFACE}: $*" >> ${LOG}
}

# A file name of the network name: what is not a letter, digit, dot, dash or
# underscore becomes an underscore
profile_file() {
   echo "${NETWORKS_DIR}/$(echo -n "$1" | tr -c 'A-Za-z0-9._-' '_').json"
}

find_profile() {
   local file
   file=$(profile_file "$1")
   [ -f "${file}" ] && { echo "${file}"; return; }
   # By the SSID it holds
   for file in ${NETWORKS_DIR}/*.json; do
      [ -f "${file}" ] || continue
      [ "$(jq -r '.ssid' "${file}")" = "$1" ] && { echo "${file}"; return; }
   done
}

list_profiles() {
   local file
   printf '%-24s %-10s %s\n' "PROFILE" "SECURITY" "ADDRESS"
   for file in ${NETWORKS_DIR}/*.json; do
      [ -f "${file}" ] || continue
      printf '%-24s %-10s %s\n' "$(basename "${file}" .json)" \
         "$(jq -r '.security // "wpa2"' "${file}")" \
         "$(jq -r 'if .dhcp != false then "dhcp" else .address end + (if .default_route then ", default route" else "" end)' "${file}")"
   done
}

# The configuration of wpa_supplicant, from a profile
wpa_config() {
   local file=$1 ssid security psk sae
   ssid=$(jq -r '.ssid' "${file}")
   security=$(jq -r '.security // "wpa2"' "${file}")
   psk=$(jq -r '.psk // empty' "${file}")
   sae=$(jq -r '.sae_password // empty' "${file}")
   echo "network={"
   echo "	ssid=\"${ssid}\""
   case "${security}" in
      open) echo "	key_mgmt=NONE" ;;
      # WPA3, and the transition mode that also offers WPA2
      wpa3) echo "	key_mgmt=SAE WPA-PSK"
            echo "	ieee80211w=1"
            echo "	sae_password=\"${sae}\""
            echo "	psk=${psk}" ;;
      *)    echo "	psk=${psk}" ;;
   esac
   echo "}"
}

wifi_stop() {
   local saved
   if [ -f ${RUN_DIR}/udhcpc-${IFACE}.pid ]; then
      # -R: the lease is released and the address removed
      kill $(cat ${RUN_DIR}/udhcpc-${IFACE}.pid) 2>/dev/null
      sleep 1
   fi
   ${SBIN}/wpa_cli -p ${CTRL_DIR} -i ${IFACE} terminate >/dev/null 2>&1
   # Those started otherwise, without PID file nor control interface: by their
   # command line, where pkill does not find this script
   pkill -f "udhcpc .*-i ${IFACE}( |$)" 2>/dev/null
   pkill -f "wpa_supplicant .*-i ${IFACE}( |$)" 2>/dev/null
   ip addr flush dev ${IFACE} 2>/dev/null
   # The default route and DNS servers the network replaced
   saved=${RUN_DIR}/${IFACE}.route
   if [ -f ${saved} ]; then
      ip route | grep -q '^default' || ip route add $(cat ${saved}) 2>/dev/null
      rm -f ${saved}
   fi
   if [ -f ${RUN_DIR}/${IFACE}.resolv.conf ]; then
      cat ${RUN_DIR}/${IFACE}.resolv.conf > /etc/resolv.conf
      rm -f ${RUN_DIR}/${IFACE}.resolv.conf
   fi
   rm -f ${RUN_DIR}/${IFACE}.profile
}

wifi_start() {
   local file=$1 dhcp address gateway route dns country d n
   dhcp=$(jq -r '.dhcp != false' "${file}")
   route=$(jq -r '.default_route // false' "${file}")

   # The regulatory domain, without which most 5 GHz channels stay closed
   country=$(jq -r '.country // empty' "${file}")
   [ -n "${country}" ] && ${SBIN}/iw reg set ${country}
   ip link set ${IFACE} up || die "${IFACE} does not come up"
   # Read once on its standard input: the profile is the configuration
   wpa_config "${file}" | ${SBIN}/wpa_supplicant -B -D nl80211 -i ${IFACE} -C ${CTRL_DIR} -c /dev/stdin >> ${LOG} 2>&1 \
      || die "wpa_supplicant does not start, see ${LOG}"
   echo "${file}" > ${RUN_DIR}/${IFACE}.profile

   n=0
   while [ ${n} -lt 30 ]; do
      ${SBIN}/wpa_cli -p ${CTRL_DIR} -i ${IFACE} status 2>/dev/null | grep -q '^wpa_state=COMPLETED' && break
      sleep 1; n=$((n+1))
   done
   [ ${n} -lt 30 ] || die "no association with $(jq -r '.ssid' "${file}") after 30 s: wrong passphrase, or out of range?"
   log "associated with $(jq -r '.ssid' "${file}")"

   if [ "${route}" = "true" ]; then
      ip route | grep '^default' | head -1 > ${RUN_DIR}/${IFACE}.route
      [ -s ${RUN_DIR}/${IFACE}.route ] || rm -f ${RUN_DIR}/${IFACE}.route
      cp /etc/resolv.conf ${RUN_DIR}/${IFACE}.resolv.conf
   fi

   if [ "${dhcp}" = "true" ]; then
      [ "${route}" = "true" ] && export WIFI_DEFAULT_ROUTE=1
      ${SBIN}/udhcpc -i ${IFACE} -s ${UDHCPC_SCRIPT} -b -R -p ${RUN_DIR}/udhcpc-${IFACE}.pid >> ${LOG} 2>&1
      n=0
      while [ ${n} -lt 20 ] && ! ip addr show ${IFACE} | grep -q 'inet '; do
         sleep 1; n=$((n+1))
      done
   else
      address=$(jq -r '.address // empty' "${file}")
      gateway=$(jq -r '.gateway // empty' "${file}")
      [ -n "${address}" ] || die "no address in ${file}"
      ip addr flush dev ${IFACE}
      ip addr add ${address} dev ${IFACE}
      if [ "${route}" = "true" ]; then
         [ -n "${gateway}" ] && ip route replace default via ${gateway} dev ${IFACE}
         dns=$(jq -r '(.dns // []) | join(" ")' "${file}")
         if [ -n "${dns}" ]; then
            for d in ${dns}; do echo "nameserver ${d}"; done > /etc/resolv.conf
         fi
      fi
   fi
   address=$(ip addr show ${IFACE} | sed -n 's/.*inet \([0-9./]*\).*/\1/p' | head -1)
   [ -n "${address}" ] || die "associated, but no address on ${IFACE}"
   log "connected, ${address}$([ "${route}" = "true" ] && echo ", default route")"
}

wifi_status() {
   local profile state
   [ -f ${RUN_DIR}/${IFACE}.profile ] && profile=$(basename "$(cat ${RUN_DIR}/${IFACE}.profile)" .json)
   echo "Interface: ${IFACE}"
   echo "Profile:   ${profile:-none}"
   state=$(${SBIN}/wpa_cli -p ${CTRL_DIR} -i ${IFACE} status 2>/dev/null | grep -E '^(ssid|wpa_state|key_mgmt|freq)=')
   echo "${state:-wpa_supplicant does not run}" | sed 's/^/           /'
   ip addr show ${IFACE} | sed -n 's/.*inet \([0-9./]*\).*/Address:   \1/p'
   ip route | sed -n 's/^default/Route:     default/p'
}

ask() {
   local answer
   read -r -p "$1${2:+ [$2]}: " answer
   echo "${answer:-$2}"
}

wifi_new() {
   local ssid security pass pass2 psk dhcp address gateway dns route country networks n
   echo "A new network profile, in ${NETWORKS_DIR}"
   echo
   echo "Networks in range:"
   ip link set ${IFACE} up 2>/dev/null
   # A scan is refused while the driver is busy: a few tries
   for n in 1 2 3; do
      networks=$(${SBIN}/iw dev ${IFACE} scan 2>/dev/null | sed -n 's/^\tSSID: \(..*\)/  \1/p' | sort -u)
      [ -n "${networks}" ] && break
      sleep 2
   done
   echo "${networks:-  none found}"
   echo
   ssid=$(ask "Network (SSID)")
   [ -n "${ssid}" ] || die "no network"
   security=$(ask "Security: wpa2, wpa3 (WPA3 or WPA2/WPA3) or open" wpa2)
   case "${security}" in
      wpa2|wpa3|open) ;;
      *) die "unknown security: ${security}" ;;
   esac
   if [ "${security}" != "open" ]; then
      read -r -s -p "Passphrase: " pass; echo
      read -r -s -p "Passphrase, again: " pass2; echo
      [ "${pass}" = "${pass2}" ] || die "the passphrases differ"
      psk=$(${SBIN}/wpa_passphrase "${ssid}" "${pass}" | sed -n 's/^\tpsk=//p')
      [ -n "${psk}" ] || die "a passphrase has 8 to 63 characters"
   fi
   dhcp=$(ask "Address by DHCP (yes/no)" yes)
   if [ "${dhcp}" != "yes" ]; then
      address=$(ask "Address, with its mask (192.168.1.50/24)")
      [ -n "${address}" ] || die "no address"
      gateway=$(ask "Gateway (empty for none)")
      dns=$(ask "DNS servers, separated by spaces (empty for none)")
   fi
   route=$(ask "Default route and DNS through the WiFi, for a NAS on WiFi alone (yes/no)" no)
   country=$(ask "Country, two letters as CA or FR, for the 5 GHz channels (empty to skip)")
   write_profile "${ssid}" "${security}" "${psk}" "${pass}" "${dhcp}" "${address}" "${gateway}" "${dns}" "${route}" "${country}"
}

# ssid security psk passphrase dhcp(yes/no) address gateway dns route(yes/no) country
write_profile() {
   local file
   file=$(profile_file "$1")
   mkdir -p ${NETWORKS_DIR}
   ( umask 077
     jq -n --arg ssid "$1" --arg security "$2" --arg psk "$3" --arg sae "$4" \
           --arg dhcp "$5" --arg address "$6" --arg gateway "$7" --arg dns "$8" --arg route "$9" --arg country "${10}" '
        {ssid: $ssid, security: $security}
        + (if $security == "open" then {} else {psk: $psk} end)
        # SAE hashes with the passphrase itself: WPA3 keeps it
        + (if $security == "wpa3" then {sae_password: $sae} else {} end)
        + {dhcp: ($dhcp != "no")}
        + (if $dhcp == "no" then {address: $address, gateway: $gateway, dns: ($dns | split(" ") | map(select(. != "")))} else {} end)
        + {default_route: ($route == "yes")}
        + (if $country == "" then {} else {country: ($country | ascii_upcase)} end)' > "${file}" ) || die "cannot write ${file}"
   echo "Profile written: ${file}"
   echo "Connect with: sudo -i $(basename $0) --profile $(basename "${file}" .json) start"
}

#
# Main
#
IFACE=
NETWORK=
ACTION=
while [ $# -gt 0 ]; do
   case "$1" in
      -i)              IFACE=$2; shift 2 ;;
      --profile)       NETWORK=$2; shift 2 ;;
      # The profile of the installation wizard, written as the package user
      --write-profile) shift; ACTION=write-profile; break ;;
      -*)              usage ;;
      *)               [ -z "${ACTION}" ] || usage; ACTION=$1; shift ;;
   esac
done
[ -n "${ACTION}" ] || usage
command -v jq >/dev/null || die "jq is needed to read the profiles"

if [ "${ACTION}" = "write-profile" ]; then
   write_profile "$@"; exit 0
fi
[ "$(id -u)" = "0" ] || die "run as root: sudo -i $(basename $0) ..."
if [ "${ACTION}" = "list" ]; then
   list_profiles
   exit 0
fi
mkdir -p ${RUN_DIR}
if [ -z "${IFACE}" ]; then
   IFACE=$(${SBIN}/iw dev 2>/dev/null | sed -n 's/^\s*Interface \(.*\)/\1/p' | head -1)
   [ -n "${IFACE}" ] || die "no WiFi interface: load the driver of the adapter first (synocli-kernelmodule)"
fi

case "${ACTION}" in
   stop)    wifi_stop; log "stopped" ;;
   status)  wifi_status ;;
   new)     wifi_new ;;
   start|restart)
      [ -n "${NETWORK}" ] || die "which network: --profile <network>, see sudo -i $(basename $0) list"
      PROFILE=$(find_profile "${NETWORK}")
      [ -n "${PROFILE}" ] || die "no profile for ${NETWORK}: sudo -i $(basename $0) list, or new"
      # Resetting the interface cuts the connections to its address, maybe the
      # session running this: go on detached then, with the output in the log
      address=$(ip addr show ${IFACE} | sed -n 's/.*inet \([0-9.]*\).*/\1/p' | head -1)
      if [ -z "${WIFI_CONNECT_DETACHED}" ] && [ -n "${address}" ] \
         && netstat -tn 2>/dev/null | awk '$6 == "ESTABLISHED" { print $4 }' | grep -q "^${address}:"; then
         echo "Connections go through ${IFACE}, and may be cut: going on in the background, see ${LOG}"
         WIFI_CONNECT_DETACHED=1 nohup $0 -i ${IFACE} --profile "${NETWORK}" start >> ${LOG} 2>&1 &
         exit 0
      fi
      wifi_stop
      wifi_start "${PROFILE}"
      ;;
   *)       usage ;;
esac
