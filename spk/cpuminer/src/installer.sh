#!/bin/sh

# Package
PACKAGE="cpuminer"
DNAME="CPUMiner"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PATH="${INSTALL_DIR}/bin:${PATH}"
USER="cpuminer"
GROUP="users"
CFG_FILE="${INSTALL_DIR}/var/settings.json"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"


preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Install busybox stuff
    ${INSTALL_DIR}/bin/busybox --install ${INSTALL_DIR}/bin

    # Create user
    adduser -h ${INSTALL_DIR}/var -g "${DNAME} User" -G ${GROUP} -s /bin/sh -S -D ${USER}

    # Edit the configuration according to the wizard
    sed -i -e "s|@wizard_pool_url@|${wizard_pool_url:=stratum+tcp://stratum.mining.eligius.st:3334}|g" ${CFG_FILE}
    sed -i -e "s|@wizard_pool_username@|${wizard_pool_username:=16acB7MK2iiHRVoUmK3W7eFtTBicJ85m7B}|g" ${CFG_FILE}
    sed -i -e "s|@wizard_pool_password@|${wizard_pool_password}|g" ${CFG_FILE}
    sed -i -e "s|@wizard_threads_number@|${wizard_threads_number:=1}|g" ${CFG_FILE}
    
    if [ ${wizard_use_bitcoin} == "true" ]; then
        sed -i -e "s|@wizard_pool_algo@|sha256d|g" ${CFG_FILE}
    else
        sed -i -e "s|@wizard_pool_algo@|scrypt|g" ${CFG_FILE}
    fi

    # Correct the files ownership
    chown -R ${USER}:users ${SYNOPKG_PKGDEST}

    exit 0
}

preuninst ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    # Remove the user (if not upgrading)
    if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
        delgroup ${USER} ${GROUP}
        deluser ${USER}
    fi

    exit 0
}

postuninst ()
{
    # Remove link
    rm -f ${INSTALL_DIR}

    exit 0
}

preupgrade ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    # Save some stuff
    rm -fr ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}
    mv ${INSTALL_DIR}/var ${TMP_DIR}/${PACKAGE}/

    exit 0
}

postupgrade ()
{
    # Restore some stuff
    rm -fr ${INSTALL_DIR}/var
    mv ${TMP_DIR}/${PACKAGE}/var ${INSTALL_DIR}/
    rm -fr ${TMP_DIR}/${PACKAGE}

    exit 0
}
