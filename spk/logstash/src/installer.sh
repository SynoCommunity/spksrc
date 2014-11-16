#!/bin/sh
# Copyright (c) 2014 AustinSaintAubin. All rights reserved.
# http://ukdl.synology.com/download/ds/userguide/DSM_Developer_Guide.pdf

# Script Environment Variables
# Several variables are exported by Package Center and can be used in the scripts. Descriptions of the variables are given as below:
# - SYNOPKG_PKGNAME: Package name which is defined in INFO.
# - SYNOPKG_PKGVER: Package version which is defined in INFO.
# - SYNOPKG_PKGDEST: Target directory in which the package is stored.
# - SYNOPKG_PKGDEST_VOL: Target volume in which the package is stored. Please note, SYNOPKG_PKGDEST_VOL is only available in DSM 4.2 or above. If you want to get the target volume in older DSM, please parse it from SYNOPKG_PKGDEST variable.
# - SYNOPKG_PKGPORT: Administrator port which is defined in INFO. Packages listed on a specific port to use the management UI.
# - SYNOPKG_PKGINST_TEMP_DIR: Packages are extracted to a temporary directory whose path is described by this variable.
# - SYNOPKG_TEMP_LOGFILE: Package Center randomly generates a filename for a script to log the information or error messages.
# - SYNOPKG_DSM_LANGUAGE: End-user’s DSM language
# - SYNOPKG_DSM_VERSION_MAJOR: End-user’s major number of DSM version which is
# formatted as [DSM major number].[DSM minor number]-[DSM build number].
# - SYNOPKG_DSM_VERSION_MINOR: End-user’s minor number of DSM version which is formatted as [DSM major number].[DSM minor number]-[DSM build number].
# - SYNOPKG_DSM_VERSION_BUILD: End-user’s DSM build number of DSM version which is formatted as [DSM major number].[DSM minor number]-[DSM build number].
# - SYNOPKG_DSM_ARCH: End-user’s DSM CPU architecture. Reference: http://forum.synology.com/wiki/index.php/What_kind_of_CPU_does_my_NAS_have
# - SYNOPKG_PKG_STATUS: Package status can be represented by these values: INSTALL, UPGRADE, UNINSTALL, START, and STOP.
# a Status value of a package will be set to INSTALL in the preinst and postinst scripts while the package is being installed. If the user chooses the “start after installation” option at the last step of the installation wizard, the value will be set to INSTALL in the start-stop-status script when the package is started.
# b Status value of a package will be set to UPGRADE in the preupgrade, preuninst, postunist, preinst, postinst and postupgrade scripts sequentially while the package is being upgraded. If the package has been already started before upgrade, the value will be set to UPGRADE in the start-stop-status script when the package is started or stopped.
# c Status value of a package will be set to UNINSTALL in the preuninst and postunist scripts while the package is being uninstalled. If the package has been already started before uninstall, the value will be set to UNINSTALL in the start-stop-status script when the package is stopped.
# d If the user starts or stops a package in Package Center, the status value of the package will be set to START or STOP in the start-stop-status script.
# e When the DiskStation is booting or shutting down, its status value will be empty. Please note, SYNOPKG_PKG_STATUS is only available for the start-stop-status script in DSM 4.0 or above.
# - SYNOPKG_OLD_PKGVER: Existing package version which is defined in INFO (only in preupgrade script).

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
	
# 	# Download Logstash
# 	[ -e "${SYNOPKG_PKGINST_TEMP_DIR}/${LOGSTASH_DOWNLOAD_FILE}" ] && rm "${SYNOPKG_PKGINST_TEMP_DIR}/${LOGSTASH_DOWNLOAD_FILE}"  # Remove older download if pressent
# 	wget "${LOGSTASH_DOWNLOAD_URL}" -P "$SYNOPKG_PKGINST_TEMP_DIR" 
# 	[ -e "${SYNOPKG_PKGINST_TEMP_DIR}/${LOGSTASH_DOWNLOAD_FILE}" ] || (echo "There was a problem downloading (${LOGSTASH_DOWNLOAD_FILE}) from the official download url (${LOGSTASH_DOWNLOAD_URL})." >> $SYNOPKG_TEMP_LOGFILE; exit 1)
	
# 	# Download Kibana
# 	[ -e "${SYNOPKG_PKGINST_TEMP_DIR}/${KIBANA_DOWNLOAD_FILE}" ] && rm "${SYNOPKG_PKGINST_TEMP_DIR}/${KIBANA_DOWNLOAD_FILE}"  # Remove older download if pressent
# 	wget "${KIBANA_DOWNLOAD_URL}" -P "$SYNOPKG_PKGINST_TEMP_DIR"
# 	[ -e "${SYNOPKG_PKGINST_TEMP_DIR}/${KIBANA_DOWNLOAD_FILE}" ] || (echo "There was a problem downloading (${KIBANA_DOWNLOAD_FILE}) from the official download url (${KIBANA_DOWNLOAD_URL})." >> $SYNOPKG_TEMP_LOGFILE; exit 1)
	
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
	
	# Create Softlink for config
# 	ln -s "${LOGSTASH_CONFIG_PATH}" "${SYNOPKG_PKGDEST}"  # Logstash Config File
	
	# Check if Downloaded Files Pressent
	[ -e "${SYNOPKG_PKGDEST}/${LOGSTASH_DOWNLOAD_FILE}" ] || ( "Issue with package, cant find $LOGSTASH_DOWNLOAD_FILE" > $SYNOPKG_TEMP_LOGFILE ;exit 1)  # exit status code 0 is good.
	
	# Move Downloaded Items into Package Destination
	### packages are moved by synology before post install... just need to extract the archive.
	
# 	# Extract Logstash
# # 	tar zxvf ${SYNOPKG_PKGDEST}/logstash-* -C "${SYNOPKG_PKGDEST}"
# 	tar zxvf "${SYNOPKG_PKGDEST}/${LOGSTASH_DOWNLOAD_FILE}" -C "${SYNOPKG_PKGDEST}"
# 	mv "${SYNOPKG_PKGDEST}/${LOGSTASH_DOWNLOAD_FILE%.tar.gz}" "${SYNOPKG_PKGDEST}/logstash"
# 	rm "${SYNOPKG_PKGDEST}/${LOGSTASH_DOWNLOAD_FILE}"
	
# 	# Extract Kibana
# 	tar zxvf ${SYNOPKG_PKGDEST}/kibana-* -C "${SYNOPKG_PKGDEST}"
# 	mv ${SYNOPKG_PKGDEST}/kibana-*/* "${SYNOPKG_PKGDEST}/kibana"
# 	rm ${SYNOPKG_PKGDEST}/kibana-*.tar.gz
# 	rm -r ${SYNOPKG_PKGDEST}/kibana-*	
	
	# Link to Kibana
	ln -s "${SYNOPKG_PKGDEST}/logstash/vendor/kibana/" "${SYNOPKG_PKGDEST}/app/"
	
# 	# Make Log Message
# 	[ "$SYNOPKG_PKG_STATUS" != "UPGRADE" ] || date +"%c installed version ${SYNOPKG_PKGVER}<br>" >> $LOGSTASH_LOG_PATH
	
	exit 0
}

preupgrade() {
	exit 0
}

postupgrade() {
	exit 0
}

preuninst() {
	exit 0
}

postuninst() {
	exit 0
}