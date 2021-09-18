#!/bin/bash

# Part of github build action
# 
# build the packages depending on evaluated packages (see prepare.sh)
#
# Functions:
# - Build all packages depending on files defined in ${ARCH_PACKAGES} or ${NOARCH_PACKAGES}.
# - Build for arch defined by ${GH_ARCH} (e.g. x64-6.1, noarch, ...).
# - Successfully built packages are logged to $BUILD_SUCCESS_FILE.
# - Failed builds are logged to ${BUILD_ERROR_FILE} and annotated as error.
# - The build output is structured into log groups by package.
# - As the disk space in the workflow environment is limitted, we clean the
#   work folder of each package after build. At 2020.06 this limit is 14GB.
# - ffmpeg is not cleaned to be available for dependents.
# - Therefore ffmpeg is built first if triggered by its own or a dependent (see prepare.sh).

set -o pipefail

echo "::group:: ---- initialize build"
make setup-synocommunity
sed -i -e "s|#PARALLEL_MAKE\s*=.*|PARALLEL_MAKE=max|" \
    -e "s|PUBLISH_API_KEY\s*=.*|PUBLISH_API_KEY=$API_KEY|" \
    local.mk
echo "::endgroup::"

echo "===> TARGET: ${GH_ARCH}"
echo "===> ARCH   packages: ${ARCH_PACKAGES}"
echo "===> NOARCH packages: ${NOARCH_PACKAGES}"

if [ "${GH_ARCH%%-*}" = "noarch" ]; then
    build_packages=${NOARCH_PACKAGES}
else
    build_packages=${ARCH_PACKAGES}
fi

echo ""

if [ -z "${build_packages}" ]; then
    echo "===> No packages to build. <==="
    exit 0
fi

echo "===> PACKAGES to Build: ${build_packages}"

# publish to synocommunity.com when the API key is set
MAKE_ARGS=
if [ -n "$API_KEY" ] && [ "$PUBLISH" == "true" ]; then
    MAKE_ARGS=publish
fi

# Build
PACKAGES_TO_KEEP="ffmpeg"
for package in ${build_packages}
do
    echo "::group:: ---- build ${package}"
    echo >build.log

    if [ "${GH_ARCH%%-*}" != "noarch" ]; then
        # use TCVERSION and ARCH to get real exit codes.
        echo "$ make TCVERSION=${GH_ARCH##*-} ARCH=${GH_ARCH%%-*} -C ./spk/${package}" >>build.log
        make TCVERSION=${GH_ARCH##*-} ARCH=${GH_ARCH%%-*} -C ./spk/${package} ${MAKE_ARGS} |& tee >(tail -15 >>build.log)
    else
        if [ "${GH_ARCH}" = "noarch" ]; then
            TCVERSION=
        else
            TCVERSION=${GH_ARCH##*-}
        fi
        echo "$ make TCVERSION=${TCVERSION} ARCH= -C ./spk/${package}" >>build.log
        make TCVERSION=${TCVERSION} ARCH= -C ./spk/${package} ${MAKE_ARGS} |& tee >(tail -15 >>build.log)
    fi
    result=$?

    if [ ${result} -eq 0 ];
    then
        echo "$(date --date=now +"%Y.%m.%d %H:%M:%S") - ${package}: (${GH_ARCH}) DONE"   >> ${BUILD_SUCCESS_FILE}
    else
        cat build.log >> ${BUILD_ERROR_LOGFILE}
        echo "$(date --date=now +"%Y.%m.%d %H:%M:%S") - ${package}: (${GH_ARCH}) FAILED" >> ${BUILD_ERROR_FILE}
    fi

    if [ "$(echo ${PACKAGES_TO_KEEP} | grep -ow ${package})" = "" ]; then
        # free disk space (but not for packages to keep)
        make -C ./spk/${package} clean
    fi

    echo "::endgroup::"
done
