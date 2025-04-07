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
set -e  # Exit on any command failure

# Function to download a package and handle errors
download_package() {
    local package_dir="$1"
    local target="$2"
    
    echo "===> Attempting to download: ${package_dir}"
    if ! make -C "${package_dir}" "${target}"; then
        echo "Error: Failed to download ${package_dir}. Exiting." >&2
        exit 1
    fi
    echo "===> Successfully downloaded: ${package_dir}"
}

# Download regular cross/* sources
if [ -z "${DOWNLOAD_PACKAGES}" ]; then
    echo "===> No packages to download. <==="
else
    echo "===> Download packages: ${DOWNLOAD_PACKAGES}"
    for download in ${DOWNLOAD_PACKAGES}; do
        download_package "${download}" "download-all"
    done
fi

echo ""

# Download python wheel sources files
build_packages="${NOARCH_PACKAGES} ${ARCH_PACKAGES}"

if [ -z "${build_packages}" ]; then
    echo "===> No wheels to download. <==="
else
    echo "===> Download wheels: ${build_packages}"
    for package in ${build_packages}; do
        download_package "spk/${package}" "download-wheels"
    done
fi

echo "===> All downloads completed successfully."
