#!/bin/bash
# List the successfully built, the unsupported and the failed packages 
# by name an timestamp.
# 
# We do not want to terminate the build on errors as we want to build all 
# packages.
# Therfore failed builds are logged in the build error file defined by the 
# env variable $BUILD_ERROR_FILE
# If this file exists and contains at least one line, we exit with error.
# A special log file $BUILD_UNSUPPORTED_FILE contains known make errors that
# are ignore here (unsupported ARCH or version of Toolchain)
# Such packages are separately logged and removed from errors file.
#
# Variables:
# BUILD_SUCCESS_FILE        defines the name of the file with built packages
# BUILD_UNSUPPORTED_FILE    defines the name of the file with unsupported packages
# BUILD_ERROR_FILE          defines the name of the file with build errors
#

echo ""
echo "BUILD STATUS"
echo ""

echo "SUCCESS:"
if [ -f "${BUILD_SUCCESS_FILE}" ]; then
    cat "${BUILD_SUCCESS_FILE}"
    if [ -d packages ]; then
        # show built package files
        echo ""
        ls -gh --time-style +"%Y.%m.%d %H:%M:%S"  packages/*
        echo ""
    fi
else
    echo "none."
fi

echo ""
echo "UNSUPPORTED (skipped):"
if [ -f "${BUILD_UNSUPPORTED_FILE}" ]; then
    cat "${BUILD_UNSUPPORTED_FILE}"
    if [ -f "${BUILD_ERROR_FILE}" ]; then
        # remove unsupported packages from errors:
        unsupported_packages=$(cat "${BUILD_UNSUPPORTED_FILE}" | grep -Po "\- \K.*:" | sort -u | tr '\n' '|' | sed -e 's/|$//')
        cat "${BUILD_ERROR_FILE}" | grep -Pv "\- (${unsupported_packages}) " > "${BUILD_ERROR_FILE}.tmp"
        rm -f "${BUILD_ERROR_FILE}"
        mv "${BUILD_ERROR_FILE}.tmp" "${BUILD_ERROR_FILE}"
    fi
else
    echo "none."
fi

echo ""
echo "ERRORS:"
if [ -f "${BUILD_ERROR_FILE}" ]; then
    if [ $(cat "${BUILD_ERROR_FILE}" | wc -l) -gt 0 ]; then
        cat "${BUILD_ERROR_FILE}"
        echo ""
        echo "See log file of the build job to analyze the error(s)."
        echo ""
        # let build status job fail
        exit 1
    fi
fi
echo "none."
echo ""
