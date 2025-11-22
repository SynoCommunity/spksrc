#!/bin/bash

# Part of GitHub build action.
# This script downloads source files for cross and python packages as part of our build process.
#
# Functions:
# - Download all referenced native and cross source files for packages.
# - Download all referenced python wheels needed to build.
# - Use the "download-all" target when a package has multiple (arch-specific) files.
# - Retry download if checksum fails (cached file may be outdated).

set -euo pipefail
# Report any error (with line and package context) and exit.
trap 'echo "::error::Error on line ${LINENO} while processing ${current:-<none>}"; exit 1' ERR

# Ensure required tooling is present.
command -v make >/dev/null 2>&1 || { echo "::error::make is not installed"; exit 1; }

# Function to download and verify with retry on checksum failure
download_with_retry() {
    local target_dir="$1"
    local target_name="$2"

    echo "  -> ${target_dir}: ${target_name} then checksum"

    # First attempt
    if make -C "${target_dir}" ${target_name} checksum; then
        return 0
    fi

    # Check if checksum failure occurred (files renamed to .wrong)
    if find distrib -name "*.wrong" -newer /tmp/download_start_marker 2>/dev/null | grep -q .; then
        echo "  -> Checksum failed, retrying download for ${target_dir}..."
        # Retry download and checksum
        if make -C "${target_dir}" ${target_name} checksum; then
            return 0
        fi
    fi

    # Both attempts failed
    return 1
}

# Create marker file for tracking new .wrong files
touch /tmp/download_start_marker

echo ""
# 1) Download native / cross-compiled sources.
if [ -z "${DOWNLOAD_PACKAGES:-}" ]; then
    echo "===> No packages to download. <==="
else
    echo "===> Downloading packages: ${DOWNLOAD_PACKAGES}"
    for current in ${DOWNLOAD_PACKAGES}; do
        download_with_retry "${current}" "download-all"
    done
fi

echo ""
# 2) Download Python wheel source files.
build_pkgs=( ${NOARCH_PACKAGES:-} ${ARCH_PACKAGES:-} )
if [ ${#build_pkgs[@]} -eq 0 ]; then
    echo "===> No wheels to download. <==="
else
    echo "===> Downloading wheels: ${build_pkgs[*]}"
    for pkg in "${build_pkgs[@]}"; do
        current="spk/${pkg}"
        download_with_retry "${current}" "download-wheels"
    done
fi

# Cleanup marker file
rm -f /tmp/download_start_marker

echo ""
echo "===> All downloads completed successfully."
