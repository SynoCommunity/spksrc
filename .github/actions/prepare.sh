#!/bin/bash

# Part of github build action
# 
# Evaluate packages to build and referenced source files to download.
#
# Functions:
# - Build all packages defined by ${USER_SPK_TO_BUILD} and ${GH_SPK_PACKAGES}
# - Evaluate additional packages to build depending on changed folders defined in ${GH_DEPENDENT_PACKAGES}.
# - synocli-videodriver is moved to head of packages to build first if triggered by its ffmpeg5-7
# - python310-313 and ffmpeg5-7 are moved to head of remaining packages to build when triggered by its own or a dependent.
# - Referenced native and cross packages of the packages to build are added to the download list.

set -o pipefail

echo "::group:: ---- find dependent packages"

# Generate local.mk to capture DEFAULT_TC
make setup-synocommunity
DEFAULT_TC=$(grep DEFAULT_TC local.mk | cut -f2 -d= | xargs)

# all packages to build from changes or manual definition
SPK_TO_BUILD="${USER_SPK_TO_BUILD} ${GH_SPK_PACKAGES} "

# get dependency list
# dependencies in this list include the cross or native folder (i.e. native/python cross/glib)
echo "Building dependency list..."
DEPENDENCY_LIST=$(make dependency-list 2> /dev/null)

# search for dependent spk packages
for package in ${GH_DEPENDENCY_FOLDERS}
do
    echo "===> Searching for dependent package: ${package}"
    packages=$(echo "${DEPENDENCY_LIST}" | grep " ${package} " | grep -o ".*:" | tr ':' ' ' | sort -u | tr '\n' ' ')
    echo "===> Found: ${packages}"
    SPK_TO_BUILD+=" ${packages}"
done

# fix for packages with different names
if [ "$(echo ${SPK_TO_BUILD} | grep -o ' nzbdrone ')" != "" ]; then
    SPK_TO_BUILD=$(echo "${SPK_TO_BUILD}" | tr ' ' '\n' | grep -v "^nzbdrone$" | tr '\n' ' ')" sonarr3"
fi
if [ "$(echo ${SPK_TO_BUILD} | grep -o ' python ')" != "" ]; then
    SPK_TO_BUILD=$(echo "${SPK_TO_BUILD}" | tr ' ' '\n' | grep -v "^python$" | tr '\n' ' ')" python2"
fi

# remove duplicate packages
packages=$(printf %s "${SPK_TO_BUILD}" | tr ' ' '\n' | sort -u | tr '\n' ' ')

# for ffmpeg v5-7 find all packages that depend on them
for i in {5..7}; do
    ffmpeg_dependent_packages=$(find spk/ -maxdepth 2 -mindepth 2 -name "Makefile" -exec grep -Ho "FFMPEG_PACKAGE = ffmpeg${i}" {} \; | grep -Po ".*spk/\K[^/]*" | sort | tr '\n' ' ')

    # If packages contain a package that depends on ffmpeg (or is ffmpeg),
    # then ensure relevant ffmpeg spk is first in list
    for package in ${packages}
    do
        if [ "$(echo ffmpeg${i} ${ffmpeg_dependent_packages} | grep -ow ${package})" != "" ]; then
            packages_without_ffmpeg=$(echo "${packages}" | tr ' ' '\n' | grep -v "^ffmpeg${i}\$" | tr '\n' ' ')
            packages="ffmpeg${i} ${packages_without_ffmpeg}"
            break
        fi
    done
done

# for synocli-videodriver that ffmpeg v5-7 depends on
videodrv_dependent_packages=$(find spk/ -maxdepth 2 -mindepth 2 -name "Makefile" -exec grep -Ho "spksrc.videodriver.mk" {} \; | grep -Po ".*spk/\K[^/]*" | sort | tr '\n' ' ')

