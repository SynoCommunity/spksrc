#!/bin/sh

# Package
PACKAGE="vim"
DNAME="Vim"


case $1 in
    start)
        exit 0
        ;;
    stop)
        exit 0
        ;;
    status)
	if [ -e /usr/local/bin/vim ]; then
		exit 0
	else
		exit 150
	fi
        ;;
    log)
        exit 0
        ;;
    *)
        exit 1
        ;;
esac
