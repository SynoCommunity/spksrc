#!/bin/bash

cat <<EOF > local.mk
PUBLISH_URL=https://api.synocommunity.com
PUBLISH_API_KEY=$API_KEY
MAINTAINER?=
MAINTAINER_URL=
DISTRIBUTOR=SynoCommunity
DISTRIBUTOR_URL=https://synocommunity.com/
REPORT_URL=https://github.com/SynoCommunity/spksrc/issues
SUPPORT_URL=https://github.com/SynoCommunity/spksrc/issues
DEFAULT_TC=6.1
PARALLEL_MAKE=4
EOF

# PACKAGE=$(echo "refs/tags/dnscrypt-proxy-2.0.42" | grep -oE "([0-9a-zA-Z]*-)*")
GH_PACKAGE=$(echo "$GITHUB_REF" | grep -oE "([0-9a-zA-Z]*-)*")
GH_PACKAGE="${GH_PACKAGE:0:-1}"
echo "$GH_PACKAGE"

cd spk/"$GH_PACKAGE" && make "$GH_ARCH"
