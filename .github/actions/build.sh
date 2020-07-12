#!/bin/bash

# github action to build the packages depending on changed files
# 
# Functions:
# - Build all packages depending on files defined in ${GH_FILES}.
# - Build for arch defined by ${GH_ARCH} (e.g. x64-6.1, noarch, ...).
# - Successfully built packages are logged to $BUILD_SUCCESS_FILE.
# - Failed builds are logged to ${BUILD_ERROR_FILE} and annotated as error.
# - The build output is structured into log groups by package.
# - As the disk space in the workflow environment is limitted, we clean the 
#   work folder of each package after build. At 2020.06 this limit is 14GB.
# - ffmpeg is not cleaned to be available for dependents.
# - Therefore ffmpeg is built first if triggered by its own or a dependent.

echo "::group:: ---- initialize build"
make setup-synocommunity
sed -i -e "s|#PARALLEL_MAKE=.*|PARALLEL_MAKE=4|" local.mk
echo "::endgroup::"

echo "::group:: ---- find dependent packages"

# filter for changes made in the spk directories and take unique package name (without spk folder)
SPK_TO_BUILD=$(echo "${GH_FILES}" | tr ' ' '\n' | grep -oP "(spk)/\K[^\/]*" | sort -u | tr '\n' ' ')

# filter for changes made in the cross and native directories and take unique package name (including cross or native folder)
DEPENDENT_PACKAGES=$(echo "${GH_FILES}" | tr ' ' '\n' | grep -oP "(cross|native)/[^\/]*" | sort -u | tr '\n' ' ')

# get dependency list
# dependencies in this list include the cross or native folder (i.e. native/python cross/glib)
echo "Building dependency list..."
DEPENDENCY_LIST=
for package in $(find spk/ -maxdepth 1 -type d | cut -c 5- | sort)
do
    DEPENDENCY_LIST+=$(make -s -C spk/${package} dependency-list)$'\n'
done

# search for dependent spk packages
for package in ${DEPENDENT_PACKAGES}
do
    echo "===> Searching for dependent package: ${package}"
    packages=$(echo "${DEPENDENCY_LIST}" | grep -w "${package}" | grep -o ".*:" | tr ':' ' ' | sort -u | tr '\n' ' ')
    echo "===> Found: ${packages}"
    SPK_TO_BUILD+=${packages}
done

# fix for packages with different name
if [ "$(echo ${SPK_TO_BUILD} | grep -ow nzbdrone)" != "" ]; then
    SPK_TO_BUILD+=sonarr
fi

# remove duplicate packages
packages=$(printf %s "${SPK_TO_BUILD}" | tr ' ' '\n' | sort -u | tr '\n' ' ')


# find all packages that depend on spk/ffmpeg is built before.
all_ffmpeg_packages=$(find spk/ -maxdepth 2 -mindepth 2 -name "Makefile" -exec grep -Ho "export FFMPEG_DIR" {} \; | grep -Po ".*spk/\K[^/]*" | sort | tr '\n' ' ')

# if ffmpeg or one of its dependents is to build, ensure 
# ffmpeg is first package in the list of packages to build.
for package in ${packages}
do
    if [ "$(echo ffmpeg ${all_ffmpeg_packages} | grep -ow ${package})" != "" ]; then
        packages_without_ffmpeg=$(echo "${packages}" | tr ' ' '\n' | grep -v "ffmpeg" | tr '\n' ' ')
        packages="ffmpeg ${packages_without_ffmpeg}"
        break;
    fi
done


# find all noarch packages
all_noarch=$(find spk/ -maxdepth 2 -mindepth 2 -name "Makefile" -exec grep -Ho "override ARCH" {} \; | grep -Po ".*spk/\K[^/]*" | sort | tr '\n' ' ')

# separate noarch and arch specific packages 
# and filter out packages that are removed or do not exist (e.g. nzbdrone)
arch_packages=
noarch_packages=
for package in ${packages}
do
    if [ -f "./spk/${package}/Makefile" ]; then
        if [ "$(echo ${all_noarch} | grep -ow ${package})" = "" ]; then
            arch_packages+="${package} "
        else
            noarch_packages+="${package} "
        fi
    fi
done

echo "===> TARGET: ${GH_ARCH}"
echo "===> ARCH   packages: ${arch_packages}"
echo "===> NOARCH packages: ${noarch_packages}"
echo "::endgroup::"

if [ "${GH_ARCH}" = "noarch" ]; then
    build_packages=${noarch_packages}
else
    build_packages=${arch_packages}
fi

echo ""

if [ -z "${build_packages}" ]; then
    echo "===> No packages to build. <==="
    exit 0
fi

echo "===> PACKAGES to Build: ${build_packages}"

# Build
PACKAGES_TO_KEEP="ffmpeg"
for package in ${build_packages}
do
    echo "::group:: ---- build ${package}"

    if [ "${GH_ARCH}" != "noarch" ]; then
        # use TCVERSION and ARCH to get real exit codes.
        make TCVERSION=${GH_ARCH##*-} ARCH=${GH_ARCH%%-*} -C ./spk/${package}
    else
        make -C ./spk/${package}
    fi
    result=$?

    if [ ${result} -eq 0 ];
    then
        echo "$(date --date=now +"%Y.%m.%d %H:%M:%S") - ${package}: (${GH_ARCH}) DONE"   >> ${BUILD_SUCCESS_FILE}
    else
        echo "$(date --date=now +"%Y.%m.%d %H:%M:%S") - ${package}: (${GH_ARCH}) FAILED" >> ${BUILD_ERROR_FILE}
    fi

    if [ "$(echo ${PACKAGES_TO_KEEP} | grep -ow ${package})" = "" ]; then
        # free disk space (but not for packages to keep)
        make -C ./spk/${package} clean
    fi

    echo "::endgroup::"
done
