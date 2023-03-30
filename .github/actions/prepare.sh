#!/bin/bash

# Part of github build action
# 
# Evaluate packages to build and referenced source files to download.
#
# Functions:
# - Evaluate all packages to build depending on files defined in ${GH_FILES}.
# - ffmpeg (spk/ffmpeg4), ffmpeg5 and ffmpeg6 are moved to head of packages to built first if triggered by its own or a dependent.
# - Referenced native and cross packages of the packages to build are added to the download list.

set -o pipefail

echo "::group:: ---- find dependent packages"

# Generate local.mk to capture DEFAULT_TC
make setup-synocommunity
DEFAULT_TC=$(grep DEFAULT_TC local.mk | cut -f2 -d= | xargs)

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
    SPK_TO_BUILD+=" sonarr3"
fi
if [ "$(echo ${SPK_TO_BUILD} | grep -ow python)" != "" ]; then
    SPK_TO_BUILD+=" python2"
fi

# remove duplicate packages
packages=$(printf %s "${SPK_TO_BUILD}" | tr ' ' '\n' | sort -u | tr '\n' ' ')

# for ffmpeg v4-6 find all packages that depends on them
for i in {4..6}; do
    ffmpeg_dependent_packages=$(find spk/ -maxdepth 2 -mindepth 2 -name "Makefile" -exec grep -Ho "FFMPEG_VERSION = ${i}" {} \; | grep -Po ".*spk/\K[^/]*" | sort | tr '\n' ' ')

    # If packages contain a package that depends on ffmpeg (or is ffmpeg), then ensure
    # relevant ffmpeg4|ffmpeg5|ffmpeg6 is first in list
    for package in ${packages}
    do
        if [ "$(echo ffmpeg${i} ${ffmpeg_dependent_packages} | grep -ow ${package})" != "" ]; then
            packages_without_ffmpeg=$(echo "${packages}" | tr ' ' '\n' | grep -v "ffmpeg${i}" | tr '\n' ' ')
            packages="ffmpeg${i} ${packages_without_ffmpeg}"
            break
        fi
    done
done

# find all noarch packages
all_noarch=$(find spk/ -maxdepth 2 -mindepth 2 -name "Makefile" -exec grep -Ho "override ARCH" {} \; | grep -Po ".*spk/\K[^/]*" | sort | tr '\n' ' ')

# separate noarch and arch specific packages
# and filter out packages that are removed or do not exist (e.g. nzbdrone)
arch_packages=
noarch_packages=
for package in ${packages}
do
    if [ -f "./spk/${package}/Makefile" ]; then
        if [ "$(echo ${all_noarch} | grep -ow ${package})" = "" ]; then
            arch_packages+="${package} "
        else
            noarch_packages+="${package} "
        fi
    fi
done

echo "arch_packages=${arch_packages}" >> $GITHUB_OUTPUT
echo "noarch_packages=${noarch_packages}" >> $GITHUB_OUTPUT

echo "::endgroup::"

if [ -z "${packages}" ]; then
    echo "===> No packages to download. <==="
    echo "download_packages" >> $GITHUB_OUTPUT
else
    echo "===> PACKAGES to download references for: ${packages}"
    DOWNLOAD_LIST=
    for package in ${packages}
    do
        DOWNLOAD_LIST+=$(echo "${DEPENDENCY_LIST}" | grep "^${package}:" | grep -o ":.*" | tr ':' ' ' | sort -u | tr '\n' ' ')
        for version in ${DEFAULT_TC}
        do
           DOWNLOAD_LIST+=$(make -C spk/${package} TCVERSION=${version} dependency-kernel-list | grep "^${package}:" | grep -o ":.*" | tr ':' ' ' | sort -u | tr '\n' ' ')
        done
    done
    # remove duplicate downloads
    downloads=$(printf %s "${DOWNLOAD_LIST}" | tr ' ' '\n' | sort -u | tr '\n' ' ')
    echo "download_packages=${downloads}" >> $GITHUB_OUTPUT
fi
