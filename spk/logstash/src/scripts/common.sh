#!/bin/sh
# Copyright (c) 2014 AustinSaintAubin. All rights reserved.
# http://ukdl.synology.com/download/ds/userguide/DSM_Developer_Guide.pdf
# logstash-1.3.3-noarch-0008

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
PACKAGE_NAME="$(echo "$SYNOPKG_PKGNAME" | awk '{print tolower($0)}' | sed -e 's/ /_/g')"
PACKAGE_DIR="${SYNOPKG_PKGDEST}"  # "$SYNOPKG_PKGDEST"
PACKAGE_UPGRADE_FLAG="/tmp/${PACKAGE_NAME}.upgrade"
CFG_FILE="/var/packages/$SYNOPKG_PKGNAME/scripts/start-stop-status"

# Logstash Varables
LOGSTASH_LOG_PATH="${PACKAGE_DIR}/$SYNOPKG_PKGNAME.log"

preinst() {
	# Check if Java installed 
	if [ -n "$(which java)" ]; then
		echo "Java required to be installed to run ${PACKAGE_NAME}" > $SYNOPKG_TEMP_LOGFILE
		exit 1
	fi
	
	exit 0
}

postinst() {
	# Create Softlink & Mount
	ln -s "${LOGSTASH_CONFIG_PATH}" "${PACKAGE_DIR}"  # Logstash Config File
	
	# Configure start-stop-status file based on wizard, or use defaults
	sed -i -e "s|@logstash_config_path@|${wizard_config_path:=/volume1/active_system/logstash/logstash.conf}|g" "$CFG_FILE"
	sed -i -e "s|@logstash_database_dir@|${wizard_database_dir:=/volume1/active_system/logstash/database}|g" "$CFG_FILE"
	sed -i -e "s|@logstash_log_path@|${wizard_log_path:=/volume1/active_system/logstash/logstash.log}|g" "$CFG_FILE"
	sed -i -e "s|@java_heap_size_initial@|${wizard_java_heap_size_initial}|g" "$CFG_FILE"
	sed -i -e "s|@java_heap_size_max@|${wizard_java_heap_size_max}|g" "$CFG_FILE"
	sed -i -e "s|@java_args_tuning@|${wizard_java_args_tuning}|g" "$CFG_FILE"
	
	# Make Log Message
	[ "$SYNOPKG_PKG_STATUS" != "UPGRADE" ] || date +"%c installed version ${SYNOPKG_PKGVER}<br>" >> $LOGSTASH_LOG_PATH
	
# 	# Check if Config Pressent
# 	[ -e "$PACKAGE_DIR\$LOGSTASH_JAR_FILE" ] && exit 0 || ( "Issue with package, cant find $PACKAGE_SETTINGS_PATH" > $SYNOPKG_TEMP_LOGFILE ;exit 1)  # exit status code 0 is good.
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
