#!/bin/bash

make setup-synocommunity
sed -i -e "s|#PARALLEL_MAKE=.*|PARALLEL_MAKE=4|" local.mk

# filter for changes made in the spk directories and take unique package name
SPK_TO_BUILD=$(echo "$GH_FILES" | tr ' ' '\n' | grep -oP "(spk)/\K[^\/]*" | sort -u | tr '\n' ' ')

# filter for changes made in the cross and native directories and take unique package name
DEPENDENT_PACKAGES=$(echo "$GH_FILES" | tr ' ' '\n' | grep -oP "(cross|native)/[^\/]*" | sort -u | tr '\n' ' ')

# get dependency list
DEPENDENCY_LIST=
echo "Building dependency list..."
for package in $(find spk/ -maxdepth 1 -type d | cut -c 5- | sort)
do
    DEPENDENCY_LIST+=$(make -s -C spk/$package dependency-list)$'\n'
done

# search for dependent spk packages
for package in $DEPENDENT_PACKAGES
do
    echo "===> Searching for dependent package: $package"
    packages=$(echo "${DEPENDENCY_LIST}" | grep " ${package} " | grep -o ".*:" | tr ':' ' ' | sort -u | tr '\n' ' ')
    echo "===> Found: $packages"
    SPK_TO_BUILD+=$packages
done

# de-duplicate packages
packages=$(printf %s "${SPK_TO_BUILD}" | tr ' ' '\n' | sort -u | tr '\n' ' ')

if [ -z "$packages" ]; then
    echo "===> No packages built <==="
    exit 0
fi

echo "===> PACKAGES to Build: $packages"

# Build
for package in $packages
do
    # make sure that the package exists
    if [ -d "/github/workspace/spk/$package" ]; then
        cd /github/workspace/spk/"$package" && make "$GH_ARCH"
    else
        echo "$package is not found"
    fi
done
