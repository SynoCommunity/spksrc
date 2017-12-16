#!/bin/sh

# Package
PACKAGE="ejabberd"
DNAME="ejabberd"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/usr/bin:${PATH}"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"
SERVICETOOL="/usr/syno/bin/servicetool"
BUILDNUMBER="$(/bin/get_key_value /etc.defaults/VERSION buildnumber)"
FWPORTS="/var/packages/${PACKAGE}/scripts/${PACKAGE}.sc"

DSM6_UPGRADE="${INSTALL_DIR}/var/.dsm6_upgrade"
SC_USER="sc-ejabberd"
LEGACY_USER="ejabberd"
LEGACY_GROUP="users"
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

    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        sed -i -e "s#{hosts, \[\"localhost\"\]}.#{hosts, \[\"${wizard_ejabberd_hostname:=localhost}\"\]}.#g" \
               -e "s#\%\%{acl, admin, {user, \"ermine\", \"example.org\"}}.#{acl, admin, {user, \"${wizard_ejabberd_admin_username:=admin}\", \"${wizard_ejabberd_hostname:=localhost}\"}}.#g" \
               -e "s#{access_createnode, pubsub_createnode},#{access_createnode, pubsub_createnode},\n\t\t  {max_items_node, 1000000},#g" \
               ${INSTALL_DIR}/etc/ejabberd/ejabberd.cfg
        ${SSS} start > /dev/null
        ${INSTALL_DIR}/sbin/ejabberdctl register ${wizard_ejabberd_admin_username:=admin} ${wizard_ejabberd_hostname:=localhost} ${wizard_ejabberd_admin_password}
        ${SSS} stop > /dev/null
    fi

    # Correct the files ownership
    chown -R ${USER}:root ${SYNOPKG_PKGDEST}

    # Add firewall config
    ${SERVICETOOL} --install-configure-file --package ${FWPORTS} >> /dev/null

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
