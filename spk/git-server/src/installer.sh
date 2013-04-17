#!/bin/sh

# Package
PACKAGE="git-server"
DNAME="Git Server"
SYNOPKG_TEMP_LOGFILE="/volume1/@tmp/git-server-installer.log"

# Others
USER="git"
GROUP="users"
INSTALL_DIR="/usr/local/${PACKAGE}"
GIT_DIR="/usr/local/git"
PID_FILE="${INSTALL_DIR}/var/run/git-daemon.pid"
LOG_FILE="${INSTALL_DIR}/var/log/git-daemon.log"
GIT_HOME="${INSTALL_DIR}/var/home"
BASE_PATH="${INSTALL_DIR}/var/repositories"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"

preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}
    #ln -s ${SYNOPKG_PKGDEST}/bin/git /usr/bin/
    #ln -s ${SYNOPKG_PKGDEST}/bin/git /usr/bin/git-receive-pack
    #ln -s ${SYNOPKG_PKGDEST}/bin/git-upload-pack /usr/bin/

    # Install busybox stuff
    ${GIT_DIR}/bin/busybox --install ${INSTALL_DIR}/bin

    # Create user
    ${GIT_DIR}/bin/adduser -h ${GIT_HOME} -g "${DNAME} User" -G ${GROUP} -s /bin/ash -S -D ${USER}
    #synouser --add ${USER} "${RANDOM}${RANDOM}" "${DNAME} User" 0 "" 0
    # Change the user's shell and make a copy of /etc/passwd
    #sed '/git/s!\(.*:\).*!\1\/bin/sh!' /etc/passwd > ${INSTALL_DIR}/tmp/passwd.new
    #cp /etc/passwd ${INSTALL_DIR}/tmp/passwd.original
    #if [ `grep git.*/bin/sh /etc/passwd |wc -l` -eq 0 ]; then
    #    cp ${INSTALL_DIR}/tmp/passwd.new /etc/passwd
    #    chmod 644 /etc/passwd
    #    chown root:root /etc/passwd
    #fi

    # Set PATH and create authorized_keys file
    #mkdir ${BASE_PATH}
    #mkdir ${GIT_HOME}
    mkdir -p ${GIT_HOME}/.ssh/
    #touch ${GIT_HOME}/.ssh/environment
    #touch ${GIT_HOME}/.ssh/authorized_keys
    echo "export PATH=${GIT_DIR}/bin:${INSTALL_DIR}/bin:${INSTALL_DIR}/bin/gitolite:$PATH" >> ${GIT_HOME}/.profile
    #echo "PATH=${INSTALL_DIR}/bin:$PATH" >> ${GIT_HOME}/.ssh/environment

    # Create keys for dropbear
    ${INSTALL_DIR}/bin/dropbearkey -t rsa -f ${INSTALL_DIR}/etc/dropbear_rsa_host_key
    ${INSTALL_DIR}/bin/dropbearkey -t dss -f ${INSTALL_DIR}/etc/dropbear_dss_host_key

    # Gitweb config
    ln -s ${INSTALL_DIR}/etc/gitweb_config.perl ${GIT_DIR}/share/gitweb/gitweb_config.perl

    # Gitweb theme
    if [ ! -L ${GIT_DIR}/share/gitweb/static ]; then
        mv ${GIT_DIR}/share/gitweb/static/ ${GIT_DIR}/share/gitweb/static.orig/
        ln -s ${INSTALL_DIR}/share/gitweb/static/ ${GIT_DIR}/share/gitweb/static
    fi

    # Correct the files ownership
    chown -R ${USER}:root ${SYNOPKG_PKGDEST}
    chmod -R 755 ${SYNOPKG_PKGDEST}
    chown -R ${USER}:root ${GIT_HOME}
    chmod -R 700 ${GIT_HOME}/.ssh/
    chown -R ${USER}:root ${GIT_DIR}/share/gitweb/static/

    # Gitolite setup
    mkdir ${INSTALL_DIR}/bin/gitolite/
    echo "${wizard_public_key}" > ${GIT_HOME}/admin.pub
    su - ${USER} -c "${INSTALL_DIR}/share/gitolite/install -to ${INSTALL_DIR}/bin/gitolite/"
    su - ${USER} -c "${INSTALL_DIR}/bin/gitolite/gitolite setup -pk admin.pub"
    sed -i -e "s|UMASK                           =>  0077,|UMASK                           =>  0022,|" ${INSTALL_DIR}/var/home/.gitolite.rc

    exit 0
}

preuninst ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    # Remove the user (if not upgrading)
    if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
        ${INSTALL_DIR}/bin/delgroup ${USER} ${GROUP}
        ${INSTALL_DIR}/bin/deluser ${USER}
        synouser --del git
    fi

    exit 0
}

postuninst ()
{
    # Remove links
    rm -f ${INSTALL_DIR}
    #rm -f /var/services/web/git
    #rm -f /usr/bin/git
    #rm -f /usr/bin/git-upload-pack
    #rm -f /usr/bin/git-receive-pack

    # Gitweb config
    rm ${GIT_DIR}/share/gitweb/gitweb_config.perl

    # Gitweb theme
    rm -f ${GIT_DIR}/share/gitweb/static
    mv ${GIT_DIR}/share/gitweb/static.orig/ ${GIT_DIR}/share/gitweb/static/

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
    mv ${INSTALL_DIR}/etc ${TMP_DIR}/${PACKAGE}/

    exit 0
}

postupgrade ()
{
    # Restore some stuff
    rm -fr ${INSTALL_DIR}/var
    rm -fr ${INSTALL_DIR}/etc
    mv ${TMP_DIR}/${PACKAGE}/var ${INSTALL_DIR}/
    mv ${TMP_DIR}/${PACKAGE}/etc ${INSTALL_DIR}/
    rm -fr ${TMP_DIR}/${PACKAGE}

    exit 0
}
