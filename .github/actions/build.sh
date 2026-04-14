#!/bin/bash

# Part of github build action
#
# Build the packages depending on evaluated packages (see prepare.sh)
#
# Functions:
# - Build all packages depending on files defined in ${ARCH_PACKAGES} or ${NOARCH_PACKAGES}.
# - Build for arch defined by ${GH_ARCH} (e.g. x64-6.1, noarch, ...).
# - For DSM versions above the default builds, packages declared for that minimum
#   DSM version are built (driven by MIN_DSM<V>_PACKAGES env vars). If no
#   DSM-restricted packages are present, standard packages are built instead,
#   allowing packages that behave differently per DSM version (but declare no
#   minimum) to be built on all selected toolchains.
# - Successfully built packages are logged to ${BUILD_SUCCESS_FILE}.
# - Failed builds are logged to ${BUILD_ERROR_FILE} and annotated as error.
# - For failed builds, the make command and the latest 15 lines of the build output are written to ${BUILD_ERROR_LOGFILE}.
# - The build output is structured into log groups by package.
# - As the disk space in the workflow environment is limited, we clean the
#   work folder of each package after build. At 2020.06 this limit is 14GB.
# - Packages in PACKAGES_TO_KEEP are not fully cleaned so dependents can reuse
#   their artifacts (shared libs, python wheels, etc.).
# - Therefore synocli-videodriver is built first if triggered by ffmpeg5-7.
# - Therefore ffmpeg and python are built before their dependents (see prepare.sh).

set -o pipefail

# ===========================================================================
# Configuration — keep in sync with prepare.sh
# ===========================================================================

# ffmpeg versions whose build artifacts must be preserved for dependents
ffmpeg_versions=(5 6 7 8)

# python minor versions whose build artifacts must be preserved for dependents
python_versions=(310 311 312 313 314)

# DSM versions above the default builds that require filtered package lists.
# Must match the min_dsm_versions array in prepare.sh.
min_dsm_versions=(7.2 7.3)

# ===========================================================================

# ===========================================================================
# 1. Initialize build environment
# ===========================================================================
echo "::group:: ---- initialize build"
make setup-synocommunity
sed -i -e "s|#PARALLEL_MAKE\s*=.*|PARALLEL_MAKE=max|" \
    -e "s|PUBLISH_API_KEY\s*=.*|PUBLISH_API_KEY=$API_KEY|" \
    local.mk
# Git >= 2.35.2 stops directory traversals when ownership changes from the current user (in response to CVE-2022-24765).
# This prevents errors on nested repos that might have different file owner.
git config --global --add safe.directory "/github/workspace"
echo "::endgroup::"

