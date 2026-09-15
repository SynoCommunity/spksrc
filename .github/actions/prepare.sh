#!/bin/bash

# Part of github build action
#
# Evaluate packages to build and referenced source files to download.
#
# Functions:
# - Build all packages defined by ${USER_SPK_TO_BUILD} and ${GH_SPK_PACKAGES}
# - Evaluate additional packages to build depending on changed folders defined in ${GH_DEPENDENT_PACKAGES}
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
# - videodriver                    : 0 when the videodriver meta must be left out of the builds

set -o pipefail

# ===========================================================================
# Configuration — update these lists when versions are added or removed
# ===========================================================================

# DSM versions above the default builds (6.2.4, 7.1) that require special handling.
# Packages declaring REQUIRED_MIN_DSM equal to one of these will only be built
# for the corresponding toolchain, not for the standard ones.
min_dsm_versions=(7.2 7.3)

# The videodriver meta and its tools: heavy builds that almost never change. Automatic runs
# build them only when change detection named one; manual runs always do (see section 1).
videodriver_packages="synocli-videodriver synocli-videodriver-tools"
videodriver=1

# ===========================================================================

# ---------------------------------------------------------------------------
# Collect packages that declare REQUIRED_MIN_DSM = <version>,
# preserving the order already established in $packages.
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
    echo ${result} | xargs
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

# Remove duplicate packages
packages=$(printf '%s' "${SPK_TO_BUILD}" | tr ' ' '\n' | sort -u | tr '\n' ' ')

# Remove disabled packages (marked with a BROKEN or DISABLED file) or invalid packages
# (no Makefile and not in dependency list). Packages with a BROKEN or DISABLED file are
# always skipped regardless of their presence in the dependency list.
filtered_packages=
for package in ${packages}; do
    if [ -f "./spk/${package}/BROKEN" ] || [ -f "./spk/${package}/DISABLED" ]; then
        broken_reason=$(cat "./spk/${package}/BROKEN" "./spk/${package}/DISABLED" 2>/dev/null)
        echo "===> Skipping disabled package: ${package} (${broken_reason})"
    elif ! grep -q "^${package}:" "${DEPENDENCY_LIST}" && [ ! -f "./spk/${package}/Makefile" ]; then
        echo "===> Skipping invalid package (no Makefile, not in dependency list): ${package}"
    else
        filtered_packages+="${package} "
    fi
done
packages=$(echo "${filtered_packages}" | xargs)

# Every package builds its own metas through BUILD_DEPENDS, so the only question left is
# the videodriver one: a manual dispatch, or a change that named it above, pays for it.
if [ "${GITHUB_EVENT_NAME}" != "workflow_dispatch" ]; then
    videodriver=0
    for package in ${packages}; do
        case " ${videodriver_packages} " in
            *" ${package} "*) videodriver=1 ;;
        esac
    done
    if [ "${videodriver}" = "0" ]; then
        echo "===> Leaving out the videodriver meta: automatic run, no change of its own"
    fi
fi


# ===========================================================================
# 2. Classify packages: arch-specific vs noarch, and by minimum DSM version
#    All classifications iterate over $packages to preserve build order.
# ===========================================================================

# Collect DSM-restricted packages first so they can be excluded from standard builds.

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

# Build the combined list of all DSM-restricted packages for exclusion from the
# standard builds. Each list holds what declares that REQUIRED_MIN_DSM itself, and
# nothing may be exempt: a package that refuses DSM 7.1 cannot build there.
all_min_dsm_packages=
for version in "${min_dsm_versions[@]}"; do
    v=${version//.}
    eval "arch_pkgs=\$arch_min_dsm${v}_packages"
    eval "noarch_pkgs=\$noarch_min_dsm${v}_packages"
    for pkg in ${arch_pkgs} ${noarch_pkgs}; do
        if ! echo "${all_min_dsm_packages}" | tr ' ' '\n' | grep -qx "${pkg}"; then
            all_min_dsm_packages+="${pkg} "
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
    videodriver
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
