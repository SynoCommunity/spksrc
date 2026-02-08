#! /bin/bash

# start/stop script derived from ntopng/packages/etc/init.d/ntopng

if [ -z "${SYNOPKG_PKGNAME}" ] || [ -z "${SYNOPKG_DSM_VERSION_MAJOR}" ]; then
    echo "Error: Environment variables are not set." 1>&2;
    echo "Please run me using synopkg instead. Example: 'synopkg start ntopng'" 1>&2;
    exit 1
fi

if [ "$SYNOPKG_DSM_VERSION_MAJOR" -lt 7 ]; then
    # define SYNOPKG_PKGVAR for forward compatibility
    SYNOPKG_PKGVAR="${SYNOPKG_PKGDEST}/var"
fi

SERVICE_CFG_FILE="${SYNOPKG_PKGVAR}/ntopng.conf"
SERVICE_COMMAND="${SYNOPKG_PKGDEST}/bin/ntopng ${SERVICE_CFG_FILE}"
SERVICE_LOG_FILE="${SYNOPKG_PKGVAR}/ntopng.log"

ERROR=0

error_handler() {
    EXIT_ON_END=$0

    if [ -n "${MSG}" ]; then
        if [ ${ERROR} -gt 0 ]; then
            echo -n "${MSG} [FAILED]"; echo
        else
            echo "[OK]"; echo
        fi
    fi

    if [ "$EXIT_ON_END" == "quit" ]; then
        exit 99
    fi
}

get_ntopng_pid() {
    PID=0

    if [ -f "${SERVICE_CFG_FILE}" ]; then
        PID_FILE=$(grep -v '^#' ${SERVICE_CFG_FILE} | grep -oP '\-\-pid[[:space:]]*\K.*')
        if [ -z "$PID_FILE" ]; then
            return 0
        fi
    fi

    if [ -f "$PID_FILE" ]; then
        PID=$(cat $PID_FILE)
        if [ -n "${PID}" -a "${PID}" -gt 0 ]; then
            IS_EXISTING=$(ps auxw | grep -w "$PID" | grep -v grep | wc -l)
            if [ "${IS_EXISTING}" -gt 0 ]; then
                return "$PID"
            fi
        fi
        /bin/rm $PID_FILE
    fi

    return 0
}

start_ntopng() {
    RETVAL=0

    echo -n "Starting ntopng: "

    get_ntopng_pid
    if [ "${PID}" -gt 0 ]; then
        MSG="ntopng already running. Quitting"
        ERROR=1
        RETVAL=1
        error_handler "quit"
        exit 99
    fi
    if [ ! -d "${SERVICE_LOG_FILE%/*}" ]; then
       mkdir -p "${SERVICE_LOG_FILE%/*}"
       touch  ${SERVICE_LOG_FILE}
       chmod 777  ${SERVICE_LOG_FILE}
    fi
    $SERVICE_COMMAND >> ${SERVICE_LOG_FILE} &

    for i in {1..20}
    do
        get_ntopng_pid
        if [ "${PID}" -gt 0 ]; then
            MSG="Started ntopng with PID $PID"
            ERROR=0
            break
        else
            MSG="Unable to start ntopng"
            ERROR=1
            sleep 1
        fi
    done

    if [ $ERROR -gt 0 ]; then
        error_handler "quit"
    else
        echo -n "[OK]"; echo
    fi
}


stop_ntopng() {
    RETVAL=0
    echo -n "Stopping ntopng: "

    get_ntopng_pid

    if [ -z "${PID}" ]; then
        return 0
    fi

    if [ "${PID}" -eq 0 ]; then
        if [ ! -f "${SERVICE_CFG_FILE}" ]; then
            MSG="Missing ${SERVICE_CFG_FILE}"
            ERROR=1
            RETVAL=1
            error_handler
        fi

        return 0
    fi

    MSG=
    for i in {1..10}
    do  
        get_ntopng_pid

        if [ "${PID}" -gt 0 ] && [ -d "/proc/${PID}" ]; then
            if grep -q ntopng "/proc/${PID}/comm"; then
              kill -15 "$PID" &> /dev/null
              MSG="Sent kill to ntop PID $PID"
              sleep 1
            else
              MSG="Refusing to kill a process (PID=${PID}) which is not ntopng"
              ERROR=1
              RETVAL=1
              error_handler "quit"
            fi
        else
            MSG="Stopped ntopng PID $PID"
            break
        fi  
    done
    ERROR=0

    error_handler
}

status_ntopng() {

    if [ ! -f "${SERVICE_CFG_FILE}" ]; then
        MSG="Configuration file is missing. Quitting"
        ERROR=1
        RETVAL=1
        error_handler "quit"
    fi

    get_ntopng_pid
    if [ "${PID}" -gt 0 ]; then
        echo "ntopng running as ${PID}"
    else
        echo "ntopng is not running"
        exit 1
    fi

    return 0
}


########

case "$1" in
    start)
        start_ntopng;
        ;;

    stop)
        stop_ntopng;
        ;;

    status)
        status_ntopng;
        ;;

    restart)
        stop_ntopng;
        start_ntopng;
        ;;

    *)
        echo "Usage: ${0} {start|stop|restart|status}]"
        exit 1
esac

exit 0
