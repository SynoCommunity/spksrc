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

# Logstash File Path Varables
PACKAGE_CONF_PATH="${INSTALL_DIR}/var/package.conf"
source "${PACKAGE_CONF_PATH}"  # Load Logstash File Path Varables

# Java Varables
# JAVA_BINARY="$(which java)"
source "${JAVA_CONF_PATH}"  # Load Java Settings
LOGSTASH_BIN_PATH="${INSTALL_DIR}/logstash/bin/logstash"
LOGSTASH_BIN_ARGS="agent --verbose --config $LOGSTASH_CONFIG_PATH --log $LOGSTASH_LOG_PATH $LOGSTASH_PARAMETERS_TUNING"
[ -n "$JAVA_HEAP_SIZE_MAX" ] && JAVA_ARGUMENTS="LS_HEAP_SIZE=$JAVA_HEAP_SIZE_MAX ${JAVA_ARGUMENTS}"  # Set Java Heap Size into string varable
[ -n "$JAVA_HEAP_SIZE_INITIAL" ] && JAVA_ARGUMENTS="-XX:InitialHeapSize=$JAVA_HEAP_SIZE_INITIAL ${JAVA_ARGUMENTS}"

# Start & Stop Varables
PID_FILE="/var/run/${PACKAGE}.pid"

fix_permissions() {
	# Set group and permissions on configuration files & logs
	chgrp users "${LOGSTASH_CONFIG_PATH}"
	chmod g+rw "${LOGSTASH_CONFIG_PATH}"
	
	chgrp -R users "${LOGSTASH_DATABASE_DIR}"
	chmod -R g+rw "${LOGSTASH_DATABASE_DIR}"
	
	touch "${LOGSTASH_LOG_PATH}"
	chgrp users "${LOGSTASH_LOG_PATH}"
	chmod g+rw "${LOGSTASH_LOG_PATH}"
	
	chgrp users "${JAVA_CONF_PATH}"
	chmod g+rw "${JAVA_CONF_PATH}"
	
	touch "${PID_FILE}"
	chgrp users "${PID_FILE}"
	chmod g+rw "${PID_FILE}"
}

daemon_debug() {
	if daemon_status; then
		echo ${DNAME} is already running
		exit $?
	else
		# Fix Configuration File Permissions
		fix_permissions
 	
		# Start Debuging
		echo "Starting [${DNAME}] with user [${USER}] using command: ( JAVA_OPTS=-Des.path.data=${LOGSTASH_DATABASE_DIR} $JAVA_ARGUMENTS ${LOGSTASH_BIN_PATH} ${LOGSTASH_BIN_ARGS} )"	
		
		# Run Logstash
		su - ${USER} -c "JAVA_OPTS=\"-Des.path.data=${LOGSTASH_DATABASE_DIR} $JAVA_ARGUMENTS\" ${LOGSTASH_BIN_PATH} ${LOGSTASH_BIN_ARGS}"
		exit 0
	fi
}

start_daemon () {
	# Logstash Bin & Java Varables
	rm -f "$LOGSTASH_LOG_PATH"
	echo "Starting ${DNAME}. $(date) [${DNAME}] ( $LOGSTASH_BIN_PATH )" >> "$LOGSTASH_LOG_PATH"
	echo " ...Might take a moment to be fully initialize logstash... please wait." >> "$LOGSTASH_LOG_PATH"
	[ -e "${LOGSTASH_CONFIG_PATH}" ] || ( cp "${INSTALL_DIR}/logstash-sample.conf" "${LOGSTASH_CONFIG_PATH}"; echo "Logstash Config not found, loading sample config." >> "$LOGSTASH_LOG_PATH" )
	[ -e "${JAVA_CONF_PATH}" ] || ( cp "${INSTALL_DIR}/var/logstash-java.conf" "${JAVA_CONF_PATH}"; echo "Java Config not found, loading sample config." >> "$LOGSTASH_LOG_PATH" )
	echo "Starting with: ( JAVA_OPTS=-Des.path.data=${LOGSTASH_DATABASE_DIR} $JAVA_ARGUMENTS ${LOGSTASH_BIN_PATH} ${LOGSTASH_BIN_ARGS} )" >> "$LOGSTASH_LOG_PATH"
	echo "Using Elasticsearch database at ${LOGSTASH_DATABASE_DIR}." >> "$LOGSTASH_LOG_PATH"
	
	# Fix Configuration File Permissions
	fix_permissions
	
	# Setup Enverment Varables
	export HOME=${INSTALL_DIR}/var
	export JAVA_OPTS="-Des.path.data=${LOGSTASH_DATABASE_DIR} $JAVA_ARGUMENTS" 
	export $JAVA_LS_HEAP_SIZE
	
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