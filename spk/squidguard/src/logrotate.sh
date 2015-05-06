#!/bin/sh
# Script for log rotate with compression and purge after 5 rotations

# Log directory
LOGDIR="/usr/local/squidguard/var/logs"
# Maximum number of archive logs to keep
MAXNUM=5

if [ ! -w $LOGDIR -o ! -x $LOGDIR ]; then
	echo "$0: you don't have the appropriate permission in $LOGDIR" >&2
	exit 1
fi

for LOGFILE in `ls -1 ${LOGDIR}/*.log `;do
	## Check if the last log archive exists and delete it.
	if [ -f "$LOGFILE.$MAXNUM.gz" ]; then
		echo "Purge old log $LOGFILE.$MAXNUM.gz"
		/bin/rm "$LOGFILE.$MAXNUM.gz"
	fi

	NUM=`expr $MAXNUM - 1`
	## Check the previous log file.
	while [ $NUM -ge 0 ]
	do
		NUM1=`expr $NUM + 1`
		if [ -f "$LOGFILE.$NUM.gz" ]; then
			echo "Move old log $LOGFILE.$NUM.gz to $LOGFILE.$NUM1.gz"
			/bin/mv "$LOGFILE.$NUM.gz" "$LOGFILE.$NUM1.gz"
		fi
		NUM=`expr $NUM - 1`
	done

	# Compress and clear the log file
	if [ -f "$LOGFILE" ]; then
		echo "Rotate log $LOGFILE to $LOGFILE.0.gz"
		/bin/cp "$LOGFILE" "$LOGFILE.0"
		/bin/cat /dev/null > "$LOGFILE"
		/bin/gzip -f -9 "$LOGFILE.0"
	fi
done
