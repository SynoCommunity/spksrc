#!/bin/bash
# We do not terminate the build on errors as we want to build all packages.
#
# Therfore failed builds are logged in the build error file defined by the 
# env variable $BUILD_ERROR_FILE
# If this file exists and contains at least one line, we show here the content 
# of the file and exit with error.
# Otherwise we show the other file containing the sucessfully built packages.

if [ -f "${BUILD_ERROR_FILE}" ]; then
    if [ $(cat "${BUILD_ERROR_FILE}" | wc -l) -gt 0 ]; then
        cat "${BUILD_ERROR_FILE}"
        echo ""
        echo "Please analyze the log file of the build job."
        exit 1
    fi
fi
if [ -f "${BUILD_SUCCESS_FILE}" ]; then
    cat "${BUILD_SUCCESS_FILE}"
fi
