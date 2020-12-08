VIRTUALENV="/usr/local/python3/bin/python3 -m venv"

service_postinst ()
{
    # Create a Python virtualenv
    ${VIRTUALENV} ${SYNOPKG_PKGDEST}/env  >> ${INST_LOG} 2>&1

    # Install the wheels
    ${SYNOPKG_PKGDEST}/env/bin/pip3 install --no-deps --no-index -U --force-reinstall -f ${SYNOPKG_PKGDEST}/share/wheelhouse ${SYNOPKG_PKGDEST}/share/wheelhouse/*.whl   >> ${INST_LOG} 2>&1

    ln -sf ${SYNOPKG_PKGDEST}/env/bin/rdiff-backup /usr/local/bin/rdiff-backup  >> ${INST_LOG} 2>&1
    ln -sf ${SYNOPKG_PKGDEST}/env/bin/rdiff-backup-statistics /usr/local/bin/rdiff-backup-statistics  >> ${INST_LOG} 2>&1

    exit 0
}

service_postuninst ()
{
    rm -f /usr/local/bin/rdiff-backup  >> ${INST_LOG} 2>&1
    rm -f /usr/local/bin/rdiff-backup-statistics  >> ${INST_LOG} 2>&1

    exit 0
}
