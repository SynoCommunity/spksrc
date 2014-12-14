#!/bin/sh
# Copyright (c) 2014 AustinSaintAubin. All rights reserved.
# Script Environment Variables http://ukdl.synology.com/download/ds/userguide/DSM_Developer_Guide.pdf

# Specific Package Varables
PACKAGE="logstash"
DNAME="Logstash"

# Common Package Varables
INSTALL_DIR="/var/packages/${PACKAGE}/target"  # "$SYNOPKG_PKGDEST"
SSS="${INSTALL_DIR}/scripts/start-stop-status"  # Start Stop Status File
TMP_DIR="${PACKAGE}/../../@tmp"
FWPORTS="/var/packages/${PACKAGE}/scripts/${PACKAGE}.sc"
USER="logstash"
GROUP="users"
APACHE_USER="$([ $(grep buildnumber /etc.defaults/VERSION | cut -d"\"" -f2) -ge 4418 ] && echo -n http || echo -n nobody)"

# Get Envirmental Varables (needed to detect if java is installed)
source /root/.profile  # Get Environment Variables from Root Profile
# PATH=$PATH:/var/packages/JavaManager/target/Java/bin # Synology Java Manager Package
# PATH=$PATH:/var/packages/JavaManager/target/Java/jre/bin # Synology Java Manager Package

PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/usr/bin:${PATH}"
SERVICETOOL="/usr/syno/bin/servicetool"

# Logstash Varables
PACKAGE_CONF_PATH="${INSTALL_DIR}/var/package.conf"
JAVA_CONF_PATH="${INSTALL_DIR}/var/logstash-java.conf"

# Kibana Varables
KIBANA_DIR="${INSTALL_DIR}/logstash/vendor/kibana/"
WEB_DIR="/var/services/web"

# Common Functions
checkFolder() { [ -d "$@" ] || mkdir -p "$@"; }

# Package Functions
preinst() {	
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
	# Install busybox stuff
	${INSTALL_DIR}/bin/busybox --install ${INSTALL_DIR}/bin
	
	# Create user
	adduser -h ${INSTALL_DIR}/var -g "${DNAME} User" -G ${GROUP} -s /bin/sh -S -D ${USER}
	
	# Configure files
	if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
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
	fi
	
	# Check Logstash Config, Log, & Database
	checkFolder "$(dirname "${wizard_logstash_config_path}")"  # Create Folder if Needed
	checkFolder "${wizard_logstash_database_dir}"  # Create Folder if Needed
	checkFolder "$(dirname "${wizard_logstash_log_path}")"  # Create Folder if Needed
	checkFolder "$(dirname "${wizard_java_config_path}")"  # Create Folder if Needed
	[ -e "${wizard_logstash_config_path}" ] || cp "${INSTALL_DIR}/logstash-sample.conf" "${wizard_logstash_config_path}"
	[ -e "${wizard_java_config_path}" ] || cp "${JAVA_CONF_PATH}" "${wizard_java_config_path}"
	
	# Symbolic Link to Kibana
# 	ln -s "${INSTALL_DIR}/logstash/vendor/kibana/" "${INSTALL_DIR}/app/"
	ln -s "${WEB_DIR}/kibana" "${INSTALL_DIR}/app/"

	# Move Kibana to Web Services
	cp -pR ${KIBANA_DIR} ${WEB_DIR}
	
	# Configure open_basedir
	if [ "${APACHE_USER}" == "nobody" ]; then
		echo -e "<Directory \"${WEB_DIR}/kibana\">\nphp_admin_value open_basedir none\n</Directory>" > /usr/syno/etc/sites-enabled-user/${PACKAGE}.conf
	else
		echo -e "[PATH=${WEB_DIR}/kibana]\nopen_basedir = Null" > /etc/php/conf.d/${PACKAGE_NAME}.ini
	fi
	
	# Set group and permissions on config files and database dir for DSM5
	if [ `/bin/get_key_value /etc.defaults/VERSION buildnumber` -ge "4418" ]; then
		chown -R ${USER}:root ${SYNOPKG_PKGDEST}
	fi
	
	# Correct the files ownership
	chown -R ${USER}:root ${SYNOPKG_PKGDEST}
	chown -R ${APACHE_USER}:${APACHE_USER} ${WEB_DIR}/kibana
	
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
	
	# Remove the users permisions from the share
	if [ `/bin/get_key_value /etc.defaults/VERSION buildnumber` -ge "4418" ]; then
		
		# Internal Field Separator
		IFS_TEMP="$IFS" # backup curent internal field separator
		IFS="|"  # Set Seperator for Files List
		
		# Allow root traversal for config files, this is needed to logstash can acccess these files
		FILES="${LOGSTASH_CONFIG_PATH}|${LOGSTASH_LOG_PATH}|${JAVA_CONF_PATH}|${LOGSTASH_DATABASE_DIR}"
		for FILE in ${FILES}; do
			
			# Set Share Permissions
			SHARE_DIR=$(echo "${FILE}" | awk -F/ '{print "/"$2"/"$3}')
			
			# Set Share Permissions
			if [ "$(synoacltool -get "${SHARE_DIR}" | grep "user:$USER:allow")" ]; then
				synoacltool -del "${FILE}" $(synoacltool -get "${FILE}" | grep "user:$USER" | awk 'BEGIN { OFS=" "; } { gsub(/[^[:alnum:]]/, "", $1); print $1;}' | head -1) &> /dev/null
			fi
			
			# Set Directory Path / Host DIRECTORY Permissions
			if [ ! -d "${FILE}" ]; then
				DIRECTORY="$(dirname "${FILE}")"
				
				if [ -f "${FILE}" ] && [ "$(synoacltool -get "${DIRECTORY}" | grep "user:$USER:allow")" ]; then
					synoacltool -del "${DIRECTORY}" $(synoacltool -get "${FILE}" | grep "user:$USER" | awk 'BEGIN { OFS=" "; } { gsub(/[^[:alnum:]]/, "", $1); print $1;}' | head -1) &> /dev/null
				fi
			fi
			
			# Set File Permissions
			if ([ -f "${FILE}" ] || [ -d "${FILE}" ]) && [ ! "$(synoacltool -get "${FILE}" | grep "user:$USER:allow")" ]; then
				synoacltool -del "${FILE}" $(synoacltool -get "${FILE}" | grep "user:$USER" | awk 'BEGIN { OFS=" "; } { gsub(/[^[:alnum:]]/, "", $1); print $1;}' | head -1) &> /dev/null
			fi
		done
		
		IFS="$IFS_TEMP" # restore curent internal field separator
	fi
	
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
	rm "${INSTALL_DIR}/app/kibana"
	
	# Remove Kibana Web Interface
	rm -fr ${WEB_DIR}/kibana
	
	exit 0
}