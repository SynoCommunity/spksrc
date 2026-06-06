# -----------------------------------------------------------------------------
# DEBUG start-up script (shipped only for GCC_DEBUG_INFO=1 builds).
#
# Identical to src/service-setup.sh, plus an optional gdb crash-backtrace mode.
# Keep the common section and service_postinst/service_postupgrade in sync with
# src/service-setup.sh (the release variant) -- only the gdb bits differ here.
# -----------------------------------------------------------------------------

# Define python binary path
PYTHON_DIR="/var/packages/python314/target/bin"
# Define ffmpeg binary path
FFMPEG_DIR="/var/packages/ffmpeg7/target/bin"
# Add local bin, virtualenv along with ffmpeg and python to the default PATH
PATH="${SYNOPKG_PKGDEST}/env/bin:${SYNOPKG_PKGDEST}/bin:${PYTHON_DIR}:${FFMPEG_DIR}:${PATH}"

# Service configuration. Change http and htsp ports here and in conf/tvheadend.sc for non-standard ports
HTTP=9981
HTSP=9982

# Replace generic service startup, run service in background
GRPN=$(id -gn ${EFF_USER})
UPGRADE_CFG_DIR="${SYNOPKG_PKGVAR}/dvr/config"

TVH_BIN="${SYNOPKG_PKGDEST}/bin/tvheadend"
GDB_BIN="/usr/local/bin/gdb"

# Group configuration to manage permissions of recording folders
GROUP=sc-media

# Base arguments
TVH_BASE_ARGS="-C -u ${EFF_USER} -g ${GRPN} \
    --http_port ${HTTP} --htsp_port ${HTSP} \
    -c ${SYNOPKG_PKGVAR} \
    -p ${PID_FILE} \
    -l ${LOG_FILE} \
    --nobackup"

# --debug subsystems used when running under gdb
TVH_DEBUG_ARGS="--debug transcode,libav,codec,profile,subscription,tsfix,parser,TS,service"

# GDB crash-backtrace mode, toggled by a flag file (no rebuild needed):
#   touch /var/packages/tvheadend/var/gdb-debug.flag   # enable
#   rm    /var/packages/tvheadend/var/gdb-debug.flag   # disable
GDB_FLAG="${SYNOPKG_PKGVAR}/gdb-debug.flag"

# Wrap tvheadend in gdb: write a gdb command script that logs a full backtrace on
# SIGABRT/SIGSEGV, then echo the launch command. Factored out to keep the start
# logic below readable/maintainable. Always called via $(...) so these plain
# variables stay scoped to the command-substitution subshell (no POSIX `local`).
tvh_gdb_command ()
{
    dir="${SYNOPKG_PKGVAR}/gdb-debug"
    log="${dir}/gdb-live.log"
    cmd="${dir}/gdb-commands.gdb"
    solib="${SYNOPKG_PKGDEST}/lib:/var/packages/synocli-videodriver/target/lib:/var/packages/ffmpeg7/target/lib:/lib:/usr/lib"
    mkdir -p "${dir}"
    cat > "${cmd}" << GDBEOF
set pagination off
set logging file ${log}
set logging overwrite on
set logging redirect on
set logging enabled on
set solib-search-path ${solib}
handle SIGABRT stop print nopass
handle SIGSEGV stop print nopass
catch signal SIGABRT
catch signal SIGSEGV
run ${TVH_BASE_ARGS} ${TVH_DEBUG_ARGS}
bt full
thread apply all bt full
set logging enabled off
quit
GDBEOF
    echo "${GDB_BIN} -x ${cmd} --args ${TVH_BIN} ${TVH_BASE_ARGS} ${TVH_DEBUG_ARGS}"
}

# gdb mode only if the flag is set AND a usable gdb is present (-x follows a
# symlink and requires the target to be executable, so it covers both a direct
# binary and a symlink, and rejects a dangling link).
if [ -f "${GDB_FLAG}" ] && [ -x "${GDB_BIN}" ]; then
    # Run under gdb (no -f / no daemon fork, so gdb keeps direct control of the process)
    SVC_WAIT_TIMEOUT=120
    SVC_BACKGROUND=yes
    SVC_WRITE_PID=yes
    SERVICE_COMMAND="$(tvh_gdb_command)"
else
    if [ -f "${GDB_FLAG}" ]; then
        echo "tvheadend: gdb-debug.flag is set but no usable gdb at ${GDB_BIN} -- starting normally"
    fi
    SVC_BACKGROUND=yes
    # -f = fork/daemon mode
    TVH_ARGS="-f ${TVH_BASE_ARGS}"
    SERVICE_COMMAND="${TVH_BIN} ${TVH_ARGS}"
fi


service_postinst ()
{
    # Create a Python virtualenv and install wheel (EPG Grabber)
    install_python_virtualenv
    install_python_wheels
}

service_postupgrade ()
{
    # Need to enforce correct permissions for recording directories on upgrades
    echo "Adding ${GROUP} group permissions on recording directories:"
    for file in ${UPGRADE_CFG_DIR}/*
    do
        DVR_DIR=$(grep -e 'storage\":' ${file} | awk -F'"' '{print $4}')
        # Exclude directories in @appstore as ACL permissions skew up package installations
        TRUNC_DIR=$(echo "$(realpath ${DVR_DIR})" | awk -F/ '{print "/"$3}')
        if [ "${TRUNC_DIR}" = "/@appstore" ]; then
            echo "Skip: ${DVR_DIR} (system directory)"
        elif [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ]; then
            echo "Done: ${DVR_DIR}"
            set_syno_permissions "${DVR_DIR}" "${GROUP}"
        fi
    done

    # For backwards compatibility, restore ownership of package system directories
    if [ $SYNOPKG_DSM_VERSION_MAJOR -lt 7 ]; then
        echo "Restore '${EFF_USER}' unix permissions on package system directories"
        chown ${EFF_USER}:${USER} "${SYNOPKG_PKGDEST}"
        set_unix_permissions "${SYNOPKG_PKGVAR}"
    fi
}
