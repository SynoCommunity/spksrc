
PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"

service_postinst ()
{
    # Install the wheels
    wheelhouse=${SYNOPKG_PKGDEST}/share/wheelhouse
    ${SYNOPKG_PKGDEST}/bin/pip install --no-deps --force-reinstall --no-index --find-links ${wheelhouse} ${wheelhouse}/*.whl

    # Log installation informations
    echo "Installed version: $( ${SYNOPKG_PKGDEST}/bin/python --version 2>&1 )"

    echo "Installed modules:"
    ${SYNOPKG_PKGDEST}/bin/pip freeze

    # Install busybox stuff
    # So pure-Python spk's can use the functions
    echo "Install busybox."
    ${SYNOPKG_PKGDEST}/bin/busybox --install ${SYNOPKG_PKGDEST}/bin
    
    # Byte-compile in background
    echo "Start background module compilation."
    ${SYNOPKG_PKGDEST}/bin/python -m compileall -q -f ${SYNOPKG_PKGDEST}/lib/python2.7 </dev/null &>/dev/null &
    ${SYNOPKG_PKGDEST}/bin/python -OO -m compileall -q -f ${SYNOPKG_PKGDEST}/lib/python2.7 </dev/null &>/dev/null &
}