echo "===> TARGET: ${GH_ARCH}"
echo "===> ARCH   packages: ${ARCH_PACKAGES}"
echo "===> NOARCH packages: ${NOARCH_PACKAGES}"
for version in "${min_dsm_versions[@]}"; do
    v=${version//.}
    arch_var="ARCH_MIN_DSM${v^^}_PACKAGES"
    noarch_var="NOARCH_MIN_DSM${v^^}_PACKAGES"
    echo "===> ${arch_var}: ${!arch_var}"
    echo "===> ${noarch_var}: ${!noarch_var}"
done

# Remove toolchain status files to enforce re-building toolchain including cargo/rust.
# This fixes issues on github-action where toolchain caching omits the
# actual installation state of cargo/rust within the distrib folder.
rm -f toolchain/syno-${GH_ARCH}/work/.toolchain*_done
rm -f toolchain/syno-${GH_ARCH}/work/.stage[01]-*_done

# ===========================================================================
# 2. Select packages to build for this arch
# ===========================================================================

# Extract DSM version from GH_ARCH (e.g., "x64-7.2" -> "7.2", "noarch-7.2" -> "7.2")
DSM_VERSION="${GH_ARCH##*-}"

if [ "${GH_ARCH%%-*}" = "noarch" ]; then
    build_packages=${NOARCH_PACKAGES}
    for version in "${min_dsm_versions[@]}"; do
        if [ "${DSM_VERSION}" = "${version}" ]; then
            v=${version//.}
            var="NOARCH_MIN_DSM${v^^}_PACKAGES"
            # No DSM-restricted packages — fall back to standard noarch packages
            build_packages="${!var:-${NOARCH_PACKAGES}}"
            break
        fi
    done
else
    build_packages=${ARCH_PACKAGES}
    for version in "${min_dsm_versions[@]}"; do
        if [ "${DSM_VERSION}" = "${version}" ]; then
            v=${version//.}
            var="ARCH_MIN_DSM${v^^}_PACKAGES"
            # No DSM-restricted packages — fall back to standard arch packages
            build_packages="${!var:-${ARCH_PACKAGES}}"
            break
        fi
    done
fi

if [ -z "${build_packages}" ]; then
    echo "===> No packages to build. <==="
    exit 0
fi

echo "===> PACKAGES to Build: ${build_packages}"

# ===========================================================================
# 3. Build each package
# ===========================================================================

# Packages whose build artifacts must be preserved for dependents.
# synocli-videodriver and ffmpeg are kept for their shared libs;
# python is kept for its wheels. All others are fully cleaned after build.
packages_to_keep="synocli-videodriver"
for i in "${ffmpeg_versions[@]}"; do
    packages_to_keep+=" ffmpeg${i}"
done
for py_ver in "${python_versions[@]}"; do
    packages_to_keep+=" python${py_ver}"
done

# Publish to synocommunity.com when the API key is set
MAKE_ARGS=
if [ -n "$API_KEY" ] && [ "$PUBLISH" == "true" ]; then
    MAKE_ARGS="publish-"
fi

# Initialize remaining packages list for tracking build progress
remaining_packages="${build_packages}"

for package in ${build_packages}; do
    # Remove current package from remaining list at the start of each iteration
    remaining_packages=$(echo "${remaining_packages}" | tr ' ' '\n' | grep -vx "${package}" | tr '\n' ' ')
    echo "::group:: ---- build ${package}"
    echo >build.log

    if [ "${GH_ARCH%%-*}" != "noarch" ]; then
        if [ "${package}" == "${PACKAGE_TO_PUBLISH}" ]; then
            echo "$ make ${MAKE_ARGS}arch-${GH_ARCH%%-*}-${GH_ARCH##*-} -C ./spk/${package}" >>build.log
            make ${MAKE_ARGS}arch-${GH_ARCH%%-*}-${GH_ARCH##*-} -C ./spk/${package} |& tee >(tail -15 >>build.log)
        else
            echo "$ make arch-${GH_ARCH%%-*}-${GH_ARCH##*-} -C ./spk/${package}" >>build.log
            make arch-${GH_ARCH%%-*}-${GH_ARCH##*-} -C ./spk/${package} |& tee >(tail -15 >>build.log)
        fi
    else
        if [ "${GH_ARCH}" = "noarch" ]; then
            TCVERSION=
        else
            TCVERSION=${GH_ARCH##*-}
        fi
        # noarch package must be first built then published
        echo "$ make TCVERSION=${TCVERSION} ARCH=noarch -C ./spk/${package}" >>build.log
        make TCVERSION=${TCVERSION} ARCH=noarch -C ./spk/${package} |& tee >(tail -15 >>build.log)

        if [ "${package}" == "${PACKAGE_TO_PUBLISH}" ]; then
            echo "$ make TCVERSION=${TCVERSION} ARCH=noarch -C ./spk/${package} ${MAKE_ARGS%%-}" >>build.log
            make TCVERSION=${TCVERSION} ARCH=noarch -C ./spk/${package} ${MAKE_ARGS%%-} |& tee >(tail -15 >>build.log)
        fi
    fi
    result=$?

    # For a build to succeed a <package>_<arch>-<version>.spk must also be generated
    if [ ${result} -eq 0 ] && [ "$(ls -1 ./packages/$(sed -n -e '/^SPK_NAME/ s/.*= *//p' spk/${package}/Makefile)_*.spk 2>/dev/null)" ]; then
        echo "$(date --date=now +"%Y.%m.%d %H:%M:%S") - ${package}: (${GH_ARCH}) DONE" >> ${BUILD_SUCCESS_FILE}
    # Ensure it's not a false-positive due to pre-check
    elif tail -15 build.log | grep -viq 'spksrc.pre-check.mk'; then
        cat build.log >> ${BUILD_ERROR_LOGFILE}
        echo "$(date --date=now +"%Y.%m.%d %H:%M:%S") - ${package}: (${GH_ARCH}) FAILED" >> ${BUILD_ERROR_FILE}
    fi

    echo "::endgroup::"
done
