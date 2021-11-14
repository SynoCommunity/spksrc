#!/bin/bash

# Part of github build action
#
# Download source files.
#
# Functions:
# - Download all referenced native and cross source files for packages to build.

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

if [ -z "${build_packages}" ]; then
    echo "===> No packages to build. <==="
    exit 0
fi
for package in ${build_packages}
do
    echo "===> Download wheels: ${package}"
    make -C ${package} download_wheel
fi
