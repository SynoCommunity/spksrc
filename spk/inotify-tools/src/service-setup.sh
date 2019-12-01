
BIN_COMMANDS="inotifywait inotifywatch"
LIBRARY="libinotifytools.so"
LIBRARY_MAIN_VERSION="0"
LIBRARY_SUB_VERSION="4.1"
LIBRARY_WITH_VERSION="${LIBRARY}.${LIBRARY_MAIN_VERSION}.${LIBRARY_SUB_VERSION}"

service_postinst ()
{
    for cmd in $BIN_COMMANDS
    do
        if [ -e "${SYNOPKG_PKGDEST}/bin/$cmd" ]; then
            ln -s "${SYNOPKG_PKGDEST}/bin/$cmd" "/usr/local/bin/$cmd"
        fi
    done
}

service_postuninst ()
{
    for cmd in $BIN_COMMANDS
    do
        if [ -L "/usr/local/bin/$cmd" ]; then
            rm -f "/usr/local/bin/$cmd"
        fi
    done
}

