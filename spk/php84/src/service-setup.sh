#!/bin/bash
# PHP 8.4 Service Setup Script for spksrc framework

# Service command - must include LD_LIBRARY_PATH for bundled libraries
# and all arguments in a single command
SERVICE_COMMAND="env LD_LIBRARY_PATH=${SYNOPKG_PKGDEST}/lib ${SYNOPKG_PKGDEST}/sbin/php-fpm -c ${SYNOPKG_PKGVAR}/etc/php.ini -y ${SYNOPKG_PKGVAR}/etc/php-fpm.conf"

# PID file location (PHP-FPM writes its own PID file)
PID_FILE="${SYNOPKG_PKGVAR}/run/php-fpm.pid"

# PHP-FPM daemonizes itself, no background needed
SVC_BACKGROUND=

# Don't write PID - PHP-FPM handles it
SVC_WRITE_PID=

# Extension directory
EXT_DIR="${SYNOPKG_PKGDEST}/lib/php/extensions/no-debug-non-zts-20240924"

# Post-installation actions - create configuration files
service_postinst() {
    # Create directories
    mkdir -p "${SYNOPKG_PKGVAR}/etc"
    mkdir -p "${SYNOPKG_PKGVAR}/etc/conf.d"
    mkdir -p "${SYNOPKG_PKGVAR}/etc/php-fpm.d"
    mkdir -p "${SYNOPKG_PKGVAR}/log"
    mkdir -p "${SYNOPKG_PKGVAR}/run"
    mkdir -p "${SYNOPKG_PKGVAR}/tmp"

    # Allow 'http' user (CGI executor) to write extension configs
    chmod 777 "${SYNOPKG_PKGVAR}/etc/conf.d"

    # Create php.ini if it doesn't exist
    if [ ! -f "${SYNOPKG_PKGVAR}/etc/php.ini" ]; then
        cat > "${SYNOPKG_PKGVAR}/etc/php.ini" << PHPINI
[PHP]
; PHP 8.4.15 Configuration for Synology DSM
extension_dir = "${EXT_DIR}"

engine = On
short_open_tag = Off
precision = 14
output_buffering = 4096
zlib.output_compression = Off
implicit_flush = Off
serialize_precision = -1

error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT
display_errors = Off
display_startup_errors = Off
log_errors = On
error_log = ${SYNOPKG_PKGVAR}/log/php_errors.log
log_errors_max_len = 1024
ignore_repeated_errors = Off
ignore_repeated_source = Off
report_memleaks = On

max_execution_time = 60
max_input_time = 60
memory_limit = 256M

variables_order = "GPCS"
request_order = "GP"
register_argc_argv = Off
auto_globals_jit = On
post_max_size = 64M
default_mimetype = "text/html"
default_charset = "UTF-8"

file_uploads = On
upload_max_filesize = 64M
max_file_uploads = 20

doc_root =
user_dir =
enable_dl = Off
cgi.fix_pathinfo = 0

date.timezone = "UTC"

session.save_handler = files
session.save_path = "${SYNOPKG_PKGVAR}/tmp"
session.use_strict_mode = 1
session.use_cookies = 1
session.use_only_cookies = 1
session.name = PHPSESSID
session.auto_start = 0
session.cookie_lifetime = 0
session.cookie_path = /
session.cookie_domain =
session.cookie_httponly = 1
session.cookie_samesite = "Lax"
session.serialize_handler = php
session.gc_probability = 1
session.gc_divisor = 1000
session.gc_maxlifetime = 1440
session.sid_length = 32
session.sid_bits_per_character = 5
PHPINI
    fi

    # Create php-fpm.conf if it doesn't exist
    if [ ! -f "${SYNOPKG_PKGVAR}/etc/php-fpm.conf" ]; then
        cat > "${SYNOPKG_PKGVAR}/etc/php-fpm.conf" << FPMCONF
[global]
pid = ${SYNOPKG_PKGVAR}/run/php-fpm.pid
error_log = ${SYNOPKG_PKGVAR}/log/php-fpm.log
log_level = notice
daemonize = yes

include=${SYNOPKG_PKGVAR}/etc/php-fpm.d/*.conf
FPMCONF
    fi

    # Create default pool if it doesn't exist
    if [ ! -f "${SYNOPKG_PKGVAR}/etc/php-fpm.d/www.conf" ]; then
        cat > "${SYNOPKG_PKGVAR}/etc/php-fpm.d/www.conf" << POOLCONF
[www]
user = ${SYNOPKG_PKGNAME}
group = ${SYNOPKG_PKGNAME}

listen = ${SYNOPKG_PKGVAR}/run/php-fpm.sock
listen.owner = ${SYNOPKG_PKGNAME}
listen.group = ${SYNOPKG_PKGNAME}
listen.mode = 0666

pm = dynamic
pm.max_children = 5
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 3
pm.max_requests = 500

slowlog = ${SYNOPKG_PKGVAR}/log/php-fpm.slow.log
request_slowlog_timeout = 30s
catch_workers_output = yes
decorate_workers_output = no
POOLCONF
    fi

    # Process wizard selections for extensions
    # Complete profile: enable all extensions
    if [ "${wizard_profile_complete}" = "true" ]; then
        for ext_file in "${EXT_DIR}"/*.so; do
            if [ -f "$ext_file" ]; then
                ext_name=$(basename "$ext_file" .so)
                enable_extension "$ext_name"
            fi
        done
    # Minimal profile
    elif [ "${wizard_profile_minimal}" = "true" ]; then
        [ "${wizard_min_opcache}" = "true" ] && enable_extension "opcache"
        [ "${wizard_min_mbstring}" = "true" ] && enable_extension "mbstring"
        [ "${wizard_min_pdo}" = "true" ] && enable_extension "pdo"
        [ "${wizard_min_pdo_mysql}" = "true" ] && { enable_extension "mysqlnd"; enable_extension "pdo_mysql"; }
        [ "${wizard_min_curl}" = "true" ] && enable_extension "curl"
        [ "${wizard_min_openssl}" = "true" ] && enable_extension "openssl"
        [ "${wizard_min_gd}" = "true" ] && enable_extension "gd"
    # Standard profile (default)
    else
        [ "${wizard_std_opcache}" = "true" ] && enable_extension "opcache"
        [ "${wizard_std_pdo}" = "true" ] && enable_extension "pdo"
        [ "${wizard_std_pdo_mysql}" = "true" ] && { enable_extension "mysqlnd"; enable_extension "pdo_mysql"; }
        [ "${wizard_std_mbstring}" = "true" ] && enable_extension "mbstring"
        [ "${wizard_std_curl}" = "true" ] && enable_extension "curl"
        [ "${wizard_std_openssl}" = "true" ] && enable_extension "openssl"
        [ "${wizard_std_gd}" = "true" ] && enable_extension "gd"
        [ "${wizard_std_tokenizer}" = "true" ] && enable_extension "tokenizer"
        [ "${wizard_std_bcmath}" = "true" ] && enable_extension "bcmath"
        [ "${wizard_std_xml}" = "true" ] && enable_extension "xml"
        [ "${wizard_std_zip}" = "true" ] && enable_extension "zip"
    fi
}

# Enable an extension by creating its .ini file
enable_extension() {
    local ext_name="$1"
    local ext_file="${ext_name}.so"
    local prefix="50"

    # Load order: 20=core, 50=standard, 70=dependent
    case "$ext_name" in
        session|sockets|mysqlnd|pdo|igbinary) prefix="20" ;;
        ev|event|msgpack|mysqli|pdo_mysql|redis|memcached) prefix="70" ;;
    esac

    local ini_file="${SYNOPKG_PKGVAR}/etc/conf.d/${prefix}-${ext_name}.ini"

    if [ -f "${EXT_DIR}/${ext_file}" ]; then
        case "$ext_name" in
            opcache|xdebug)
                echo "zend_extension=${ext_file}" > "${ini_file}"
                ;;
            *)
                echo "extension=${ext_file}" > "${ini_file}"
                ;;
        esac

        # Extension-specific config
        case "$ext_name" in
            opcache)
                cat >> "${ini_file}" << 'OPCACHE'
opcache.enable=1
opcache.enable_cli=0
opcache.memory_consumption=128
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=10000
opcache.revalidate_freq=2
opcache.fast_shutdown=1
OPCACHE
                ;;
            apcu)
                cat >> "${ini_file}" << 'APCU'
apc.enabled=1
apc.shm_size=32M
apc.ttl=7200
apc.enable_cli=0
APCU
                ;;
        esac
    fi
}

# Pre-start actions
service_prestart() {
    # Ensure directories exist
    mkdir -p "${SYNOPKG_PKGVAR}/run"
    mkdir -p "${SYNOPKG_PKGVAR}/log"
    mkdir -p "${SYNOPKG_PKGVAR}/tmp"
    mkdir -p "${SYNOPKG_PKGVAR}/etc/conf.d"

    # Allow 'http' user (CGI executor) to write extension configs
    chmod 777 "${SYNOPKG_PKGVAR}/etc/conf.d"

    # Verify configuration exists
    if [ ! -f "${SYNOPKG_PKGVAR}/etc/php-fpm.conf" ]; then
        echo "ERROR: PHP-FPM configuration not found"
        return 1
    fi

    # Test configuration with LD_LIBRARY_PATH
    env LD_LIBRARY_PATH="${SYNOPKG_PKGDEST}/lib" \
        "${SYNOPKG_PKGDEST}/sbin/php-fpm" \
        -c "${SYNOPKG_PKGVAR}/etc/php.ini" \
        -y "${SYNOPKG_PKGVAR}/etc/php-fpm.conf" \
        -t > /dev/null 2>&1

    if [ $? -ne 0 ]; then
        echo "ERROR: PHP-FPM configuration test failed"
        env LD_LIBRARY_PATH="${SYNOPKG_PKGDEST}/lib" \
            "${SYNOPKG_PKGDEST}/sbin/php-fpm" \
            -c "${SYNOPKG_PKGVAR}/etc/php.ini" \
            -y "${SYNOPKG_PKGVAR}/etc/php-fpm.conf" \
            -t 2>&1
        return 1
    fi

    return 0
}

# Post-stop actions
service_poststop() {
    rm -f "${PID_FILE}"
    rm -f "${SYNOPKG_PKGVAR}/run/php-fpm.sock" 2>/dev/null
    return 0
}
