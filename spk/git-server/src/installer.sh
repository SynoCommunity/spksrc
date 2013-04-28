#!/bin/sh

# Package
PACKAGE="git-server"
DNAME="Git Server"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
GIT_DIR="/usr/local/git"
WEB_DIR="/var/services/web"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/sbin:${GIT_DIR}/bin:${PATH}"
USER="git-server"
GROUP="nobody"

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

    # Install the web interface
    cp -R ${GIT_DIR}/share/gitweb ${WEB_DIR}
    rm -f ${WEB_DIR}/gitweb/gitweb_config.perl
    cp ${INSTALL_DIR}/etc/gitweb_config.perl ${WEB_DIR}/gitweb/gitweb_config.perl
    rm -fr ${WEB_DIR}/gitweb/static/
    cp -R ${INSTALL_DIR}/share/gitweb/static/ ${WEB_DIR}/gitweb/static

    # Configure rewrite rules
    ln -s ${INSTALL_DIR}/etc/gitweb.conf /usr/syno/etc/sites-enabled-user/gitweb.conf

    # Generate keys
    dropbearkey -t rsa -f ${INSTALL_DIR}/var/dropbear_rsa_host_key > /dev/null 2>&1
    dropbearkey -t dss -f ${INSTALL_DIR}/var/dropbear_dss_host_key > /dev/null 2>&1

    # Setup gitolite
    if [ ! -z "${wizard_public_key}" ]; then
        echo "${wizard_public_key}" > ${INSTALL_DIR}/var/admin.pub
        ${INSTALL_DIR}/share/gitolite/install -to ${INSTALL_DIR}/bin
        su - ${USER} -c "${INSTALL_DIR}/bin/gitolite setup -pk admin.pub"
    fi

    # Correct the files ownership
    chown -R ${USER}:root ${SYNOPKG_PKGDEST}

    exit 0
}

preuninst ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    # Remove the user
    if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" ]; then
        delgroup ${USER} ${GROUP}
        deluser ${USER}
    fi

    exit 0
}

postuninst ()
{
    # Remove link
    rm -f ${INSTALL_DIR}

    # Remove rewrite rules
    rm -f /usr/syno/etc/sites-enabled-user/gitweb.conf

    # Remove the web interface
    rm -fr ${WEB_DIR}/${PACKAGE}

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
