#!/bin/bash

cat <<EOF > local.mk
PUBLISH_URL=https://api.synocommunity.com
PUBLISH_API_KEY=
MAINTAINER?=
MAINTAINER_URL=
DISTRIBUTOR=SynoCommunity
DISTRIBUTOR_URL=https://synocommunity.com/
REPORT_URL=https://github.com/SynoCommunity/spksrc/issues
SUPPORT_URL=https://github.com/SynoCommunity/spksrc/issues
DEFAULT_TC=6.1
PARALLEL_MAKE=4
EOF

# echo "FILES: $FILES"

# filter for changes made in the cross and spk directories
GH_FILES=$(echo "$GH_FILES" | grep -oE "(spk.*)|(cross.*)")

# create array of potential packages where files have changed
GH_PACKAGES_ARR=()
for GH_FILE in $GH_FILES
do
    # remove leading spk and cross from string
    GH_FILE=${GH_FILE#spk/}
    if [[ "$GH_FILE" == cross/* ]]; then
        make dependency-tree
        GH_FILE=${GH_FILE#cross/}
    fi

    # get package name / folder name
    GH_PACKAGE=$(echo "$GH_FILE" | grep -oE "^[^\/]*")
    # echo "PACKAGE: $PACKAGE"
    GH_PACKAGES_ARR+=("$GH_PACKAGE")
done

# de-duplicate packages
GH_PACKAGES=$(printf %s "${GH_PACKAGES_ARR[*]}" | tr ' ' '\n' | sort -u)

if [ -z "$GH_PACKAGES" ]; then
    echo "no package built. Empty PACKAGES var"
    exit 0
fi

echo "===> PACKAGES to Build: $GH_PACKAGES"

for GH_PACKAGE in $GH_PACKAGES
do
    # make sure that the package exists
    if [ -d "spk/$GH_PACKAGE" ]; then
        cd spk/"$GH_PACKAGE" && make "$GH_ARCH"
    else
        # must be from cross/
        echo "$GH_PACKAGE is not a spk PACKAGE" # TODO: maybe find depended packages
        make dependency-tree
    fi
done
