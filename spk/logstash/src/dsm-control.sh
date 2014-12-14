#!/bin/sh
# Copyright (c) 2013-2014 AustinSaintAubin. All rights reserved.
# https://github.com/mrlesmithjr/Logstash_Kibana3/blob/master/install_logstash_kibana_ubuntu.sh

# PATH="${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
source /root/.profile  # Get Environment Variables from Root Profile

# Package Varables
PACKAGE="logstash"
DNAME="Logstash"
INSTALL_DIR="/var/packages/${PACKAGE}/target"  # "$SYNOPKG_PKGDEST"
USER="logstash"
GROUP="users"
PATH="${INSTALL_DIR}/bin:${INSTALL_DIR}/usr/bin:${PATH}"

# Common Functions
checkFolder() { [ -d "$@" ] || mkdir -p "$@"; }

# Logstash File Path Varables
PACKAGE_CONF_PATH="${INSTALL_DIR}/var/package.conf"
source "${PACKAGE_CONF_PATH}" # Load Logstash File Path Varables
# Check Config & Load from stock if needed
[ -e "${LOGSTASH_LOG_PATH}" ] || ( checkFolder "$(dirname "${LOGSTASH_LOG_PATH}")"; touch "${LOGSTASH_LOG_PATH}"; LOGSTASH_LOG_MESSAGE="$LOGSTASH_LOG_MESSAGE\nCreating Logfile." )
[ -e "${LOGSTASH_CONFIG_PATH}" ] || ( checkFolder "$(dirname "${LOGSTASH_CONFIG_PATH}")"; cp "${INSTALL_DIR}/logstash-sample.conf" "${LOGSTASH_CONFIG_PATH}"; LOGSTASH_LOG_MESSAGE="$LOGSTASH_LOG_MESSAGE\nLogstash Config not found, loading sample config." )
[ -e "${JAVA_CONF_PATH}" ] || ( checkFolder "$(dirname "${JAVA_CONF_PATH}")"; cp "${INSTALL_DIR}/var/logstash-java.conf" "${JAVA_CONF_PATH}"; LOGSTASH_LOG_MESSAGE="$LOGSTASH_LOG_MESSAGE\nJava Config not found, loading sample config." )
checkFolder "${LOGSTASH_DATABASE_DIR}"

# Java Varables & Tuning
# JAVA_BINARY="$(which java)"
JAVA_ARGUMENTS=""  # Clear Java Arguments
source "${JAVA_CONF_PATH}"  # Load Java Settings
LOGSTASH_BIN_PATH="${INSTALL_DIR}/logstash/bin/logstash"
LOGSTASH_BIN_ARGS="agent --verbose --config "${LOGSTASH_CONFIG_PATH}" --log "${LOGSTASH_LOG_PATH}" ${LOGSTASH_PARAMETERS_TUNING}"
[ -n "$JAVA_HEAP_SIZE_MAX" ] && JAVA_ARGUMENTS="-XX:MaxHeapSize=$JAVA_HEAP_SIZE_MAX ${JAVA_ARGUMENTS}"  # Set Java Heap Size into string varable
[ -n "$JAVA_HEAP_SIZE_INITIAL" ] && JAVA_ARGUMENTS="-XX:InitialHeapSize=$JAVA_HEAP_SIZE_INITIAL ${JAVA_ARGUMENTS}"
JAVA_ARGUMENTS="-Des.path.data=${LOGSTASH_DATABASE_DIR} ${JAVA_ARGUMENTS}"  # Set Database Location

# Start & Stop Varables
PID_FILE="/var/run/${PACKAGE}.pid"

fix_permissions() {	
	# Set group and permissions on config files and database dir for DSM5
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
			if [ ! "$(synoacltool -get "${SHARE_DIR}" | grep "user:$USER:allow:--x----------:fd--")" ]; then
				if [ "$(synoacltool -get "${SHARE_DIR}" | grep "user:$USER:allow")" ]; then
					synoacltool -replace "${FILE}" $(synoacltool -get "${FILE}" | grep "user:$USER" | awk 'BEGIN { OFS=" "; } { gsub(/[^[:alnum:]]/, "", $1); print $1;}' | head -1) user:$USER:allow:--x----------:---n &> /dev/null
				else
# 	 				synoacltool -add "$SHARE_DIR" user:$USER:allow:--x----------:---n &> /dev/null
					synoacltool -add "$SHARE_DIR" user:$USER:allow:--x----------:df-- &> /dev/null
				fi
			fi
			
			# Set Directory Path / Host DIRECTORY Permissions
			if [ ! -d "${FILE}" ]; then
				DIRECTORY="$(dirname "${FILE}")"
				
				if [ -f "${FILE}" ] && [ ! "$(synoacltool -get "${DIRECTORY}" | grep "user:$USER:allow:rwxpdDaARWc--:fd--")" ]; then
					synoacltool -enforce-inherit "$SHARE_DIR"  # Clear Permisions & Allow Inherited
					synoacltool -add "${DIRECTORY}" user:$USER:allow:rwxpdDaARWc--:fd-- &> /dev/null
				fi
			fi
			
			# Set File Permissions
			if ([ -f "${FILE}" ] || [ -d "${FILE}" ]) && [ ! "$(synoacltool -get "${FILE}" | grep "user:$USER:allow:rwxpdDaARWc--:fd--")" ]; then
				synoacltool -enforce-inherit "$SHARE_DIR"  # Clear Permisions & Allow Inherited
				synoacltool -add "${FILE}" user:$USER:allow:rwxpdDaARWc--:fd-- &> /dev/null
			fi
		done
		
		IFS="$IFS_TEMP" # restore curent internal field separator
	else  # Older systems not using Synology ACLs
		# Set group and permissions on configuration files & logs		
		chgrp users "${LOGSTASH_CONFIG_PATH}"
		chmod g+rw "${LOGSTASH_CONFIG_PATH}"
		
		chgrp -R users "${LOGSTASH_DATABASE_DIR}"
		chmod -R g+rw "${LOGSTASH_DATABASE_DIR}"
		
		chown -R ${USER}:root "${LOGSTASH_LOG_PATH}"
		chgrp users "${LOGSTASH_LOG_PATH}"
		chmod g+rw "${LOGSTASH_LOG_PATH}"
		
		chgrp users "${JAVA_CONF_PATH}"
		chmod g+rw "${JAVA_CONF_PATH}"
	fi
}

