#!/bin/sh

# Package
PACKAGE="ejabberd"
DNAME="ejabberd"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/usr/bin:${PATH}"
USER="ejabberd"
GROUP="users"


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

    # Correct the files ownership
    chown -R ${USER}:root ${SYNOPKG_PKGDEST}

    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        sed -i -e "s#{hosts, \[\"localhost\"\]}.#{hosts, \[\"${wizard_ejabberd_hostname:=localhost}\"\]}.#g" \
               -e "s#\%\%{acl, admin, {user, \"ermine\", \"example.org\"}}.#{acl, admin, {user, \"${wizard_ejabberd_admin_username:=admin}\", \"${wizard_ejabberd_hostname:=localhost}\"}}.#g" \
               -e "s#{access_createnode, pubsub_createnode},#{access_createnode, pubsub_createnode},\n\t\t  {max_items_node, 1000000},#g" \
               ${INSTALL_DIR}/etc/ejabberd/ejabberd.cfg
        ${SSS} start > /dev/null
        ${INSTALL_DIR}/sbin/ejabberdctl register ${wizard_ejabberd_admin_username:=admin} ${wizard_ejabberd_hostname:=localhost} ${wizard_ejabberd_admin_password}
        ${SSS} stop > /dev/null
    fi

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

    # Save the configuration file
    rm -fr ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}/etc/ejabberd
    mkdir -p ${TMP_DIR}/${PACKAGE}/var/lib/ejabberd
    mv ${INSTALL_DIR}/etc/ejabberd/* ${TMP_DIR}/${PACKAGE}/etc/ejabberd
    mv ${INSTALL_DIR}/var/lib/ejabberd/* ${TMP_DIR}/${PACKAGE}/var/lib/ejabberd

    exit 0
}

postupgrade ()
{
    # Restore the configuration file
    mv ${TMP_DIR}/${PACKAGE}/etc/ejabberd/* ${INSTALL_DIR}/etc/ejabberd
    mv ${TMP_DIR}/${PACKAGE}/var/lib/ejabberd/* ${INSTALL_DIR}/var/lib/ejabberd
    rm -fr ${TMP_DIR}/${PACKAGE}

    exit 0
}
