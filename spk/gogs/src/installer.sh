#!/bin/sh

# Package
PACKAGE="gogs"
DNAME="Gogs"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PATH="${INSTALL_DIR}/bin:${PATH}"
USER="git"
GROUP="nobody"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"
SERVICETOOL="/usr/syno/bin/servicetool"
FWPORTS="/var/packages/${PACKAGE}/scripts/${PACKAGE}.sc"
WORKDIR="${INSTALL_DIR}/var"
INSTALL_LOG="${WORKDIR}/logs/install.log"

REPOSITORIES="gogs-repositories"

MYSQL="$([ $(/bin/get_key_value /etc.defaults/VERSION buildnumber) -ge 7135 ] && echo -n /bin/mysql || echo -n /usr/syno/mysql/bin/mysql)"
MYSQL_USER=${PACKAGE}
MYSQL_DATABASE=${PACKAGE}

CURL="${INSTALL_DIR}/bin/curl"

preinst ()
{
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        if ! ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e quit > /dev/null 2>&1; then
            echo "Incorrect MySQL root password"
            exit 1
        fi
        if ${MYSQL} -u root -p"${wizard_mysql_password_root}" mysql -e "SELECT User FROM user" | grep ^${MYSQL_USER}$ > /dev/null 2>&1; then
            echo "MySQL user ${MYSQL_USER} already exists"
            exit 1
        fi
        if ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "SHOW DATABASES" | grep ^${MYSQL_DATABASE}$ > /dev/null 2>&1; then
            echo "MySQL database ${MYSQL_DATABASE} already exists"
            exit 1
        fi
	if [ -d ${wizard_root_path} ]; then
	    echo "Directory ${wizard_root_path} alreday exists"
	    exit 1
	fi
    fi

    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Install busybox stuff
    ${INSTALL_DIR}/bin/busybox --install ${INSTALL_DIR}/bin

    # Setup database and run installer
    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
	# Create user
	adduser -H -h ${WORKDIR} -g "${DNAME} User" -G ${GROUP} -s /bin/sh -D ${USER}
	
	# Create mysql user and database
        ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "CREATE DATABASE ${MYSQL_DATABASE} CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"
        ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${wizard_mysql_password_gogs:=gogs}';"
	
	# Create repository path
	mkdir ${wizard_root_path}
	mkdir ${wizard_root_path}/${REPOSITORIES}
	chown -R ${USER}:root ${wizard_root_path}
	
	# Initialize URL
        if [ "${wizard_app_url}" == "" ]; then
            wizard_app_url="http://${wizard_domain}:3000/"
        fi
	
	# Configure root path
	echo "ROOT_PATH=${wizard_root_path}" > ${WORKDIR}/install.conf
	
	# Correct the files ownership
	chown -R ${USER}:root ${SYNOPKG_PKGDEST}

	# Install gogs application
	${SSS} start > ${INSTALL_LOG}
	sleep 5
	${CURL} -L --retry 3 -X POST \
	  --data-urlencode "db_type=MySQL" \
	  --data-urlencode "db_host=localhost:3306" \
	  --data-urlencode "db_user=${MYSQL_USER}" \
	  --data-urlencode "db_passwd=${wizard_mysql_password_gogs}" \
	  --data-urlencode "db_name=${MYSQL_DATABASE}" \
	  --data-urlencode "ssl_mode=disable" \
	  --data-urlencode "app_name=${wizard_app_name}" \
	  --data-urlencode "repo_root_path=${wizard_root_path}/${REPOSITORIES}" \
	  --data-urlencode "run_user=${USER}" \
	  --data-urlencode "domain=${wizard_domain}" \
	  --data-urlencode "ssh_port=2222" \
	  --data-urlencode "http_port=3000" \
	  --data-urlencode "app_url=${wizard_app_url}" \
	  --data-urlencode "log_root_path=${WORKDIR}/logs" \
	  --data-urlencode "disable_registration=on" \
	  --data-urlencode "require_sign_in_view=on" \
	  --data-urlencode "admin_name=${wizard_admin_name}" \
	  --data-urlencode "admin_passwd=${wizard_admin_passwd}" \
	  --data-urlencode "admin_confirm_passwd=${wizard_admin_confirm_passwd}" \
	  --data-urlencode "admin_email=${wizard_admin_email}" \
	  http://localhost:3000/install >> ${INSTALL_LOG}
	
	sleep 3
	${SSS} stop >> ${INSTALL_LOG}
		
    fi
   
    # Correct the files ownership
    chown -R ${USER}:root ${SYNOPKG_PKGDEST}

    # Add firewall config
    ${SERVICETOOL} --install-configure-file --package ${FWPORTS} >> ${INSTALL_LOG}

    exit 0
}

preuninst ()
{
    # Check database
    if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" ] && ! ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e quit > /dev/null 2>&1; then
        echo "Incorrect MySQL root password"
        exit 1
    fi

    # Stop the package
    ${SSS} stop > /dev/null

    # Remove firewall config
    if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" ]; then
        ${SERVICETOOL} --remove-configure-file --package ${PACKAGE}.sc >> /dev/null
    fi

    #Remove system user    

    exit 0
}

postuninst ()
{
    . ${WORKDIR}/install.conf

    # Remove link
    rm -f ${INSTALL_DIR}
    
    # Remove the data and user (if not upgrading)
    if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" ]; then
        ${MYSQL} -u root -p"${wizard_mysql_password_root}" -e "DROP DATABASE ${MYSQL_DATABASE}; DROP USER '${MYSQL_USER}'@'localhost';"
	rm -rf $ROOT_PATH/${REPOSITORIES}
	rm -rf $ROOT_PATH/\@eaDir
	rmdir $ROOT_PATH
	deluser ${USER}
    fi
   
    exit 0
}

preupgrade ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    # Save some stuff
    rm -fr ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}
    mv ${WORKDIR} ${TMP_DIR}/${PACKAGE}/

    exit 0
}

postupgrade ()
{
    # Restore some stuff
    cp -f ${INSTALL_LOG} ${TMP_DIR}/${PACKAGE}/var/logs/upgrade.log
    rm -fr ${WORKDIR}
    mv ${TMP_DIR}/${PACKAGE}/var ${INSTALL_DIR}/
    rm -fr ${TMP_DIR}/${PACKAGE}

    exit 0
}
