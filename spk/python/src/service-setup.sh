PATH="${SYNOPKG_PKGDEST}/bin:${PATH}"

service_postinst ()
{
    # Install busybox stuff
    ${SYNOPKG_PKGDEST}/bin/busybox --install ${SYNOPKG_PKGDEST}/bin >> ${INST_LOG}

    # Install the wheels
    ${SYNOPKG_PKGDEST}/bin/pip install --no-deps --no-index -U --force-reinstall -f ${SYNOPKG_PKGDEST}/share/wheelhouse ${SYNOPKG_PKGDEST}/share/wheelhouse/*.whl >> ${INST_LOG}

    # Log installation informations
    ${SYNOPKG_PKGDEST}/bin/python --version >> ${INST_LOG}
    echo "" >> ${SYNOPKG_PKGDEST}/install.log
    echo "System installed modules:" >> ${INST_LOG}
    ${SYNOPKG_PKGDEST}/bin/pip freeze >> ${INST_LOG}

    # Byte-compile in background
    ${SYNOPKG_PKGDEST}/bin/python -m compileall -q -f ${SYNOPKG_PKGDEST}/lib/python2.7 > /dev/null &
    ${SYNOPKG_PKGDEST}/bin/python -OO -m compileall -q -f ${SYNOPKG_PKGDEST}/lib/python2.7 > /dev/null &
}