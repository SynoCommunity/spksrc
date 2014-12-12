#!/bin/sh
# Copyright (c) 2014 AustinSaintAubin. All rights reserved.
# Script Environment Variables http://ukdl.synology.com/download/ds/userguide/DSM_Developer_Guide.pdf

# Common Package Varables
PACKAGE="logstash"
DNAME="Logstash"
PACKAGE_DIR="/var/packages/${PACKAGE}/target"  # "$SYNOPKG_PKGDEST"
SSS="${PACKAGE_DIR}/scripts/start-stop-status"  # Start Stop Status File
TMP_DIR="${PACKAGE}/../../@tmp"

SERVICETOOL="/usr/syno/bin/servicetool"
FWPORTS="/var/packages/${PACKAGE}/scripts/${PACKAGE}.sc"

# Logstash Varables
PACKAGE_CONF_PATH="${PACKAGE_DIR}/var/package.conf"
JAVA_CONF_PATH="${PACKAGE_DIR}/var/logstash-java.conf"
USER="logstash"
GROUP="users"

# Kibana Varables
KIBANA_DIR="${PACKAGE_DIR}/logstash/vendor/kibana/"
WEB_DIR="/var/services/web"

# Common Functions
checkFolder() { [ -d "$@" ] || mkdir -p "$@"; }

# Package Functions
preinst() {
	# Get Envirmental Varables (needed to detect if java is installed)
	source /root/.profile  # Get Environment Variables from Root Profile
	
	# Check if Java installed 
	which java &>/dev/null
	if [ $? -eq 1 ]; then
		echo "Java required to be installed to run ${DNAME} [$(which java)]" >> $SYNOPKG_TEMP_LOGFILE
		exit 1
	fi
	
# 	# Check existence of website root
# 	if [ -e ${WEB_DIR} ]; then
# 		if [ -z "$SYNOPKG_DSM_LANGUAGE" ]; then
# 			echo "Website root already exists ($WEB_DIR)" > $SYNOPKG_TEMP_LOGFILE
# 			exit 1
# 		fi
# 		case $SYNOPKG_DSM_LANGUAGE in
# 					*)
# 				echo "Website root already exists ($WEB_DIR)" > $SYNOPKG_TEMP_LOGFILE 
# 			;;
# 		esac
# 		exit 1
# 	fi
	
	exit 0
}

