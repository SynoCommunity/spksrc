#!/bin/sh

# Package
PACKAGE="git"
DNAME="Git"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
#SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PATH="${INSTALL_DIR}/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/syno/sbin:/usr/syno/bin"
USER="git"
GROUP="users"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"

preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Install busybox stuff (Needed by adduser command)
    ${INSTALL_DIR}/bin/busybox --install ${INSTALL_DIR}/bin

    # Link some git binaries 
    ln -s ${INSTALL_DIR}/bin/git* /bin/

    # Create the git repo directory and the .ssh directory too
    mkdir -p `servicetool --get-alive-volume`/git-repositories/.ssh
    touch `servicetool --get-alive-volume`/git-repositories/.ssh/authorized_keys
    
    # Link the git repo in the app var directory
    ln -s `servicetool --get-alive-volume`/git-repositories ${INSTALL_DIR}/var

    # Create the user
    adduser -h ${INSTALL_DIR}/var -g "${DNAME} User" -G ${GROUP} -s /bin/sh -S -D ${USER}

    # Correct the files ownership
    chown -R ${USER}: `servicetool --get-alive-volume`/git-repositories
    
    # Append some config authentification in /etc/sshd/sshd_config
    # It's crappy ? I know...
    count=`grep "Match User git" sshd_config | wc -l`
    if [ $count -eq 0 ] 
    then
        echo "Match User git" >> /etc/ssh/sshd_config
        echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
        echo "AuthorizedKeysFile     .ssh/authorized_keys" >> /etc/ssh/sshd_config
    fi

    exit 0
}

preuninst ()
{
    exit 0
}

postuninst ()
{
    # Remove link
    rm -f ${INSTALL_DIR}
    # Remove git link
    rm /bin/git*

    exit 0
}

preupgrade ()
{
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
