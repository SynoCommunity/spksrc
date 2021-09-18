#!/bin/bash

# github action to download source files.
#
# Functions:
# - Download all referenced native and cross source files for packages to build.

set -o pipefail

echo "::group:: ---- find dependent packages"

# filter for changes made in the spk directories and take unique package name (without spk folder)
SPK_TO_BUILD+=" "
SPK_TO_BUILD+=$(echo "${GH_FILES}" | tr ' ' '\n' | grep -oP "(spk)/\K[^\/]*" | sort -u | tr '\n' ' ')

# filter for changes made in the cross and native directories and take unique package name (including cross or native folder)
DEPENDENT_PACKAGES=$(echo "${GH_FILES}" | tr ' ' '\n' | grep -oP "(cross|native)/[^\/]*" | sort -u | tr '\n' ' ')

# get dependency list
# dependencies in this list include the cross or native folder (i.e. native/python cross/glib)
echo "Building dependency list..."
DEPENDENCY_LIST=
for package in $(find spk/ -maxdepth 1 -type d | cut -c 5- | sort)
do
    DEPENDENCY_LIST+=$(make -s -C spk/${package} dependency-list)$'\n'
done

# search for dependent spk packages
for package in ${DEPENDENT_PACKAGES}
do
    echo "===> Searching for dependent package: ${package}"
    packages=$(echo "${DEPENDENCY_LIST}" | grep -w "${package}" | grep -o ".*:" | tr ':' ' ' | sort -u | tr '\n' ' ')
    echo "===> Found: ${packages}"
    SPK_TO_BUILD+=${packages}
done

# fix for packages with different names
if [ "$(echo ${SPK_TO_BUILD} | grep -ow nzbdrone)" != "" ]; then
    SPK_TO_BUILD+=" sonarr"
fi
if [ "$(echo ${SPK_TO_BUILD} | grep -ow python)" != "" ]; then
    SPK_TO_BUILD+=" python2"
fi

# remove duplicate packages
packages=$(printf %s "${SPK_TO_BUILD}" | tr ' ' '\n' | sort -u | tr '\n' ' ')


echo "::endgroup::"

if [ -z "${packages}" ]; then
    echo "===> No packages to download. <==="
else
    echo "===> PACKAGES to download references for: ${packages}"
    echo "::group:: ---- download"
    DOWNLOAD_LIST=
    for package in ${packages}
    do
        DOWNLOAD_LIST+=$(echo "${DEPENDENCY_LIST}" | grep "^${package}:" | grep -o ":.*" | tr ':' ' ' | sort -u | tr '\n' ' ')
    done
    # remove duplicate downloads
    downloads=$(printf %s "${DOWNLOAD_LIST}" | tr ' ' '\n' | sort -u | tr '\n' ' ')
    echo "===> References to download: ${downloads}"
    for download in ${downloads}
    do
        make -C ${download} download
    done
    echo "::endgroup::"
fi
