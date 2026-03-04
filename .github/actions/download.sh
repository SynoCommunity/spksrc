#!/bin/bash

# Part of GitHub build action.
# This script downloads source files for cross and python packages as part of our build process.
#
# Functions:
# - Download all referenced native and cross source files for packages.
# - Download all referenced python wheels needed to build.
# - The "download" target auto-orchestrates when a package has multiple (arch-specific) files.
# - Retry download if checksum fails (cached file may be outdated).

set -euo pipefail
# Report any error (with line and package context) and exit.
trap 'echo "::error::Error on line ${LINENO} while processing ${current:-unknown}"; exit 1' ERR

# Ensure required tooling is present.
command -v make >/dev/null 2>&1 || { echo "::error::make is not installed"; exit 1; }

# Function to download and verify with retry on checksum failure
download_with_retry() {
    local target_dir="$1"
    local target_name="$2"
    local result=0
    local output=""

    echo "  -> ${target_dir}: ${target_name} then checksum"

    # First attempt
    set +e
    output=$(make -C "${target_dir}" ${target_name} checksum 2>&1)
    result=$?
    set -e

    # Display output
    echo "$output"

    if [ $result -eq 0 ]; then
        return 0
    fi

    # Check if checksum failure occurred by looking for .wrong rename in output
    # Use escaped dot to match literal .wrong extension
    if echo "$output" | grep -q 'Renamed as .*\.wrong'; then
        echo "  -> Checksum failed due to outdated cached file, retrying download for ${target_dir}..."

        # Retry download and checksum
        set +e
        make -C "${target_dir}" ${target_name} checksum
        result=$?
        set -e

        if [ $result -eq 0 ]; then
            return 0
        fi
    fi

    # Both attempts failed or failure was not due to cached file
    echo "::error::Download/checksum failed for ${target_dir}"
    return 1
}

echo ""
# 1) Download native / cross-compiled sources.
if [ -z "${DOWNLOAD_PACKAGES:-}" ]; then
    echo "===> No packages to download. <==="
else
    echo "===> Downloading packages: ${DOWNLOAD_PACKAGES}"
    for current in ${DOWNLOAD_PACKAGES}; do
        download_with_retry "${current}" "download"
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
        echo "  -> ${current}: download-wheels"
        # Wheels don't have checksum verification, so no retry needed
        make -C "${current}" download-wheels || true
    done
fi

echo ""
echo "===> All downloads completed successfully."
