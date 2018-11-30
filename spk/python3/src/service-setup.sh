PATH="${SYNOPKG_PKGDEST}/bin:$PATH"

service_postinst ()
{
    # Install the wheels
    ${SYNOPKG_PKGDEST}/bin/pip install --no-deps --no-index -U --force-reinstall -f ${SYNOPKG_PKGDEST}/share/wheelhouse ${SYNOPKG_PKGDEST}/share/wheelhouse/*.whl >> ${INST_LOG} 2>&1

    # Log installation informations
    ${SYNOPKG_PKGDEST}/bin/python3 --version >> ${INST_LOG} 2>&1
    echo -e "\nSystem installed modules:" >> ${INST_LOG}
    ${SYNOPKG_PKGDEST}/bin/pip freeze >> ${INST_LOG}

    # Install busybox stuff
    # So pure-Python spk's can use the functions
    ${SYNOPKG_PKGDEST}/bin/busybox --install ${SYNOPKG_PKGDEST}/bin

    # Byte-compile in background
    ${SYNOPKG_PKGDEST}/bin/python3 -m compileall -q -f ${SYNOPKG_PKGDEST}/lib/python3.3 >> ${INST_LOG} &
    ${SYNOPKG_PKGDEST}/bin/python3 -OO -m compileall -q -f ${SYNOPKG_PKGDEST}/lib/python3.3 >> ${INST_LOG} &
}
