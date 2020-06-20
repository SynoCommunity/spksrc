#!/bin/bash

make setup-synocommunity
sed -i -e "s|#PARALLEL_MAKE=.*|PARALLEL_MAKE=4|" local.mk

# filter for changes made in the spk directories and take unique package name
SPK_TO_BUILD=$(echo "$GH_FILES" | tr ' ' '\n' | grep -oP "(spk)/\K[^\/]*" | sort -u | tr '\n' ' ')

# filter for changes made in the cross and native directories and take unique package name
DEPENDENT_PACKAGES=$(echo "$GH_FILES" | tr ' ' '\n' | grep -oP "(cross|native)/[^\/]*" | sort -u | tr '\n' ' ')

# get dependency list
DEPENDENCY_LIST=
echo "Building dependency list..."
for package in $(find spk/ -maxdepth 1 -type d | cut -c 5- | sort)
do
    DEPENDENCY_LIST+=$(make -s -C spk/$package dependency-list)$'\n'
done

# search for dependent spk packages
for package in ${DEPENDENT_PACKAGES}
do
    echo "===> Searching for dependent package: $package"
    packages=$(echo "${DEPENDENCY_LIST}" | grep " ${package} " | grep -o ".*:" | tr ':' ' ' | sort -u | tr '\n' ' ')
    echo "===> Found: $packages"
    SPK_TO_BUILD+=${packages}
done

# remove duplicate packages
packages=$(printf %s "${SPK_TO_BUILD}" | tr ' ' '\n' | sort -u | tr '\n' ' ')

# find all noarch packages
all_noarch=$(find spk/ -maxdepth 2 -mindepth 2 -name "Makefile" -exec grep -Ho "override ARCH" {} \; | grep -Po ".*spk/\K[^/]*" | sort | tr '\n' ' ')

# separate noarch and arch specific packages
arch_packages=
noarch_packages=
for package in ${packages}
do
    if [ "$(echo ${all_noarch} | grep -ow ${package})" = "" ]; then
        arch_packages+="${package} "
    else
        noarch_packages+="${package} "
    fi
done

echo "===> TARGET: ${GH_ARCH}"
echo "===> ARCH   packages: ${arch_packages}"
echo "===> NOARCH packages: ${noarch_packages}"

if [ "${GH_ARCH}" = "noarch" ]; then
    build_packages=${noarch_packages}
else
    build_packages=${arch_packages}
fi

if [ -z "${build_packages}" ]; then
    echo "===> No packages built <==="
    exit 0
fi

echo ""
echo "===> PACKAGES to Build: ${build_packages}"

# Build
for package in ${build_packages}
do
    echo "::group:: ------ build ${package}"
    # make sure that the package exists
    if [ -f "./spk/${package}/Makefile" ]; then
        # use TCVERSION and ARCH to get real exit codes.
        make TCVERSION=${GH_ARCH##*-} ARCH=${GH_ARCH%%-*} -C ./spk/${package}
        result=$?
        
        if [ $result -eq 0 ];
        then
            echo "$(date --date=now +"%Y.%m.%d %H:%M:%S") - $package: ($GH_ARCH) DONE"      >> ${BUILD_SUCCESS_FILE}
        else
            echo "$(date --date=now +"%Y.%m.%d %H:%M:%S") - $package: ($GH_ARCH) FAILED"    >> ${BUILD_ERROR_FILE}
        fi
    else
        echo "spk/${package}/Makefile not found"
    fi
    echo "::endgroup::"
done
