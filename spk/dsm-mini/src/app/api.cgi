#!/bin/sh
# Bridges the settings page to the service.
#
# The page is served by DSM's web server; the service listens on loopback and
# is not reachable from a browser at all. This script is the only thing in
# between, and it carries the browser's Cookie header across unchanged — that
# cookie is how the service knows an administrator of this NAS is asking.
#
# It authorises nothing itself. DSM serves /webman/3rdparty/ without a session
# (200 to a request with no cookie, checked on a live NAS), so a check here
# would be a check anyone can skip by calling the service's path directly.
set -eu

fail() {
    printf 'Status: 502\r\nContent-Type: application/json\r\n\r\n{"error":"%s"}\n' "$1"
    exit 0
}

DIR=$(dirname "$0")

# The port the service listens on. config.env is 0600 and owned by the package
# user, so this script cannot read it; the service writes the port — and only
# the port — here, where the web server may, every time it starts listening.
# 58080 until it has: the default in both builds of the package.
PORT=58080
if [ -r "$DIR/backend.conf" ]; then
    . "$DIR/backend.conf"
fi

# The endpoint comes as ?p=settings, not as a path: PATH_INFO is not delivered
# for every DSM version, and a query parameter is.
path=$(printf '%s' "${QUERY_STRING:-}" | tr '&' '\n' | sed -n 's/^p=//p' | head -n 1)
case "$path" in
    status|settings|address|address/proxy|whoami) ;;
    *) fail "unknown endpoint" ;;
esac

url="http://127.0.0.1:${PORT}/dsm/admin/${path}"
method="${REQUEST_METHOD:-GET}"

# The cookie proves who is asking; the token proves the request came from
# DSM's own interface. DSM refuses a browser session without it whenever CSRF
# protection is on, which it is by default.
set -- -s -S -i --max-time 30 -X "$method" \
    -H "Cookie: ${HTTP_COOKIE:-}" \
    -H "X-Syno-Token: ${HTTP_X_SYNO_TOKEN:-}" \
    -H "Content-Type: application/json"

if [ "$method" != "GET" ] && [ "${CONTENT_LENGTH:-0}" -gt 0 ] 2>/dev/null; then
    body=$(head -c "$CONTENT_LENGTH")
    set -- "$@" --data-binary "$body"
fi

# curl -i gives the status line and headers; CGI wants "Status:" instead, and
# the rest of the headers pass through as they are.
out=$(curl "$@" "$url") || fail "the service is not answering"
printf '%s' "$out" | awk '
    NR == 1 { sub(/\r$/, ""); split($0, p, " "); printf "Status: %s\r\n", p[2]; next }
    !seen && /^\r?$/ { seen = 1; printf "\r\n"; next }
    !seen { printf "%s\n", $0; next }
    { print }
'
