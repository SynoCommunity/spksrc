#!/bin/sh

# Package
PACKAGE="gitolite"
DNAME="Gitolite"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
GIT_DIR="/usr/local/git"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/sbin:${GIT_DIR}/bin:${PATH}"
USER="gitolite"
GROUP="nobody"

SERVICETOOL="/usr/syno/bin/servicetool"
FWPORTS="/var/packages/${PACKAGE}/scripts/${PACKAGE}.sc"

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

	# Add firewall config
    ${SERVICETOOL} --install-configure-file --package ${FWPORTS} >> /dev/null

    # Create user
    adduser -h ${INSTALL_DIR}/var -g "${DNAME} User" -G ${GROUP} -s /bin/sh -S -D ${USER}

    # Generate keys
    dropbearkey -t rsa -f ${INSTALL_DIR}/var/dropbear_rsa_host_key > /dev/null 2>&1
    dropbearkey -t dss -f ${INSTALL_DIR}/var/dropbear_dss_host_key > /dev/null 2>&1

    # Correct the files ownership
    chown -R ${USER}:root ${SYNOPKG_PKGDEST}

    # Setup gitolite
    ${INSTALL_DIR}/share/gitolite/install -to ${INSTALL_DIR}/bin
	synoshare -add ${USER} "Gitolite data" "$(/usr/syno/bin/servicetool --get-alive-volume)/${PACKAGE}" "" "admin,${USER}" "" 0 0
	REPOSITORIES_LOCATION="$(synoshare --get gitolite |sed -n -e "s|^\\s*Path \.*\[\(/.*\)\].*|\1|p")/repositories"

    if [ ! -z "${wizard_public_key}" ]; then
        echo "${wizard_public_key}" > ${INSTALL_DIR}/var/admin.pub
        su - ${USER} -c "PATH=${PATH} ${INSTALL_DIR}/bin/gitolite setup -pk ${INSTALL_DIR}/var/admin.pub"
        sed -i -e "s|UMASK                           =>  0077,|UMASK                           =>  0022,|" ${INSTALL_DIR}/var/.gitolite.rc 
		rm ${INSTALL_DIR}/var/admin.pub
	else
		su - ${USER} -c "PATH=${PATH} ${INSTALL_DIR}/bin/gitolite setup -a admin"
    fi

	if [ -d "${REPOSITORIES_LOCATION}" ]; then
		rm -rf "${REPOSITORIES_LOCATION}/gitolite-admin.git"
		mv ${INSTALL_DIR}/var/repositories/gitolite-admin.git ${REPOSITORIES_LOCATION}/
	else
		mv ${INSTALL_DIR}/var/repositories ${REPOSITORIES_LOCATION}
	fi
	rm -rf ${INSTALL_DIR}/var/repositories
	ln -s ${REPOSITORIES_LOCATION} ${INSTALL_DIR}/var/repositories

    sed -i -e "$(printf '1i$ENV{PATH} = "%s/bin:$ENV{PATH}";\' "$GIT_DIR")" ${INSTALL_DIR}/var/.gitolite.rc

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

	# Remove firewall config
	if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" ]; then
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
