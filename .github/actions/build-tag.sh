#!/bin/bash

make setup-synocommunity
sed -i -e "s|#PARALLEL_MAKE\s*=.*|PARALLEL_MAKE=max|" \
    -e "s|PUBLISH_API_KEY\s*=.*|PUBLISH_API_KEY=$API_KEY|" \
    local.mk

# PACKAGE=$(echo "refs/tags/dnscrypt-proxy-2.0.42" | grep -oE "([0-9a-zA-Z]*-)*")
GH_PACKAGE=$(echo "$GITHUB_REF" | grep -oE "([0-9a-zA-Z]*-)*")
GH_PACKAGE="${GH_PACKAGE:0:-1}"
echo "$GH_PACKAGE"

# use TCVERSION and ARCH parameters to get real exit code.
make TCVERSION=${GH_ARCH##*-} ARCH=${GH_ARCH%%-*} -C spk/${GH_PACKAGE}
