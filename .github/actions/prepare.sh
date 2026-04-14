#!/bin/bash

# Part of github build action
#
# Evaluate packages to build and referenced source files to download.
#
# Functions:
# - Build all packages defined by ${USER_SPK_TO_BUILD} and ${GH_SPK_PACKAGES}
# - Evaluate additional packages to build depending on changed folders defined in ${GH_DEPENDENT_PACKAGES}
# - Resolve and inject missing meta-packages recursively based on *_PACKAGE Makefile variables
# - Ensure deterministic build order using dependency-driven resolution (DFS, post-order)
# - Classify packages by architecture and minimum DSM version requirements
# - Collect referenced native and cross packages into the download list
#
# Outputs (via GITHUB_OUTPUT):
# - arch_packages                  : space-separated list of arch-specific packages to build (standard DSM)
# - noarch_packages                : space-separated list of noarch packages to build (standard DSM)
# - has_arch_packages              : true/false
# - has_noarch_packages            : true/false
# - arch_min_dsm<V>_packages       : space-separated list of arch packages requiring min DSM version
# - noarch_min_dsm<V>_packages     : space-separated list of noarch packages requiring min DSM version
# - has_arch_min_dsm<V>_packages   : true/false
# - has_noarch_min_dsm<V>_packages : true/false
# - download_packages              : space-separated list of cross/native packages to pre-download

set -o pipefail

# ===========================================================================
# Configuration — update these lists when versions are added or removed
# ===========================================================================

# ffmpeg versions to manage build order for
ffmpeg_versions=(5 6 7 8)

# python minor versions to manage build order for
python_versions=(310 311 312 313 314)

# DSM versions above the default builds (6.2.4, 7.1) that require special handling.
# Packages declaring REQUIRED_MIN_DSM equal to one of these will only be built
# for the corresponding toolchain, not for the standard ones.
min_dsm_versions=(7.2 7.3)

# Makefile variables that declare a dependency on a meta SPK to be built first.
# Add new variable names here to extend meta-package detection.
meta_package_vars=(PYTHON_PACKAGE FFMPEG_PACKAGE VIDEODRV_PACKAGE)

# ===========================================================================

# ---------------------------------------------------------------------------
# Inject and order meta-packages in a package list.
#
# This function resolves meta-package dependencies recursively based on
# Makefile variables listed in meta_package_vars (e.g. PYTHON_PACKAGE,
# FFMPEG_PACKAGE, VIDEODRV_PACKAGE).
#
# The resolution is implemented via a depth-first search (DFS) using the
# internal helper function `_inject_one`. Each package is processed in
# post-order: all its meta-dependencies are resolved first, then the package
# itself is appended to the final list.
#
# A "visited" set, reset on each call, ensures that each package is processed
# only once, preventing duplicate entries and guaranteeing deterministic output.
#
# The resulting list is effectively a topological ordering of packages based
# on declared meta-dependencies:
#   synocli-videodriver -> ffmpeg -> dependent packages
#   pythonXY -> pythonXY-wheels -> dependent packages
#
# `inject_meta_packages` acts as a wrapper that initializes traversal over
# the input package list and owns the local output accumulator, while
# `_inject_one` performs the recursive resolution via a nameref parameter.
#
# This function is the single source of truth for build ordering. The resulting
# order must not be modified afterward, as any reordering would break dependency
# guarantees.
#
# Usage: inject_meta_packages <space-separated package list>
# Prints the ordered space-separated list to stdout.
# State (visited, output accumulator) is fully local to each call.
# ---------------------------------------------------------------------------
inject_meta_packages() {
    local input="$1"
    local output=
    unset visited
    declare -A visited

    for package in ${input}; do
        _inject_one "$package" output
    done

    echo "${output}" | xargs
}

_inject_one() {
    local package="$1"
    local -n _inject_one_out="$2"

    # Skip if already processed
    if [ "${visited[$package]}" = "1" ]; then
        return
    fi
    visited[$package]=1

    if [ -f "./spk/${package}/Makefile" ]; then
        for meta_var in "${meta_package_vars[@]}"; do
            while IFS= read -r meta; do
                [ -z "${meta}" ] && continue
                _inject_one "$meta" "$2"
            done < <(grep -E "^${meta_var}\s*=" "./spk/${package}/Makefile" | cut -d= -f2 | xargs -n1)
        done
    fi

    _inject_one_out="${_inject_one_out} ${package}"
}

# ---------------------------------------------------------------------------
# Collect packages that declare REQUIRED_MIN_DSM = <version>,
# preserving the build order already established in $packages.
# Injects required meta-packages by resolving all qualifying packages
# in a single inject_meta_packages call to avoid cross-iteration state issues.
#
# Usage: collect_min_dsm_packages <version>
# Prints the space-separated list to stdout.
# ---------------------------------------------------------------------------
collect_min_dsm_packages() {
    local version="$1"
    local result=
    for package in ${packages}; do
        if [ -f "./spk/${package}/Makefile" ]; then
            if [ "$(grep REQUIRED_MIN_DSM "./spk/${package}/Makefile" | cut -d= -f2 | xargs)" = "${version}" ]; then
                result+="${package} "
            fi
        fi
    done
    echo $(inject_meta_packages "${result}")
}