postinst() {
	# Configure package varables file based on wizard, or use defaults (used for scripts like the start-stop-status)
	sed -i -e "s|@logstash_config_path@|${wizard_logstash_config_path:=/var/packages/logstash/target/var/logstash.conf}|g" "${PACKAGE_CONF_PATH}"
	sed -i -e "s|@logstash_database_dir@|${wizard_logstash_database_dir:=/var/packages/logstash/target/var/database}|g" "${PACKAGE_CONF_PATH}"
	sed -i -e "s|@logstash_log_path@|${wizard_logstash_log_path:=/var/packages/logstash/target/var/logstash.log}|g" "${PACKAGE_CONF_PATH}"
	sed -i -e "s|@java_config_path@|${wizard_java_config_path:=/var/packages/logstash/target/var/logstash-java.conf}|g" "${PACKAGE_CONF_PATH}"
	
	# Configure java settigns file based on wizard, or use defaults
	sed -i -e "s|@java_heap_size_initial@|${wizard_java_heap_size_initial}|g" "${JAVA_CONF_PATH}"
	sed -i -e "s|@java_heap_size_max@|${wizard_java_heap_size_max}|g" "${JAVA_CONF_PATH}"
	sed -i -e "s|@java_arguments_tuning@|${wizard_java_arguments_tuning}|g" "${JAVA_CONF_PATH}"
	sed -i -e "s|@logstash_parameters_tuning@|${wizard_logstash_parameters_tuning}|g" "${JAVA_CONF_PATH}"
	
	# Check Logstash Config, Log, & Database
	checkFolder "$(dirname "${wizard_logstash_config_path}")"  # Create Folder if Needed
	checkFolder "${wizard_logstash_database_dir}"  # Create Folder if Needed
	checkFolder "$(dirname "${wizard_logstash_log_path}")"  # Create Folder if Needed
	checkFolder "$(dirname "${wizard_java_config_path}")"  # Create Folder if Needed
	[ -e "${wizard_logstash_config_path}" ] || cp "${PACKAGE_DIR}/logstash-sample.conf" "${wizard_logstash_config_path}"
	[ -e "${wizard_java_config_path}" ] || cp "${JAVA_CONF_PATH}" "${wizard_java_config_path}"
	
	# Symbolic Link to Kibana
	ln -s "${PACKAGE_DIR}/logstash/vendor/kibana/" "${PACKAGE_DIR}/app/"
# 	ln -s "${WEB_DIR}/${PACKAGE}" "${PACKAGE_DIR}/app/"
# 
#     # Fix permissions
#     chown -R ${USER} ${WEB_DIR}/${PACKAGE}
# 	
# 	# Move Kibana to Web Services
# # 	rm -rf $WEBSITE_ROOT  # Remove old webdir.
# # 	cp -pR "${KIBANA_DIR}" "${WEB_DIR}"
# 	mkdir "${WEB_DIR}/${PACKAGE}"
# 	mv -f "${KIBANA_DIR}" "${WEB_DIR}"
# 	chown -R 1023:1023 "${WEB_DIR}/${PACKAGE}"
# 	
# 	 # Configure open_basedir
#     if [ "${USER}" == "nobody" ]; then
#         echo -e "<Directory \"${WEB_DIR}/${PACKAGE}\">\nphp_admin_value open_basedir none\n</Directory>" > /usr/syno/etc/sites-enabled-user/${PACKAGE}.conf
#     else
#         echo -e "extension = fileinfo.so\n[PATH=${WEB_DIR}/${PACKAGE}]\nopen_basedir = Null" > /etc/php/conf.d/${PACKAGE_NAME}.ini
#         echo -e "<Directory \"${WEB_DIR}/${PACKAGE}\">\nXSendFilePath /\n</Directory>" > /etc/httpd/sites-enabled-user/${PACKAGE_NAME}.conf
#     fi
#     
# <VirtualHost *:80>
# ServerName 1test.nas.austinsaintaubin.me
# DocumentRoot "/var/services/web/test1"
# ErrorDocument 403 "/webdefault/error.html"
# ErrorDocument 404 "/webdefault/error.html"
# ErrorDocument 500 "/webdefault/error.html"
# </VirtualHost>

	# Create user
    adduser -h ${PACKAGE_DIR}/var -g "${DNAME} User" -G ${GROUP} -s /bin/sh -S -D ${USER}
	
	 # Correct the files ownership
    chown -R ${USER}:root ${PACKAGE_DIR}
    
    # Set group and permissions on configuration files & logs
    source "${PACKAGE_CONF_PATH}"  # Load Logstash File Path Varables
	chgrp users ${LOGSTASH_CONFIG_PATH}
	chmod g+rw ${LOGSTASH_CONFIG_PATH}
	chgrp users ${LOGSTASH_DATABASE_DIR}
	chmod g+rw ${LOGSTASH_DATABASE_DIR}
	chgrp users ${LOGSTASH_LOG_PATH}
	chmod g+rw ${LOGSTASH_LOG_PATH}
	chgrp users ${JAVA_CONF_PATH}
	chmod g+rw ${JAVA_CONF_PATH}
	
	# Add firewall config
    ${SERVICETOOL} --install-configure-file --package ${FWPORTS} >> /dev/null
    
	exit 0
}

preupgrade() {
	# Stop the package
    ${SSS} stop > /dev/null
    
    # Save some stuff
    rm -fr ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}
    mv ${INSTALL_DIR}/var ${TMP_DIR}/${PACKAGE}/
	
	exit 0
}

postupgrade() {
    # Restore some stuff
    rm -fr ${INSTALL_DIR}/var
    mv ${TMP_DIR}/${PACKAGE}/var ${INSTALL_DIR}/
    rm -fr ${TMP_DIR}/${PACKAGE}
	
	exit 0
}

preuninst() {
	# Stop the package
    ${SSS} stop > /dev/null
	
    # Remove the user (if not upgrading)
    if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
        delgroup ${USER} ${GROUP}
        deluser ${USER}
    fi

    # Remove firewall config
    if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" ]; then
        ${SERVICETOOL} --remove-configure-file --package ${PACKAGE}.sc >> /dev/null
    fi
	
	exit 0
}

postuninst() {
	# Remove Symbolic link
    rm "${PACKAGE_DIR}/app/kibana"
	
	exit 0
}