# If packages contain a package that depends on spksrc.videodriver.mk,
# then ensure synocli-videodriver spk is first in list
for package in ${packages}
do
    if [ "$(echo synocli-videodriver ${videodrv_dependent_packages} | grep -ow ${package})" != "" ]; then
        packages_without_videodrv=$(echo "${packages}" | tr ' ' '\n' | grep -v "^synocli-videodriver\$" | tr '\n' ' ')
        packages="synocli-videodriver ${packages_without_videodrv}"
        break
    fi
done

# for python (310, 311, 312, 313) find all packages that depend on them
for py in python310 python311 python312 python313; do
    python_dependent_packages=$(find spk/ -maxdepth 2 -mindepth 2 -name "Makefile" -exec grep -Ho "PYTHON_PACKAGE = ${py}" {} \; | grep -Po ".*spk/\K[^/]*" | sort | tr '\n' ' ')

    # If packages contain a package that depends on python (or is python), then ensure
    # relevant python spk is first in list
    for package in ${packages}
    do
        if [ "$(echo ${py} ${python_dependent_packages} | grep -ow ${package})" != "" ]; then
            packages_without_python=$(echo "${packages}" | tr ' ' '\n' | grep -v "^${py}\$" | tr '\n' ' ')
            packages="${py} ${packages_without_python}"
            break
        fi
    done
done

# find all noarch packages
all_noarch=$(find spk/ -maxdepth 2 -mindepth 2 -name "Makefile" -exec grep -Ho "override ARCH" {} \; | grep -Po ".*spk/\K[^/]*" | sort | tr '\n' ' ')

# separate noarch and arch specific packages
# and filter out packages that are removed or do not exist (e.g. nzbdrone)
arch_packages=
noarch_packages=
has_arch_packages='false'
has_noarch_packages='false'
for package in ${packages}
do
    if [ -f "./spk/${package}/Makefile" ]; then
        if [ "$(echo ${all_noarch} | grep -ow ${package})" = "" ]; then
            arch_packages+="${package} "
            has_arch_packages='true'
        else
            noarch_packages+="${package} "
            has_noarch_packages='true'
        fi
    fi
done

# evaluate packages that require DSM 7.2
min_dsm72_packages=
has_min_dsm72_packages='false'
for package in ${packages}
do
    if [ -f "./spk/${package}/Makefile" ]; then
        if [ "$(grep REQUIRED_MIN_DSM ./spk/${package}/Makefile | cut -d= -f2 | xargs)" = "7.2" ]; then
            min_dsm72_packages+="${package} "
            has_min_dsm72_packages='true'
        fi
    fi
done

if [ "${has_min_dsm72_packages}" = "true" ]; then
    echo "===> Min DSM 7.2 packages found: ${min_dsm72_packages}"
fi

echo "arch_packages=${arch_packages}" >> $GITHUB_OUTPUT
echo "noarch_packages=${noarch_packages}" >> $GITHUB_OUTPUT
echo "has_arch_packages=${has_arch_packages}" >> $GITHUB_OUTPUT
echo "has_noarch_packages=${has_noarch_packages}" >> $GITHUB_OUTPUT
echo "has_min_dsm72_packages=${has_min_dsm72_packages}" >> $GITHUB_OUTPUT

echo "::endgroup::"

if [ -z "${packages}" ]; then
    echo "===> No packages to download. <==="
    echo "download_packages" >> $GITHUB_OUTPUT
else
    echo "===> PACKAGES to download references for: ${packages}"
    DOWNLOAD_LIST=
    for package in ${packages}
    do
        DOWNLOAD_LIST+=$(echo "${DEPENDENCY_LIST}" | grep "^${package}:" | grep -o ":.*" | tr ':' ' ' | sort -u | tr '\n' ' ')
    done
    # remove duplicate downloads
    downloads=$(printf %s "${DOWNLOAD_LIST}" | tr ' ' '\n' | sort -u | tr '\n' ' ')
    echo "download_packages=${downloads}" >> $GITHUB_OUTPUT
fi
