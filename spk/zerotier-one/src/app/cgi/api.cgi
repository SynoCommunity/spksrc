#!/bin/sh
# zerotier-one — management API for the DSM app.
#
#   GET  api.cgi?action=status              node status and joined networks
#   POST api.cgi?action=join&id=<16 hex>    join a network
#   POST api.cgi?action=leave&id=<16 hex>   leave a network (restarts zerotier-one)
#
# Only DSM administrators: the caller must be signed in to DSM (checked by
# DSM's own authenticate.cgi, which also needs the session's SynoToken, so a
# foreign page cannot call this) and belong to the "administrators" group.
# It talks to zerotier-one's local API on 127.0.0.1 with the daemon's token.

HOME_DIR="/var/packages/zerotier-one/var"

reply() {
    printf 'Status: %s\r\nContent-Type: application/json; charset=utf-8\r\nCache-Control: no-store\r\nX-Content-Type-Options: nosniff\r\n\r\n%s\n' "$1" "$2"
    exit 0
}

user=$(/usr/syno/synoman/webman/modules/authenticate.cgi 2>/dev/null)
[ -n "${user}" ] || reply "401 Unauthorized" '{"error":"not-authenticated"}'
case " $(id -Gn "${user}" 2>/dev/null) " in
    *" administrators "*) ;;
    *) reply "403 Forbidden" '{"error":"admin-only"}' ;;
esac

param() {
    printf '%s' "${QUERY_STRING}" | tr '&' '\n' | sed -n "s/^$1=//p" | head -n 1
}
action=$(param action)
network_id=$(param id | tr 'A-F' 'a-f')

token=$(cat "${HOME_DIR}/authtoken.secret" 2>/dev/null)
port=$(cat "${HOME_DIR}/zerotier-one.port" 2>/dev/null)
[ -n "${port}" ] || port=9993
if [ -z "${token}" ]; then
    reply "503 Service Unavailable" "{\"error\":\"token-unreadable\",\"cgiUser\":\"$(id -un)\"}"
fi

# zt METHOD PATH [BODY]: prints the response body; fails unless HTTP 200.
# ZT_TIMEOUT: leaving a network tears its interface down, which can take a while.
zt() {
    method=$1
    path=$2
    out=$(curl -s -m "${ZT_TIMEOUT:-8}" -X "${method}" -H "X-ZT1-Auth: ${token}" -H "Content-Type: application/json" \
        ${3:+--data "$3"} -w '\n%{http_code}' "http://127.0.0.1:${port}${path}") || return 1
    code=$(printf '%s' "${out}" | tail -n 1)
    printf '%s' "${out}" | sed '$d'
    [ "${code}" = "200" ]
}

valid_id() {
    printf '%s' "${network_id}" | grep -Eq '^[0-9a-f]{16}$'
}

case "${action}" in
    status)
        st=$(zt GET /status) || st=""
        [ -n "${st}" ] || reply "503 Service Unavailable" '{"error":"service-down"}'
        nets=$(zt GET /network) || nets=""
        [ -n "${nets}" ] || nets="[]"
        reply "200 OK" "{\"status\":${st},\"networks\":${nets}}"
        ;;
    join|leave)
        [ "${REQUEST_METHOD}" = "POST" ] || reply "405 Method Not Allowed" '{"error":"post-only"}'
        valid_id || reply "400 Bad Request" '{"error":"bad-network-id"}'
        if [ "${action}" = "leave" ]; then
            # Not DELETE /network/<id>: with ZeroTier 1.16 on DSM's 4.4 kernel
            # it wedges zerotier-one's network lock (the API, then traffic, stop
            # until a restart). Instead: stop zerotier-one, forget the network,
            # and let the supervisor start it again. Other networks drop for a
            # few seconds, which the app tells the user before confirming.
            conf="${HOME_DIR}/networks.d/${network_id}.conf"
            [ -e "${conf}" ] || reply "404 Not Found" '{"error":"not-joined"}'
            zt_pid=$(cat "${HOME_DIR}/zerotier-one.pid" 2>/dev/null)
            # Answer first: this page may itself travel over a ZeroTier network.
            setsid /bin/sh -c '
                sleep 1
                if [ -n "$1" ] && kill "$1" 2>/dev/null; then
                    i=0
                    while [ $i -lt 20 ] && kill -0 "$1" 2>/dev/null; do sleep 0.5; i=$((i + 1)); done
                    kill -9 "$1" 2>/dev/null
                fi
                rm -f "$2" "$3"
            ' leave "${zt_pid}" "${conf}" "${HOME_DIR}/networks.d/${network_id}.local.conf" \
                </dev/null >/dev/null 2>&1 &
            reply "200 OK" '{"ok":true,"restarting":true}'
        fi
        ZT_TIMEOUT=30
        result=$(zt POST "/network/${network_id}" '{}') || reply "502 Bad Gateway" '{"error":"service-error"}'
        # Pass ZeroTier's reply on only when it looks like a JSON object.
        case "${result}" in
            "{"*) reply "200 OK" "{\"ok\":true,\"result\":${result}}" ;;
            *) reply "200 OK" '{"ok":true}' ;;
        esac
        ;;
    *)
        reply "400 Bad Request" '{"error":"unknown-action"}'
        ;;
esac
