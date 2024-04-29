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

echo ""

# Download python wheel sources files
build_packages="${NOARCH_PACKAGES} ${ARCH_PACKAGES}"

if [ -z "${build_packages}" ]; then
    echo "===> No wheels to download. <==="
else
    for package in ${build_packages}; do
        echo "===> Download wheels: ${package}"
        make -C spk/${package} wheeldownload
    done
fi

echo ""
