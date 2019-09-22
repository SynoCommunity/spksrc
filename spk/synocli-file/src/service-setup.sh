COMMANDS="jdupes less lessecho lesskey tree rhash rnm nano rnano ncdu file detox rmlint"
RHASH_COMMAND_LINKS="ed2k-link edonr256-hash edonr512-hash gost-hash has160-hash magnet-link sfv-hash tiger-hash tth-hash whirlpool-hash"
MC_COMMAND_LINKS="mc mcedit mcdiff mcview"

service_postinst ()
{
    for cmd in $COMMANDS
    do
        if [ -e "${SYNOPKG_PKGDEST}/bin/$cmd" ]; then
            ln -s "${SYNOPKG_PKGDEST}/bin/$cmd" "/usr/local/bin/$cmd"
        fi
    done
    
    # Set custom links for rhash
    if [ -e "${SYNOPKG_PKGDEST}/bin/rhash" ]; then
        for cmd in $RHASH_COMMAND_LINKS
        do
            ln -s "${SYNOPKG_PKGDEST}/bin/rhash" "/usr/local/bin/$cmd"
        done
    fi

    # Set custom links for midnight commander
    if [ -e "${SYNOPKG_PKGDEST}/bin/mc-utf8" ]; then
        for cmd in $MC_COMMAND_LINKS
        do
            ln -s "${SYNOPKG_PKGDEST}/bin/mc-utf8" "/usr/local/bin/$cmd"
        done
    fi
}

service_postuninst ()
{
    # remove links created by this package only
    
    for cmd in $COMMANDS
    do
        if [ -e "/usr/local/bin/$cmd" ]; then
            if [ "$(readlink /usr/local/bin/$cmd)" == "${SYNOPKG_PKGDEST}/bin/$cmd" ]; then
                rm -f "/usr/local/bin/$cmd"
            fi
        fi
    done

    # Remove custom links for rhash
    for cmd in $RHASH_COMMAND_LINKS
    do
        if [ -e "/usr/local/bin/$cmd" ]; then
            if [ "$(readlink /usr/local/bin/$cmd)" == "${SYNOPKG_PKGDEST}/bin/rhash" ]; then
                rm -f "/usr/local/bin/$cmd"
            fi
        fi
    done

    # Remove custom links for midnight commander
    for cmd in $MC_COMMAND_LINKS
    do
        if [ -e "/usr/local/bin/$cmd" ]; then
            if [ "$(readlink /usr/local/bin/$cmd)" == "${SYNOPKG_PKGDEST}/bin/mc-utf8" ]; then
                rm -f "/usr/local/bin/$cmd"
            fi
        fi
    done
}
