#!/bin/sh
# Copyright (c) 2014 AustinSaintAubin. All rights reserved.
# Script Environment Variables http://ukdl.synology.com/download/ds/userguide/DSM_Developer_Guide.pdf

# COMMON PACKAGE VARABLES
PACKAGE_NAME_SIMPLE="$(echo "${SYNOPKG_PKGNAME}" | awk '{print tolower($0)}' | sed -e 's/ /_/g')"
PACKAGE_UPGRADE_FLAG="/tmp/${PACKAGE_NAME_SIMPLE}.upgrade"
START_STOP_STATUS_FILE="/var/packages/${SYNOPKG_PKGNAME}/scripts/start-stop-status"

# Logstash Varables
LOGSTASH_LOG_PATH="${SYNOPKG_PKGDEST}/${PACKAGE_NAME_SIMPLE}.log"

# Download Varables
SYNOPKG_PKGVER="1.4.2"
SYNOPKG_PKGDEST="/var/packages/logstash/target"
# LOGSTASH_DOWNLOAD_URL="http://download.elasticsearch.org/logstash/logstash/logstash-${SYNOPKG_PKGVER}.tar.gz"
# LOGSTASH_DOWNLOAD_FILE="$(basename ${LOGSTASH_DOWNLOAD_URL})"
# KIBANA_DOWNLOAD_URL="http://download.elasticsearch.org/kibana/kibana/kibana-latest.tar.gz"
# KIBANA_DOWNLOAD_FILE="$(basename ${KIBANA_DOWNLOAD_URL})"

# Common Functions
checkFolder() { [ -d "$@" ] && echo "Directory Exists: $@" || (echo "Making Directory: $@"; mkdir -p "$@"); }

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
	sed -i -e "s|@package_name_simple@|${PACKAGE_NAME_SIMPLE}|g" "${START_STOP_STATUS_FILE}"
	sed -i -e "s|@package_dir@|${SYNOPKG_PKGDEST}|g" "${START_STOP_STATUS_FILE}"
	sed -i -e "s|@package_upgrade_flag@|${PACKAGE_UPGRADE_FLAG}|g" "${START_STOP_STATUS_FILE}"
	
	# Configure start-stop-status file based on wizard, or use defaults
	sed -i -e "s|@logstash_config_path@|${wizard_config_path:=/volume1/active_system/logstash/logstash.conf}|g" "${START_STOP_STATUS_FILE}"
	sed -i -e "s|@logstash_database_dir@|${wizard_database_dir:=/volume1/active_system/logstash/database}|g" "${START_STOP_STATUS_FILE}"
	sed -i -e "s|@logstash_log_path@|${wizard_log_path:=/volume1/active_system/logstash/logstash.log}|g" "${START_STOP_STATUS_FILE}"
	sed -i -e "s|@java_heap_size_initial@|${wizard_java_heap_size_initial}|g" "${START_STOP_STATUS_FILE}"
	sed -i -e "s|@java_heap_size_max@|${wizard_java_heap_size_max}|g" "${START_STOP_STATUS_FILE}"
	sed -i -e "s|@java_arguments_tuning@|${wizard_java_arguments_tuning}|g" "${START_STOP_STATUS_FILE}"
	sed -i -e "s|@logstash_parameters_tuning@|${wizard_logstash_parameters_tuning}|g" "${START_STOP_STATUS_FILE}"

	# Check Logstash Config, Log, & Database
	checkFolder "$(dirname "${wizard_config_path}")"  # Create Folder if Needed
	checkFolder "$(dirname "${wizard_database_dir}")"  # Create Folder if Needed
	checkFolder "$(dirname "${wizard_log_path}")"  # Create Folder if Needed
	[ -e "${wizard_config_path}" ] || cp "${SYNOPKG_PKGDEST}/logstash-sample.conf" "${wizard_config_path}"
	
	# Link to Kibana
	ln -s "${SYNOPKG_PKGDEST}/logstash/vendor/kibana/" "${SYNOPKG_PKGDEST}/app/"
	
	exit 0
}

preupgrade() {
	# Stop the package
    ${START_STOP_STATUS_FILE} stop > /dev/null
    
    # Backup the Config
    cp /volume1/active_system/logstash/logstash.conf /volume1/active_system/logstash/logstash.conf.bak
	
	exit 0
}

postupgrade() {
	exit 0
}

preuninst() {
	# Stop the package
    ${START_STOP_STATUS_FILE} stop > /dev/null
	
	exit 0
}

postuninst() {
	# Remove link
    rm -f "${SYNOPKG_PKGDEST}/app/"
	
	exit 0
}