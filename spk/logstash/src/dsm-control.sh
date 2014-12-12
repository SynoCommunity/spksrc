#!/bin/sh
# Copyright (c) 2013-2014 AustinSaintAubin. All rights reserved.
# https://github.com/mrlesmithjr/Logstash_Kibana3/blob/master/install_logstash_kibana_ubuntu.sh

# PATH="${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
source /root/.profile  # Get Environment Variables from Root Profile

# Package Varables
PACKAGE="logstash"
DNAME="Logstash"
PACKAGE_DIR="/var/packages/${PACKAGE}/target"  # "$SYNOPKG_PKGDEST"

# Logstash File Path Varables
USER="logstash"
PACKAGE_CONF_PATH="${PACKAGE_DIR}/var/package.conf"
source "${PACKAGE_CONF_PATH}"  # Load Logstash File Path Varables

# Java Varables
# JAVA_BINARY="$(which java)"
source "${JAVA_CONF_PATH}"  # Load Java Settings
LOGSTASH_BIN_PATH="${PACKAGE_DIR}/logstash/bin/logstash"
LOGSTASH_BIN_ARGS="agent --config $LOGSTASH_CONFIG_PATH --log $LOGSTASH_LOG_PATH $LOGSTASH_PARAMETERS_TUNING"
# [ -n "$JAVA_HEAP_SIZE_MAX" ] && JAVA_ARGUMENTS="LS_HEAP_SIZE=$JAVA_HEAP_SIZE_MAX ${JAVA_ARGUMENTS}"  # 
[ -n "$JAVA_HEAP_SIZE_INITIAL" ] && JAVA_ARGUMENTS="-XX:InitialHeapSize=$JAVA_HEAP_SIZE_INITIAL ${JAVA_ARGUMENTS}"


# Start & Stop Varables
PID_FILE="/var/run/${PACKAGE}.pid"

daemon_debug() {
    if daemon_status; then
        echo ${DNAME} is already running
        exit $?
    else
	    echo "Starting [${DNAME}] with: ( JAVA_OPTS=-Des.path.data=${LOGSTASH_DATABASE_DIR} $JAVA_ARGUMENTS LS_HEAP_SIZE=$JAVA_HEAP_SIZE_MAX ${LOGSTASH_BIN_PATH} ${LOGSTASH_BIN_ARGS} )"	
		
		# Run Logstash
		su - ${USER} -c "JAVA_OPTS=\"-Des.path.data=${LOGSTASH_DATABASE_DIR} $JAVA_ARGUMENTS\" LS_HEAP_SIZE=$JAVA_HEAP_SIZE_MAX ${LOGSTASH_BIN_PATH} ${LOGSTASH_BIN_ARGS}"
        exit 0
    fi
}

start_daemon () {
	# Logstash Bin & Java Varables
	rm -f "$LOGSTASH_LOG_PATH"
	echo "Starting ${DNAME}. $(date) [${DNAME}] ( $LOGSTASH_BIN_PATH )" >> "$LOGSTASH_LOG_PATH"
	echo " ...Might take a moment to be fully initialize logstash... please wait." >> "$LOGSTASH_LOG_PATH"
	[ -e "${LOGSTASH_CONFIG_PATH}" ] || ( cp "${PACKAGE_DIR}/logstash-sample.conf" "${LOGSTASH_CONFIG_PATH}"; echo "Logstash Config not found, loading sample config." >> "$LOGSTASH_LOG_PATH" )
	[ -e "${JAVA_CONF_PATH}" ] || ( cp "${PACKAGE_DIR}/var/logstash-java.conf" "${JAVA_CONF_PATH}"; echo "Java Config not found, loading sample config." >> "$LOGSTASH_LOG_PATH" )
	echo "Starting with: ( JAVA_OPTS=-Des.path.data=${LOGSTASH_DATABASE_DIR} $JAVA_ARGUMENTS LS_HEAP_SIZE=$JAVA_HEAP_SIZE_MAX ${LOGSTASH_BIN_PATH} ${LOGSTASH_BIN_ARGS} )" >> "$LOGSTASH_LOG_PATH"
	echo "Using Elasticsearch database at ${LOGSTASH_DATABASE_DIR}." >> "$LOGSTASH_LOG_PATH"
	
	# Run Logstash
	### JAVA_OPTS="-Des.path.data=${LOGSTASH_DATABASE_DIR} $JAVA_ARGUMENTS" LS_HEAP_SIZE=$JAVA_HEAP_SIZE_MAX ${LOGSTASH_BIN_PATH} ${LOGSTASH_BIN_ARGS}
	export JAVA_OPTS="-Des.path.data=${LOGSTASH_DATABASE_DIR} $JAVA_ARGUMENTS"
	export LS_HEAP_SIZE=$JAVA_HEAP_SIZE_MAX
# 	nohup ${LOGSTASH_BIN_PATH} ${LOGSTASH_BIN_ARGS} >> "$LOGSTASH_LOG_PATH" 2>&1&; echo $! > "$PID_FILE"
	su - ${USER} -c "export JAVA_OPTS=\"-Des.path.data=${LOGSTASH_DATABASE_DIR} $JAVA_ARGUMENTS\"; export LS_HEAP_SIZE=$JAVA_HEAP_SIZE_MAX; nohup ${LOGSTASH_BIN_PATH} ${LOGSTASH_BIN_ARGS} >> \"${LOGSTASH_LOG_PATH}\" 2>&1&; echo $! > \"${PID_FILE}\""
}

stop_daemon () {
    kill `cat ${PID_FILE}`
    wait_for_status 1 20 || kill -9 `cat ${PID_FILE}`
    rm -f ${PID_FILE}
}

daemon_status () {
    if [ -f ${PID_FILE} ] && kill -0 `cat ${PID_FILE}` > /dev/null 2>&1; then
        return
    fi
    rm -f ${PID_FILE}
    return 1
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