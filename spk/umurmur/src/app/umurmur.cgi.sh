#!/bin/sh

# Determine the server host for the Mumble client link.
HOST="${SERVER_NAME:-${HTTP_HOST:-localhost}}"

# HTML-escape the host for safe display in the page.
ESCAPED_HOST=$(printf '%s' "${HOST}" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g')

# Check whether the uMurmur server is listening on its port (64738 = 0xFCE2).
if grep -qiE ":fce2" /proc/net/tcp /proc/net/tcp6 /proc/net/udp /proc/net/udp6 2>/dev/null; then
    STATUS="running"
    STATUS_MSG="The uMurmur server is running."
else
    STATUS="stopped"
    STATUS_MSG="The uMurmur server is not running."
fi

MUMBLE_URI="mumble://${ESCAPED_HOST}:64738/?version=1.2.4"

echo "Content-type: text/html"
echo ""
cat << EOF
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>uMurmur</title>
<style>
  body { font-family: "Helvetica Neue", Arial, sans-serif; margin: 0; padding: 2rem; background: #f5f5f5; color: #333; }
  .card { max-width: 36rem; margin: 0 auto; background: #fff; border-radius: 8px; padding: 2rem; box-shadow: 0 1px 3px rgba(0,0,0,.1); }
  h1 { margin-top: 0; font-size: 1.5rem; }
  .status { font-weight: bold; }
  .status.running { color: #2e7d32; }
  .status.stopped { color: #c62828; }
  .address { background: #f0f0f0; padding: .5rem .75rem; border-radius: 4px; font-family: monospace; }
  .btn { display: inline-block; margin-top: 1rem; padding: .6rem 1.2rem; background: #1976d2; color: #fff; text-decoration: none; border-radius: 4px; }
  .note { margin-top: 1.5rem; font-size: .85rem; color: #666; }
  a { color: #1976d2; }
</style>
</head>
<body>
<div class="card">
  <h1>uMurmur</h1>
  <p class="status ${STATUS}">${STATUS_MSG}</p>
  <p>Connect your Mumble client to:</p>
  <p class="address">${ESCAPED_HOST}:64738</p>
  <p><a class="btn" href="${MUMBLE_URI}">Launch Mumble client</a></p>
  <p class="note">Launching the client requires the <a href="https://www.mumble.info/downloads/">Mumble desktop client</a> to be installed and registered to handle <code>mumble://</code> links. If the button does nothing, download Mumble from <a href="https://www.mumble.info/downloads/">mumble.info/downloads</a> and connect to <code>${ESCAPED_HOST}:64738</code> manually.</p>
</div>
</body>
</html>
EOF
