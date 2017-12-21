PYTHON_DIR="/usr/local/python"
PATH="${SYNOPKG_PKGDEST}/bin:${SYNOPKG_PKGDEST}/env/bin:${PYTHON_DIR}/bin:${PATH}"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
PYTHON="${SYNOPKG_PKGDEST}/env/bin/python"
SABNZBD="${SYNOPKG_PKGDEST}/share/SABnzbd/SABnzbd.py"
CFG_FILE="${SYNOPKG_PKGDEST}/var/config.ini"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"
LANGUAGE="env LANG=en_US.UTF-8"
SC_GROUP="sc-download"
SC_GROUP_DESC="SynoCommunity's download related group"

syno_group_create ()
{
    # Create syno group
    synogroup --add ${SC_GROUP} ${USER} > /dev/null
    # Set description of the syno group
    synogroup --descset ${SC_GROUP} "${SC_GROUP_DESC}"
    # Add user to syno group
    addgroup ${USER} ${SC_GROUP}
}

syno_group_remove ()
{
    # Remove user from syno group
    delgroup ${USER} ${SC_GROUP}
    # Check if syno group is empty
    if ! synogroup --get ${SC_GROUP} | grep -q "0:"; then
        # Remove syno group
        synogroup --del ${SC_GROUP} > /dev/null
    fi
}

set_syno_permissions ()
{
    # Sets recursive permissions for ${SC_GROUP} on specified directory
    # Usage: set_syno_permissions "${wizard_download_dir}"
    DIRNAME=$1
    VOLUME=`echo $1 | awk -F/ '{print "/"$2}'`
    # Set read/write permissions for SC_GROUP on target directory
    if [ ! "`synoacltool -get "${DIRNAME}"| grep "group:${SC_GROUP}:allow:rwxpdDaARWc--:fd--"`" ]; then
        synoacltool -add "${DIRNAME}" "group:${SC_GROUP}:allow:rwxpdDaARWc--:fd--" > /dev/null 2>&1
    fi
    # Walk up the tree and set traverse permissions up to VOLUME
    DIRNAME="$(dirname "${DIRNAME}")"
    while [ "${DIRNAME}" != "${VOLUME}" ]; do
        if [ ! "`synoacltool -get "${DIRNAME}"| grep "group:${SC_GROUP}:allow:..x"`" ]; then
            synoacltool -add "${DIRNAME}" "group:${SC_GROUP}:allow:--x----------:---n" > /dev/null 2>&1
        fi
        DIRNAME="$(dirname "${DIRNAME}")"
    done
}

service_preinst ()
{
    # Check directory
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        if [ ! -d ${wizard_download_dir:=/volume1/downloads} ]; then
            echo "Download directory ${wizard_download_dir} does not exist."
            exit 1
        fi
    fi
}

service_postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${SYNOPKG_PKGDEST}

    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env > /dev/null

    # Install wheels
    ${SYNOPKG_PKGDEST}/env/bin/pip install --no-deps --no-index -U --force-reinstall -f ${SYNOPKG_PKGDEST}/share/wheelhouse ${SYNOPKG_PKGDEST}/share/wheelhouse/*.whl > /dev/null 2>&1

    # Create download group
    syno_group_create

    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        # Edit the configuration according to the wizard
        sed -i -e "s|@download_dir@|${wizard_download_dir:=/volume1/downloads}|g" ${CFG_FILE}
        # Permissions handling
        set_syno_permissions "${wizard_download_dir:=/volume1/downloads}"
    fi

    # Correct the files ownership
    chown -R ${USER}:root ${SYNOPKG_PKGDEST}
}

service_preuninst ()
{
    # Remove link
    rm -f ${SYNOPKG_PKGDEST}
}

service_postinst ()
{
    # Discard legacy obsolete busybox user account
    BIN=${SYNOPKG_PKGDEST}/bin
    $BIN/busybox --install $BIN
    $BIN/delgroup "${USER}" "users" >> ${INST_LOG}
    $BIN/deluser "${USER}" >> ${INST_LOG}
}

service_preupgrade ()
{
    # Save some stuff
    rm -fr ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}
    mv ${SYNOPKG_PKGDEST}/var ${TMP_DIR}/${PACKAGE}/

    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env > /dev/null

    # Install wheels
    ${SYNOPKG_PKGDEST}/env/bin/pip install --no-deps --no-index -U --force-reinstall -f ${SYNOPKG_PKGDEST}/share/wheelhouse ${SYNOPKG_PKGDEST}/share/wheelhouse/*.whl > /dev/null 2>&1
}

service_postupgrade ()
{
    # Restore some stuff
    rm -fr ${SYNOPKG_PKGDEST}/var
    mv ${TMP_DIR}/${PACKAGE}/var ${SYNOPKG_PKGDEST}/
    rm -fr ${TMP_DIR}/${PACKAGE}

    # Ensure file ownership is correct after upgrade
    chown -R ${USER}:root ${SYNOPKG_PKGDEST}
}
