#!/bin/sh

echo Content-type: text/html
echo

cat << EOF

<HTML>

<meta http-equiv="Refresh" content="1; url=mumble://${SERVER_NAME}/?version=1.2.4">

</HTML>
EOF