# ===========================================================================
# 1. Collect raw package list
# ===========================================================================
echo "::group:: ---- find dependent packages"

# Generate local.mk to capture DEFAULT_TC
make setup-synocommunity
DEFAULT_TC=$(grep DEFAULT_TC local.mk | cut -f2 -d= | xargs)

# All packages to build from changes or manual definition
SPK_TO_BUILD="${USER_SPK_TO_BUILD} ${GH_SPK_PACKAGES} "

# Get dependency list
# Dependencies in this list include the cross or native folder (i.e. native/python cross/glib)
echo "Building dependency list..."
DEPENDENCY_LIST=./dependency-list.txt
make dependency-list-spk 2>/dev/null > "${DEPENDENCY_LIST}"

# Search for dependent spk packages
for package in ${GH_DEPENDENCY_FOLDERS}; do
    echo "===> Searching for dependent package: ${package}"
    found=$(grep -w "${package}" "${DEPENDENCY_LIST}" | grep -o ".*:" | tr ':' ' ' | sort -u | tr '\n' ' ')
    if [ -n "${found}" ]; then
        echo "===> Found: ${found}"
    else
        echo "===> Found: none"
    fi
    SPK_TO_BUILD+=" ${found}"
done

# Fix for packages with different names
if [ "$(echo "${SPK_TO_BUILD}" | grep -o ' nzbdrone ')" != "" ]; then
    SPK_TO_BUILD=$(echo "${SPK_TO_BUILD}" | tr ' ' '\n' | grep -v "^nzbdrone$" | tr '\n' ' ')" sonarr3"
fi
if [ "$(echo "${SPK_TO_BUILD}" | grep -o ' python ')" != "" ]; then
    SPK_TO_BUILD=$(echo "${SPK_TO_BUILD}" | tr ' ' '\n' | grep -v "^python$" | tr '\n' ' ')" python2"
fi

# Remove duplicate packages
packages=$(printf '%s' "${SPK_TO_BUILD}" | tr ' ' '\n' | sort -u | tr '\n' ' ')

# Remove BROKEN packages (marked with a BROKEN file) or invalid packages (no Makefile
# and not in dependency list). Packages with a BROKEN file are always skipped regardless
# of their presence in the dependency list.
filtered_packages=
for package in ${packages}; do
    if [ -f "./spk/${package}/BROKEN" ]; then
        broken_reason=$(cat "./spk/${package}/BROKEN")
        echo "===> Skipping BROKEN package: ${package} (${broken_reason})"
    elif ! grep -q "^${package}:" "${DEPENDENCY_LIST}" && [ ! -f "./spk/${package}/Makefile" ]; then
        echo "===> Skipping invalid package (no Makefile, not in dependency list): ${package}"
    else
        filtered_packages+="${package} "
    fi
done
packages=$(echo "${filtered_packages}" | xargs)

# Inject missing meta-packages into the global package list
packages=$(inject_meta_packages "${packages}")


# ===========================================================================
# 2. Classify packages: arch-specific vs noarch, and by minimum DSM version
#    All classifications iterate over $packages to preserve build order.
# ===========================================================================

# Collect DSM-restricted packages first so they can be excluded from standard builds.
# inject_meta_packages is called inside collect_min_dsm_packages for each DSM list.

# Find all noarch packages (needed for classification)
all_noarch=$(find spk/ -maxdepth 2 -mindepth 2 -name "Makefile" \
    -exec grep -Ho "override ARCH" {} \; \
    | grep -Po ".*spk/\K[^/]*" | sort | tr '\n' ' ')

