#!/bin/bash

# Part of github build action
#
# Download source files.
#
# Functions:
# - Download all referenced native and cross source files for packages to build.

set -o pipefail

if [ -z "${DOWNLOAD_PACKAGES}" ]; then
    echo "===> No packages to download. <==="
else
    echo "===> Download packages: ${DOWNLOAD_PACKAGES}"
    for download in ${DOWNLOAD_PACKAGES}
    do
        make -C ${download} download
    done
fi
