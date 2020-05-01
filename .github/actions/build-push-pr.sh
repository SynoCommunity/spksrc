#!/bin/bash

cat <<EOF > local.mk
PUBLISH_URL=https://api.synocommunity.com
PUBLISH_API_KEY=
MAINTAINER?=
MAINTAINER_URL=
DISTRIBUTOR=SynoCommunity
DISTRIBUTOR_URL=https://synocommunity.com/
REPORT_URL=https://github.com/SynoCommunity/spksrc/issues
SUPPORT_URL=https://github.com/SynoCommunity/spksrc/issues
DEFAULT_TC=6.1
PARALLEL_MAKE=4
EOF


# get dependency tree
DEPENDENCY_TREE=

echo "Building dependency tree..."
for package in $(find spk/ -maxdepth 1 -type d | cut -c 5- | sort)
do
    pushd "spk/$package" > /dev/null || exit
    DEPENDENCY_TREE+=$(make dependency-tree)$'\n'
    popd > /dev/null || exit
done


# filter for changes made in the cross and spk directories
GH_FILES=$(echo "$GH_FILES" | grep -oE "(spk.*)|(cross.*)")

echo "FILES: $GH_FILES"

# create array of potential packages where files have changed
GH_PACKAGES_ARR=()
for file in $GH_FILES
do
    # Add spk
    # remove leading spk from string
    if [[ "$file" == spk/* ]]; then
        package=${file#spk/}
        # get package name / folder name
        package=$(echo "$package" | grep -oE "^[^\/]*")
        GH_PACKAGES_ARR+=("$package")
    fi

    # Find dependencies
    # remove leading spk/cross/native from string
    file=${file#spk/}
    file=${file#cross/}
    file=${file#native/}
    # get package name / folder name
    package=$(echo "$file" | grep -oE "^[^\/]*")
    echo "package: $package"
    packages=$(echo "$DEPENDENCY_TREE" \
        | awk -v package="$package" \
        'NF == 2 {x=$2} $2 == package {print x}' \
         | sort -u)

    echo "awk: $packages"

    for package in $packages
    do
        GH_PACKAGES_ARR+=("$package")
    done

done

# de-duplicate packages
packages=$(printf %s "${GH_PACKAGES_ARR[*]}" | tr ' ' '\n' | sort -u)

if [ -z "$packages" ]; then
    echo "no package built. Empty PACKAGES var"
    exit 0
fi

echo "===> PACKAGES to Build: $packages"

# Build
for package in $packages
do
    # make sure that the package exists
    if [ -d "spk/$package" ]; then
        cd spk/"$package" && make "$GH_ARCH"
    else
        echo "$package is not found"
    fi
done
