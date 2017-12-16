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
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"
SERVICETOOL="/usr/syno/bin/servicetool"
BUILDNUMBER="$(/bin/get_key_value /etc.defaults/VERSION buildnumber)"
FWPORTS="/var/packages/${PACKAGE}/scripts/${PACKAGE}.sc"

DSM6_UPGRADE="${INSTALL_DIR}/var/.dsm6_upgrade"
SC_USER="sc-git-server"
LEGACY_USER="git-server"
LEGACY_GROUP="nobody"
USER="$([ "${BUILDNUMBER}" -ge "7321" ] && echo -n ${SC_USER} || echo -n ${LEGACY_USER})"


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

    # Create legacy user
    if [ "${BUILDNUMBER}" -lt "7321" ]; then
        adduser -h ${INSTALL_DIR}/var -g "${DNAME} User" -G ${LEGACY_GROUP} -s /bin/sh -S -D ${LEGACY_USER}
    fi

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
        su - ${LEGACY_USER} -c "${INSTALL_DIR}/bin/gitolite setup -pk admin.pub"
        sed -i -e "s|UMASK                           =>  0077,|UMASK                           =>  0022,|" ${INSTALL_DIR}/var/.gitolite.rc 
    fi

    # Correct the files ownership
    chown -R ${USER}:root ${SYNOPKG_PKGDEST}

    exit 0
}

preuninst ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
        # Remove the user (if not upgrading)
        delgroup ${LEGACY_USER} ${LEGACY_GROUP}
        deluser ${USER}

        # Remove firewall configuration
        ${SERVICETOOL} --remove-configure-file --package ${PACKAGE}.sc >> /dev/null
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

    # DSM6 Upgrade handling
    if [ "${BUILDNUMBER}" -ge "7321" ] && [ ! -f ${DSM6_UPGRADE} ]; then
        echo "Deleting legacy user" > ${DSM6_UPGRADE}
        delgroup ${LEGACY_USER} ${LEGACY_GROUP}
        deluser ${LEGACY_USER}
    fi

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
