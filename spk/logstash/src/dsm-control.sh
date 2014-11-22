#!/bin/sh
# Copyright (c) 2013-2014 AustinSaintAubin. All rights reserved.
# https://github.com/mrlesmithjr/Logstash_Kibana3/blob/master/install_logstash_kibana_ubuntu.sh
# logstash-1.3.3-noarch-0014

# PATH="${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
source /root/.profile  # Get Environment Variables from Root Profile

# Package Varables
PACKAGE_NAME_SIMPLE="@package_name_simple@"  # "$(echo "$SYNOPKG_PKGNAME" | awk '{print tolower($0)}' | sed -e 's/ /_/g')"
PACKAGE_DIR="@package_dir@"  # "$SYNOPKG_PKGDEST"
PACKAGE_UPGRADE_FLAG="@package_upgrade_flag@"
DNAME="$PACKAGE_NAME_SIMPLE"

# Logstash Varables
LOGSTASH_CONFIG_PATH="@logstash_config_path@"
LOGSTASH_DATABASE_DIR="@logstash_database_dir@"  # https://logstash.jira.com/browse/LOGSTASH-125
LOGSTASH_LOG_PATH="@logstash_log_path@"

# Logstash Bin & Java Varables
# JAVA_BINARY="$(which java)"
LOGSTASH_BIN_PATH="${PACKAGE_DIR}/logstash/bin/logstash"
LOGSTASH_BIN_ARGS="agent --config $LOGSTASH_CONFIG_PATH --log $LOGSTASH_LOG_PATH @logstash_parameters_tuning@"

# Tuning Varables
JAVA_ARGUMENTS="@java_arguments_tuning@"
# Java Heap Size: ( https://blog.codecentric.de/en/2012/07/useful-jvm-flags-part-4-heap-tuning/ ) 
# Both flags expect a value in bytes but also support a shorthand notation where “k” or “K” represent “kilo”, “m” or “M” represent “mega”, and “g” or “G” represent “giga”.
# For example, the following command line starts the Java class “MyApp” setting an initial heap size of 128 megabytes and a maximum heap size of 2 gigabytes:
# -Xms and -Xmx (or: -XX:InitialHeapSize and -XX:MaxHeapSize).  Example: java -XX:InitialHeapSize=128m -XX:MaxHeapSize=2g MyApp
JAVA_HEAP_SIZE_MAX="@java_heap_size_max@"  # -XX:MaxHeapSize=1g      LS_HEAP_SIZE=1g
# [ -n "$JAVA_HEAP_SIZE_MAX" ] && JAVA_ARGUMENTS="LS_HEAP_SIZE=$JAVA_HEAP_SIZE_MAX ${JAVA_ARGUMENTS}"  # 
JAVA_HEAP_SIZE_INITIAL="@java_heap_size_initial@"  # -XX:InitialHeapSize=512m
[ -n "$JAVA_HEAP_SIZE_INITIAL" ] && JAVA_ARGUMENTS="-XX:InitialHeapSize=$JAVA_HEAP_SIZE_INITIAL ${JAVA_ARGUMENTS}"

# Start & Stop Varables
PID_FILE="/var/run/${PACKAGE_NAME_SIMPLE}.pid"

daemon_debug() {
    if daemon_status; then
        echo ${DNAME} is already running
        exit $?
    else
	    echo "Starting [${PACKAGE_NAME_SIMPLE}] with: ( JAVA_OPTS=-Des.path.data=${LOGSTASH_DATABASE_DIR} $JAVA_ARGUMENTS LS_HEAP_SIZE=$JAVA_HEAP_SIZE_MAX ${LOGSTASH_BIN_PATH} ${LOGSTASH_BIN_ARGS} )"	
		
		# Run Logstash
		JAVA_OPTS="-Des.path.data=${LOGSTASH_DATABASE_DIR} $JAVA_ARGUMENTS" LS_HEAP_SIZE=$JAVA_HEAP_SIZE_MAX ${LOGSTASH_BIN_PATH} ${LOGSTASH_BIN_ARGS}
        exit 0
    fi
}

start_daemon () {
	rm -f "$LOGSTASH_LOG_PATH"
	echo "Starting ${PACKAGE_NAME_SIMPLE}. $(date) [${PACKAGE_NAME_SIMPLE}] ( $LOGSTASH_BIN_PATH )" >> "$LOGSTASH_LOG_PATH"
	echo " ...Might take a moment to be fully initialize logstash... please wait." >> "$LOGSTASH_LOG_PATH"
	[ -e "${LOGSTASH_CONFIG_PATH}" ] || ( cp "${SYNOPKG_PKGDEST}/logstash-sample.conf" "${LOGSTASH_CONFIG_PATH}"; echo "Config not found, loading sample config." >> "$LOGSTASH_LOG_PATH" )
	echo "Starting with: ( JAVA_OPTS=-Des.path.data=${LOGSTASH_DATABASE_DIR} $JAVA_ARGUMENTS LS_HEAP_SIZE=$JAVA_HEAP_SIZE_MAX ${LOGSTASH_BIN_PATH} ${LOGSTASH_BIN_ARGS} )" >> "$LOGSTASH_LOG_PATH"
	echo "Using Elasticsearch database at ${LOGSTASH_DATABASE_DIR}." >> "$LOGSTASH_LOG_PATH"
	
	# Run Logstash
	### JAVA_OPTS="-Des.path.data=${LOGSTASH_DATABASE_DIR} $JAVA_ARGUMENTS" LS_HEAP_SIZE=$JAVA_HEAP_SIZE_MAX ${LOGSTASH_BIN_PATH} ${LOGSTASH_BIN_ARGS}
	export JAVA_OPTS="-Des.path.data=${LOGSTASH_DATABASE_DIR} $JAVA_ARGUMENTS"
	export LS_HEAP_SIZE=$JAVA_HEAP_SIZE_MAX
	nohup ${LOGSTASH_BIN_PATH} ${LOGSTASH_BIN_ARGS} >> "$LOGSTASH_LOG_PATH" 2>&1&
	echo $! > "$PID_FILE"
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
    *)
    	echo "Usage: $0 {start|stop|restart|status|debug}"
        exit 1
        ;;
esac