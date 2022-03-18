#!/bin/sh

# Source package specific variables and functions
SVC_SETUP=$(dirname $0)"/service-setup"
if [ -r "${SVC_SETUP}" ]; then
    . "${SVC_SETUP}"
fi

POSTGRES="${SYNOPKG_PKGDEST}/bin/pg_ctl -D ${DATABASE_DIR}"

case $1 in
  start)
    ${POSTGRES} -l ${LOG_FILE} start
    exit 0
  ;;

  stop)
    ${POSTGRES} stop
    exit 0
  ;;

  status)
    ${POSTGRES} status &> /dev/null && exit 0 || exit 1
  ;;

esac
