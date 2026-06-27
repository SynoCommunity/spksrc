#!/bin/sh

# Add randomness when running cron job (0-30 minutes)
# Be nice to servers and don't update at exactly midnight at the same time
# shellcheck disable=SC2039
[ -n "$RANDOM" ] && sleep $((RANDOM % 1800))

PKGVAR="/var/packages/dnscrypt-proxy/target/var"
cd "${PKGVAR}" || exit

# Try python3 first, fall back to python
PYTHON=$(command -v python3 || command -v python)
if [ -z "$PYTHON" ]; then
    echo "Error: Python not found" >&2
    exit 1
fi

"$PYTHON" generate-domains-blocklist.py > blocklist.txt.tmp && mv -f blocklist.txt.tmp blocklist.txt
echo "## Last updated at: $(date)" >> blocklist.txt
