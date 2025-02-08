#!/bin/bash

# Part of github build action
#
# Download source files.
#
# Functions:
# - Download all referenced native and cross source files for packages to build.
# - Download all referenced python wheels needed to build.
# - use download-all target to get all files when package has multiple (arch specific) files.

set -o pipefail

# Download regular cross/* sources
if [ -z "${DOWNLOAD_PACKAGES}" ]; then
    echo "===> No packages to download. <==="
else
    echo "===> Download packages: ${DOWNLOAD_PACKAGES}"
    for download in ${DOWNLOAD_PACKAGES}
    do
        echo "$ make -c ${download} download-all"
        make -C ${download} download-all
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
        make -C spk/${package} download-wheels
    done
fi

echo ""
