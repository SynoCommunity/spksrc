#!/bin/sh

# Package
PACKAGE="tt-rss"
DNAME="Tiny Tiny RSS"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
WEB_DIR="/var/services/web"
PATH="${INSTALL_DIR}/bin:${PATH}"
BUILDNUMBER="$(/bin/get_key_value /etc.defaults/VERSION buildnumber)"
USER="$([ "${BUILDNUMBER}" -ge "4418" ] && echo -n http || echo -n nobody)"

TTRSS="${WEB_DIR}/${PACKAGE}/update.php"
HT_ACCESS_FILE="${WEB_DIR}/${PACKAGE}/.htaccess"
PID_FILE="${INSTALL_DIR}/var/tt-rss.pid"
HT_ACCESS_SECTION_DELIMITER="#Synology PHP"

compute_generated_htaccess_section()
{
    local php_fpm="$1"
    echo "${HT_ACCESS_SECTION_DELIMITER}
AddHandler default-handler .htm .html .shtml
AddHandler php-fastcgi .php
AddType text/html .php
Action php-fastcgi /${php_fpm}-handler.fcgi
${HT_ACCESS_SECTION_DELIMITER}"
}

regenerate_htaccess()
{
    local php_fpm="$1"
    if [ ! -f "${HT_ACCESS_FILE}" ]
    then
        echo "$(compute_generated_htaccess_section ${php_fpm})"
        return 0
    fi
    local temp_file
    local section
    temp_file=$(mktemp --suffix=.htaccess tt-rss.XXXXX)
    section=($(grep -n "${HT_ACCESS_SECTION_DELIMITER}" "${HT_ACCESS_FILE}" | cut -f 1 -d ':'))
    if [ $? -ne 0 ]
    then
        echo "$(compute_generated_htaccess_section ${php_fpm})">"$temp_file"
        cat "${HT_ACCESS_FILE}">>"$temp_file"
    else
        if [ "${#section[@]}" == "2" ]
        then
            local header_end
            local trailer_start
            header_end=$(expr ${section[0]} - 1)
            trailer_start=$(expr ${section[1]} + 1)
            head -n ${header_end} "${HT_ACCESS_FILE}" >"${temp_file}"
            echo "$(compute_generated_htaccess_section ${php_fpm})" >>"${temp_file}"
            tail -n +${trailer_start} "${HT_ACCESS_FILE}" >>"${temp_file}"
        else
            echo "$(compute_generated_htaccess_section ${php_fpm})">"${temp_file}"
            cat "${HT_ACCESS_FILE}">>"$temp_file"
        fi
    fi
    cat "${temp_file}"
    rm "${temp_file}"
    return 0
}

start_daemon ()
{
    source "${INSTALL_DIR}/bin/php-settings.sh"
    if [ ! -z "${php_fpm}" ]
    then
        echo "$(regenerate_htaccess ${php_fpm})" >"${HT_ACCESS_FILE}"
    fi
    start-stop-daemon -S -q -m -b -N 10 -x "${php}" \
        -c ${USER} -u ${USER} -p ${PID_FILE} --  \
        -c "${php_configuration_file}" $(php-options) \
        ${TTRSS} --daemon
}

stop_daemon ()
{
    start-stop-daemon -K -q -u ${USER} -p ${PID_FILE}
    wait_for_status 1 20 || start-stop-daemon -K -s 9 -q -p ${PID_FILE}
}

daemon_status ()
{
    start-stop-daemon -K -q -t -u ${USER} -p ${PID_FILE}
}

wait_for_status ()
{
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
        else
            echo Starting ${DNAME} ...
            start_daemon
        fi
        ;;
    stop)
        if daemon_status; then
            echo Stopping ${DNAME} ...
            stop_daemon
        else
            echo ${DNAME} is not running
        fi
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
    log)
        exit 1
        ;;
    *)
        exit 1
        ;;
esac
