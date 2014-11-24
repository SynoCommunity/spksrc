#!/bin/sh
# Copyright (c) 2014 AustinSaintAubin. All rights reserved.
# Script Environment Variables http://ukdl.synology.com/download/ds/userguide/DSM_Developer_Guide.pdf

# COMMON PACKAGE VARABLES
DNAME="$(echo "${SYNOPKG_PKGNAME}" | awk '{print tolower($0)}' | sed -e 's/ /_/g')"  # Package Name in Simple Form
SSS="/var/packages/${SYNOPKG_PKGNAME}/scripts/start-stop-status"  # Start Stop Status File
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"

# Logstash Varables
JAVA_CONF_PATH="${SYNOPKG_PKGDEST}/var/logstash-java.conf"

# Common Functions
checkFolder() { [ -d "$@" ] || mkdir -p "$@"; }

# Package Functions
preinst() {
	# Check if Java installed 
	if [ -n "$(which java)" ]; then
		echo "Java required to be installed to run ${SYNOPKG_PKGNAME}" >> $SYNOPKG_TEMP_LOGFILE
		exit 1
	fi
	
	exit 0
}

postinst() {
	# Configure start-stop-status file based on download varables
	sed -i -e "s|@package_dname@|${DNAME}|g" "${SSS}"
	sed -i -e "s|@package_dir@|${SYNOPKG_PKGDEST}|g" "${SSS}"
	
	# Configure start-stop-status file based on wizard, or use defaults
	sed -i -e "s|@logstash_config_path@|${wizard_logstash_config_path:=/var/packages/logstash/target/var/logstash.conf}|g" "${SSS}"
	sed -i -e "s|@logstash_database_dir@|${wizard_logstash_database_dir:=/var/packages/logstash/target/var/database}|g" "${SSS}"
	sed -i -e "s|@logstash_log_path@|${wizard_logstash_log_path:=/var/packages/logstash/target/var/logstash.log}|g" "${SSS}"
	sed -i -e "s|@java_config_path@|${wizard_java_config_path:=/var/packages/logstash/target/var/logstash-java.conf}|g" "${SSS}"
	
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
	[ -e "${wizard_logstash_config_path}" ] || cp "${SYNOPKG_PKGDEST}/logstash-sample.conf" "${wizard_logstash_config_path}"
	[ -e "${wizard_java_config_path}" ] || cp "${JAVA_CONF_PATH}" "${wizard_java_config_path}"
	
	# Link to Kibana
	ln -s "${SYNOPKG_PKGDEST}/logstash/vendor/kibana/" "${SYNOPKG_PKGDEST}/app/"
	
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
	
	exit 0
}

postuninst() {
	# Remove link
    rm -f "${SYNOPKG_PKGDEST}/app/"
	
	exit 0
}