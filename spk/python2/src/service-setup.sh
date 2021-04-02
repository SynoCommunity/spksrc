
PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"

service_postinst ()
{
    # Install the wheels
    wheelhouse=${SYNOPKG_PKGDEST}/share/wheelhouse
    ${SYNOPKG_PKGDEST}/bin/pip install --no-deps --force-reinstall --no-index --find-links ${wheelhouse} ${wheelhouse}/*.whl | install_log

    # Log installation informations
    install_log "Installed version: $( ${SYNOPKG_PKGDEST}/bin/python --version 2>&1 )"

    install_log "Installed modules:"
    ${SYNOPKG_PKGDEST}/bin/pip freeze | install_log

    # Install busybox stuff
    # So pure-Python spk's can use the functions
    install_log "Install busybox."
    ${SYNOPKG_PKGDEST}/bin/busybox --install ${SYNOPKG_PKGDEST}/bin | install_log

    # Byte-compile in background
    install_log "Start background module compilation."
    ${SYNOPKG_PKGDEST}/bin/python -m compileall -q -f ${SYNOPKG_PKGDEST}/lib/python2.7 </dev/null &>/dev/null &
    ${SYNOPKG_PKGDEST}/bin/python -OO -m compileall -q -f ${SYNOPKG_PKGDEST}/lib/python2.7 </dev/null &>/dev/null &
}

