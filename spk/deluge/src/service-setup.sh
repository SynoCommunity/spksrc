PYTHON_DIR="/usr/local/python"
PATH="${SYNOPKG_PKGDEST}/bin:${SYNOPKG_PKGDEST}/env/bin:${PYTHON_DIR}/bin:${PATH}"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
PYTHON="${SYNOPKG_PKGDEST}/env/bin/python"
CFG_FILE="${SYNOPKG_PKGDEST}/var/core.conf"

GROUP="sc-download"

service_preinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        if [ ! -d "${wizard_download_dir}" ]; then
            echo "Download directory ${wizard_download_dir} does not exist."
            exit 1
        fi
        if [ -n "${wizard_watch_dir}" -a ! -d "${wizard_watch_dir}" ]; then
            echo "Watch directory ${wizard_watch_dir} does not exist."
            exit 1
        fi
        if [ -n "${wizard_complete_dir}" -a ! -d "${wizard_complete_dir}" ]; then
            echo "Complete directory ${wizard_complete_dir} does not exist."
            exit 1
        fi
    fi
}

service_postinst ()
{
    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env >> ${INST_LOG}

    # Install the wheels/requirements
    ${SYNOPKG_PKGDEST}/env/bin/pip install --no-deps --no-index -U --force-reinstall -f ${SYNOPKG_PKGDEST}/share/wheelhouse ${SYNOPKG_PKGDEST}/share/wheelhouse/*.whl >> ${INST_LOG}  2>&1

    # Install Deluge
    export PYTHON_EGG_CACHE=${SYNOPKG_PKGDEST}/env/cache && cd ${SYNOPKG_PKGDEST}/share/deluge && ${PYTHON} setup.py build >> ${INST_LOG} 2>&1 && ${PYTHON} setup.py install >> ${INST_LOG} 2>&1

    # Correct permissions, otherwise Deluge can't write to cache
    set_unix_permissions "${SYNOPKG_PKGDEST}/env"

    # Edit the configuration according to the wizard
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        sed -i -e "s|@download_dir@|${wizard_download_dir:=/volume1/downloads}|g" ${CFG_FILE}
        if [ -d "${wizard_watch_dir}" ]; then
            sed -i -e "s|@watch_dir_enabled@|true|g" ${CFG_FILE}
            sed -i -e "s|@watch_dir@|${wizard_watch_dir}|g" ${CFG_FILE}
        else
            sed -i -e "s|@watch_dir_enabled@|false|g" ${CFG_FILE}
            sed -i -e "/@watch_dir@/d" ${CFG_FILE}
        fi
        if [ -d "${wizard_complete_dir}" ]; then
            sed -i -e "s|@complete_dir_enabled@|true|g" ${CFG_FILE}
            sed -i -e "s|@complete_dir@|${wizard_complete_dir}|g" ${CFG_FILE}
        else
            sed -i -e "s|@complete_dir_enabled@|false|g" ${CFG_FILE}
            sed -i -e "/@complete_dir@/d" ${CFG_FILE}
        fi
    fi

    # Discard legacy obsolete busybox user account
    # Commands of busybox from spk/python
    delgroup "${USER}" "users" >> ${INST_LOG}
    deluser "${USER}" >> ${INST_LOG}
}


service_postupgrade ()
{
    # Needed to force correct permissions, during update
    # Extract the right paths from config file
    if [ -r "${CFG_FILE}" ]; then
        DOWNLOAD_DIR=`sed -n 's/.*"download_location"[ ]*:[ ]*"\(.*\)",/\1/p' ${CFG_FILE}`
        COMPLETE_DIR=`sed -n 's/.*"move_completed_path"[ ]*:[ ]*"\(.*\)",/\1/p' ${CFG_FILE}`
        WATCHED_DIR=`sed -n 's/.*"autoadd_location"[ ]*:[ ]*"\(.*\)",/\1/p' ${CFG_FILE}`

        # Apply permissions
        if [ -n "${DOWNLOAD_DIR}" ] && [ -d "${DOWNLOAD_DIR}" ]; then
            set_syno_permissions "${DOWNLOAD_DIR}" "${GROUP}"
        fi
        if [ -n "${COMPLETE_DIR}" ] && [ -d "${COMPLETE_DIR}" ]; then
            set_syno_permissions "${COMPLETE_DIR}" "${GROUP}"
        fi
        if [ -n "${WATCHED_DIR}" ] && [ -d "${WATCHED_DIR}" ]; then
            set_syno_permissions "${WATCHED_DIR}" "${GROUP}"
        fi
    fi
}
