#!/bin/bash

# Part of github build action
#
# Download source files.
#
# Functions:
# - Download all referenced native and cross source files for packages to build.
# - Download all referenced python wheels needed to build.

set -o pipefail

# Download regular cross/* sources
if [ -z "${DOWNLOAD_PACKAGES}" ]; then
    echo "===> No packages to download. <==="
else
    echo "===> Download packages: ${DOWNLOAD_PACKAGES}"
    for download in ${DOWNLOAD_PACKAGES}
    do
        echo "$ make -c ${download} download"
        make -C ${download} download
    done
fi

# Download any python wheel sources
if [ "${GH_ARCH%%-*}" = "noarch" ]; then
    build_packages=${NOARCH_PACKAGES}
else
    build_packages=${ARCH_PACKAGES}
fi

echo ""
echo "GH_ARCH: ${GH_ARCH%%-*}"
echo "GH_ARCH: ${GH_ARCH}"
echo "NOARCH_PACKAGES: ${NOARCH_PACKAGES}"
echo "ARCH_PACKAGES: ${ARCH_PACKAGES}"
echo "build_packages: ${build_packages}"

if [ -z "${build_packages}" ]; then
    echo "===> No wheels to download. <==="
    exit 0
fi
for package in ${build_packages}
do
    echo "===> Download wheels: ${package}"
    make -C ${package} download_wheel
fi

echo ""
