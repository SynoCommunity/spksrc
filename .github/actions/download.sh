#!/bin/bash
#
# Part of GitHub build action.
# This script downloads source files for cross and python packages as part of our build process.
#
# Functions:
# - Download all referenced native and cross source files for packages.
# - Download all referenced python wheels needed to build.
# - Use "download-all" target to get all files when a package has multiple (architecture-specific) files.

set -euo pipefail

# Function to print an error message and exit.
fail() {
    echo "::error::$*" >&2
    exit 1
}

# Check for required commands.
command -v make >/dev/null 2>&1 || fail "make is not installed"

# Function to download a package and verify its checksum.
download_package() {
    local package_dir="$1"
    local target="$2"

    echo "===> Attempting to download: ${package_dir}"
    if ! make -C "${package_dir}" "${target}"; then
        fail "Failed to download ${package_dir}."
    fi
    # Verify checksum after download.
    if ! make -C "${package_dir}" checksum; then
        fail "Checksum verification failed for ${package_dir}."
    fi
    echo "===> Successfully downloaded: ${package_dir}"
}

# Download regular cross/* sources.
if [ -z "${DOWNLOAD_PACKAGES:-}" ]; then
    echo "===> No packages to download. <==="
else
    echo "===> Download packages: ${DOWNLOAD_PACKAGES}"
    for download in ${DOWNLOAD_PACKAGES}; do
        download_package "${download}" "download-all"
    done
fi

echo ""

# Download python wheel source files.
build_packages="${NOARCH_PACKAGES:-} ${ARCH_PACKAGES:-}"
if [ -z "${build_packages}" ]; then
    echo "===> No wheels to download. <==="
else
    echo "===> Download wheels: ${build_packages}"
    for package in ${build_packages}; do
        download_package "spk/${package}" "download-wheels"
    done
fi

echo "===> All downloads completed successfully."
