#!/bin/bash

# Part of GitHub build action.
# This script downloads source files for cross and python packages as part of our build process.
#
# Functions:
# - Download all referenced native and cross source files for packages.
# - Download all referenced python wheels needed to build.
# - Use the “download-all” target when a package has multiple (arch-specific) files.

set -euo pipefail
# Report any error (with line and package context) and exit.
trap 'echo "::error::Error on line ${LINENO} while processing ${current:-<none>}"; exit 1' ERR

# Ensure required tooling is present.
command -v make >/dev/null 2>&1 || { echo "::error::make is not installed"; exit 1; }

echo ""
# 1) Download native / cross-compiled sources.
if [ -z "${DOWNLOAD_PACKAGES:-}" ]; then
    echo "===> No packages to download. <==="
else
    echo "===> Downloading packages: ${DOWNLOAD_PACKAGES}"
    for current in ${DOWNLOAD_PACKAGES}; do
        echo "  → ${current}: download-all then checksum"
        # download-all pulls down all sources; checksum verifies them.
        make -C "${current}" download-all checksum
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
        echo "  → ${current}: download-wheels"
        # download-wheels grabs all needed .whl files.
        make -C "${current}" download-wheels
    done
fi

echo ""
echo "===> All downloads completed successfully."
