#!/bin/bash
# List the successfully built, the unsupported and the failed packages
# by name and timestamp.
#
# We do not want to terminate the build on errors as we want to build all
# packages.
# Therfore failed builds are logged in the build error file defined by the
# env variable $BUILD_ERROR_FILE.
# If this file exists and contains at least one line, we exit with error.
# A special log file $BUILD_UNSUPPORTED_FILE contains known make errors that
# are ignore here (unsupported ARCH or version of Toolchain)
# Such packages are separately logged and removed from errors file.
#
# Variables:
# BUILD_SUCCESS_FILE        defines the name of the file with built packages
# BUILD_UNSUPPORTED_FILE    defines the name of the file with unsupported packages
# BUILD_ERROR_FILE          defines the name of the file with build errors
# BUILD_ERROR_LOGFILE       defines the name of the file with last 15 lines of build output for failed packages
# BUILD_REMAINING_FILE      defines the name of the file listing packages not built (build-time budget)
# BUILD_TIMEOUT_FILE        defines the name of the file with the build-time budget stop details
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
        echo "ARTIFACTS:"
        ls -gh --time-style +"%Y.%m.%d %H:%M:%S"  packages/*
        echo ""
    fi
else
    echo "none."
fi

echo ""
echo "UNSUPPORTED (skipped):"
if [ -f "${BUILD_UNSUPPORTED_FILE}" ]; then
    cat "${BUILD_UNSUPPORTED_FILE}" | awk '!seen[$0]++'
    if [ -f "${BUILD_ERROR_FILE}" ]; then
        # remove unsupported packages from errors: capture only the package name
        # (up to the first colon). A greedy ".*:" would also swallow a reason that
        # itself contains a colon -- e.g. "unsupported: glibc ... (a runtime floor:
        # ...)" -- yielding a bogus name that both fails to match the error line and
        # injects the reason's parentheses into the grep -Pv pattern below.
        unsupported_packages=$(cat "${BUILD_UNSUPPORTED_FILE}" | grep -Po "\- \K.*?:" | sort -u | tr '\n' '|' | sed -e 's/|$//')
        cat "${BUILD_ERROR_FILE}" | grep -Pv "\- (${unsupported_packages}) " > "${BUILD_ERROR_FILE}.tmp"
        rm -f "${BUILD_ERROR_FILE}"
        mv "${BUILD_ERROR_FILE}.tmp" "${BUILD_ERROR_FILE}"
    fi
else
    echo "none."
fi

echo ""
echo "NOT PROCESSED (build-time budget reached):"
incomplete=0
if [ -s "${BUILD_REMAINING_FILE}" ]; then
    incomplete=1
    # The package that was actively building when the budget hit (killed mid-build)
    interrupted=
    [ -f "${BUILD_TIMEOUT_FILE}" ] && interrupted=$(sed -n 's/^stopped_during:[[:space:]]*//p' "${BUILD_TIMEOUT_FILE}")
    [ -n "${interrupted}" ] && echo "interrupted (killed mid-build): ${interrupted}"
    echo "not built:"
    cat "${BUILD_REMAINING_FILE}"
    if [ -f "${BUILD_TIMEOUT_FILE}" ]; then
        echo ""
        cat "${BUILD_TIMEOUT_FILE}"
    fi
    echo ""
    echo "::warning::Partial build: $(grep -c . "${BUILD_REMAINING_FILE}") package(s) not processed${interrupted:+, interrupted '${interrupted}' mid-build} (build-time budget). See NOT PROCESSED above."
else
    echo "none (all packages processed)."
fi

echo ""
errors=0
if [ -f "${BUILD_ERROR_FILE}" ]; then
    if [ $(cat "${BUILD_ERROR_FILE}" | wc -l) -gt 0 ]; then
        errors=1
        echo "::error::ERRORS:%0A$(cat ${BUILD_ERROR_FILE} | sed ':a;N;$!ba;s/\n/%0A/g')"
        echo ""
        echo "See log file of the build job to analyze the error(s)."
        echo
        echo "Last 15 lines of the build log:"
        echo
        cat "${BUILD_ERROR_LOGFILE}"
        echo ""
    fi
fi
if [ "${errors}" -eq 0 ]; then
    echo "ERRORS:"
    echo "none."
    echo ""
fi

# Fail the job (red indicator) on real errors OR on an incomplete build
# (build-time budget stopped it), so a partial build is not a misleading green.
if [ "${errors}" -eq 1 ] || [ "${incomplete}" -eq 1 ]; then
    exit 1
fi