daemon_debug() {
	if daemon_status; then
		echo ${DNAME} is already running
		exit $?
	else
		# Clear Log
		echo "Starting [${DNAME}] #DEBUGING# with user [${USER}] using command: ( JAVA_OPTS=${JAVA_ARGUMENTS} ${LOGSTASH_BIN_PATH} ${LOGSTASH_BIN_ARGS} )" > "$LOGSTASH_LOG_PATH"
		
		# Start Debuging
		echo "Starting [${DNAME}] with user [${USER}] using command: ( JAVA_OPTS=${JAVA_ARGUMENTS} ${LOGSTASH_BIN_PATH} ${LOGSTASH_BIN_ARGS} )"
		echo "$LOGSTASH_LOG_MESSAGE"
		
		# Fix Configuration File Permissions
		fix_permissions
		
		# Run Logstash
		su - ${USER} -c "JAVA_OPTS=\"$JAVA_ARGUMENTS\" ${LOGSTASH_BIN_PATH} ${LOGSTASH_BIN_ARGS}"
		
		exit 0
	fi
}

start_daemon () {
	# Logstash Bin & Java Varables
	echo "Starting ${DNAME}. $(date) [${DNAME}] ( $LOGSTASH_BIN_PATH )" > "$LOGSTASH_LOG_PATH"
	echo " ...Might take a moment to be fully initialize logstash... please wait." >> "$LOGSTASH_LOG_PATH"
	echo "$LOGSTASH_LOG_MESSAGE"
	echo "Starting with: ( JAVA_OPTS=${JAVA_ARGUMENTS} ${LOGSTASH_BIN_PATH} ${LOGSTASH_BIN_ARGS} )" >> "$LOGSTASH_LOG_PATH"
	echo "Using Elasticsearch database at ${LOGSTASH_DATABASE_DIR}." >> "$LOGSTASH_LOG_PATH"
	
	# Fix Configuration File Permissions
	fix_permissions
	
	# Setup Enverment Varables
	export HOME=${INSTALL_DIR}/var
	export JAVA_OPTS="$JAVA_ARGUMENTS" 
	
	# Run Logstash
	start-stop-daemon -S -q -m -b -N 19 -c ${USER} -u ${USER} -p ${PID_FILE} -x ${LOGSTASH_BIN_PATH} -- ${LOGSTASH_BIN_ARGS}  # Run Logstash inside of java using start-stop-daemon as user logstash
}

stop_daemon () {
	start-stop-daemon -K -q -u ${USER} -p ${PID_FILE}
	wait_for_status 1 20 || start-stop-daemon -K -s 9 -q -p ${PID_FILE}
}

daemon_status () {
	start-stop-daemon -K -q -t -u ${USER} -p ${PID_FILE}
}

wait_for_status () {
	counter=$2
	while [ ${counter} -gt 0 ]; do
		daemon_status
		[ $? -eq $1 ] && return
		let counter=counter-1
		sleep 1
	done
	return 1
}


case $1 in
	start)
		if daemon_status; then
			echo ${DNAME} is already running
			exit 0
		else
			echo Starting ${DNAME} ...
			start_daemon
			exit $?
		fi
		;;
	stop)
		if daemon_status; then
			echo Stopping ${DNAME} ...
			stop_daemon
			exit $?
		else
			echo ${DNAME} is not running
			exit 0
		fi
		;;
	restart)
		stop_daemon
		start_daemon
		exit $?
		;;
	status)
		if daemon_status; then
			echo ${DNAME} is running
			exit 0
		else
			echo ${DNAME} is not running
			exit 1
		fi
		;;
	debug)
		daemon_debug
		;;
	log)
		echo "$LOGSTASH_LOG_PATH"
		exit 0
	;;
	*)
		echo "Usage: $0 {start|stop|restart|status|debug|log}"
		exit 1
		;;
esac