# Collect DSM-restricted packages, split into arch and noarch lists.
for version in "${min_dsm_versions[@]}"; do
    v=${version//.}
    result=$(collect_min_dsm_packages "${version}")

    # Split into arch and noarch using intermediate variables
    arch_var="arch_min_dsm${v}_packages"
    noarch_var="noarch_min_dsm${v}_packages"

    # Build strings in temporary variables first
    arch_list=""
    noarch_list=""
    for pkg in ${result}; do
        if echo "${all_noarch}" | tr ' ' '\n' | grep -qx "${pkg}"; then
            noarch_list="${noarch_list}${noarch_list:+ }${pkg}"
        else
            arch_list="${arch_list}${arch_list:+ }${pkg}"
        fi
    done

    # Assign to dynamic variable names
    declare "${arch_var}=${arch_list}"
    declare "${noarch_var}=${noarch_list}"

    # Set has_* variables
    has_arch_var="has_arch_min_dsm${v}_packages"
    has_noarch_var="has_noarch_min_dsm${v}_packages"
    declare "${has_arch_var}=$([ -n "${arch_list}" ] && echo 'true' || echo 'false')"
    declare "${has_noarch_var}=$([ -n "${noarch_list}" ] && echo 'true' || echo 'false')"
done

# Build the combined list of all DSM-restricted non-meta packages for exclusion
# from standard builds. Meta-packages are intentionally kept in standard builds
# since other standard packages may depend on them.
all_min_dsm_packages=
for version in "${min_dsm_versions[@]}"; do
    v=${version//.}
    arch_var="arch_min_dsm${v}_packages"
    noarch_var="noarch_min_dsm${v}_packages"
    eval "arch_pkgs=\$${arch_var}"
    eval "noarch_pkgs=\$${noarch_var}"
    for pkg in ${arch_pkgs} ${noarch_pkgs}; do
        # Keep meta-packages in standard builds — only exclude applicative packages.
        # A package is a meta if its name matches python*, ffmpeg* or synocli-videodriver.
        is_meta=false
        [ "${pkg}" = "synocli-videodriver" ] && is_meta=true
        for i in "${ffmpeg_versions[@]}"; do
            [ "${pkg}" = "ffmpeg${i}" ] && is_meta=true && break
        done
        for py_ver in "${python_versions[@]}"; do
            [ "${pkg}" = "python${py_ver}" ] && is_meta=true && break
        done
        if [ "${is_meta}" = "false" ]; then
            if ! echo "${all_min_dsm_packages}" | tr ' ' '\n' | grep -qx "${pkg}"; then
                all_min_dsm_packages+="${pkg} "
            fi
        fi
    done
done

# Separate noarch and arch-specific packages.
# Filter out packages that are removed or do not exist (e.g. nzbdrone).
# Exclude DSM-restricted non-meta packages from standard builds.
arch_packages=
noarch_packages=
has_arch_packages='false'
has_noarch_packages='false'
for package in ${packages}; do
    if [ -f "./spk/${package}/Makefile" ]; then
        if echo "${all_min_dsm_packages}" | tr ' ' '\n' | grep -qx "${package}"; then
            continue
        fi
        if [ "$(echo "${all_noarch}" | grep -ow "${package}")" = "" ]; then
            arch_packages+="${package} "
            has_arch_packages='true'
        else
            noarch_packages+="${package} "
            has_noarch_packages='true'
        fi
    fi
done

# ===========================================================================
# 3. Export all outputs to GITHUB_OUTPUT
# ===========================================================================

# Static outputs
output_vars=(
    arch_packages
    noarch_packages
    has_arch_packages
    has_noarch_packages
)

# Dynamic outputs — arch and noarch per DSM version
for version in "${min_dsm_versions[@]}"; do
    v=${version//.}
    output_vars+=("arch_min_dsm${v}_packages" "has_arch_min_dsm${v}_packages")
    output_vars+=("noarch_min_dsm${v}_packages" "has_noarch_min_dsm${v}_packages")
done

for var in "${output_vars[@]}"; do
    echo "${var}=${!var}" >> $GITHUB_OUTPUT
done

echo "::endgroup::"

# ===========================================================================
# 4. Build summary — display what will be built per target for easier debugging
# ===========================================================================
echo ""
echo "::group:: ---- build summary"
echo ""
echo "STANDARD builds (DSM 6.2.4, 7.1):"
if [ -n "${arch_packages}" ]; then
    echo "  arch    : ${arch_packages}"
else
    echo "  arch    : none"
fi
if [ -n "${noarch_packages}" ]; then
    echo "  noarch  : ${noarch_packages}"
else
    echo "  noarch  : none"
fi

echo ""
echo "RESTRICTED builds (min DSM version):"
any_restricted='false'
for version in "${min_dsm_versions[@]}"; do
    v=${version//.}
    arch_var="arch_min_dsm${v}_packages"
    noarch_var="noarch_min_dsm${v}_packages"
    has_arch_var="has_arch_min_dsm${v}_packages"
    has_noarch_var="has_noarch_min_dsm${v}_packages"
    if [ "${!has_arch_var}" = "true" ] || [ "${!has_noarch_var}" = "true" ]; then
        echo "  DSM ${version} arch: ${!arch_var}"
        echo "  DSM ${version} noarch: ${!noarch_var}"
        any_restricted='true'
    fi
done
if [ "${any_restricted}" = "false" ]; then
    echo "  none"
fi
echo "::endgroup::"

# ===========================================================================
# 5. Evaluate download list for all packages to build
# ===========================================================================

if [ -z "${packages}" ]; then
    echo "===> No packages to download. <==="
    echo "download_packages=" >> $GITHUB_OUTPUT
else
    echo "===> PACKAGES to download references for: ${packages}"
    DOWNLOAD_LIST=
    for package in ${packages}; do
        DOWNLOAD_LIST+=$(grep "^${package}:" "${DEPENDENCY_LIST}" | grep -o ":.*" | tr ':' ' ' | sort -u | tr '\n' ' ')
    done
    # Remove duplicate downloads
    downloads=$(printf '%s' "${DOWNLOAD_LIST}" | tr ' ' '\n' | sort -u | tr '\n' ' ')
    echo "download_packages=${downloads}" >> $GITHUB_OUTPUT
fi
