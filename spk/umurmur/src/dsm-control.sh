#!/bin/sh
# Copyright 2010 Antoine Bertin
# <diaoulael [ignore this] at users.sourceforge period net>
#
# This file is part of syno-packager.
#
# syno-packager is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# syno-packager is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with syno-packager.  If not, see <http://www.gnu.org/licenses/>.

# Common
UMDIR=/usr/local/umurmur
UMVAR=$UMDIR/var
UMLIB=$UMDIR/lib
UMSHR=$UMDIR/share
UMETC=$UMDIR/etc
UMBIN=$UMDIR/bin
UMEXE=$UMBIN/umurmurd
SUEXE=/bin/su
PSEXE=ps
SYNO3APP=/usr/syno/synoman/webman/3rdparty
UMUSR=root

# Files
UMCNF=$UMETC/umurmur.conf
UMPID=$UMVAR/umurmur.pid
UMLOG=$UMVAR/umurmur.log

start_daemon ()
{
	# Log
	echo `date`" : Starting uMurmur..." >> $UMLOG

	# Start uMurmur
	$SUEXE $UMUSR -s /bin/sh -c "LD_LIBRARY_PATH=$UMLIB $UMEXE -r -c $UMCNF -p $UMPID >> $UMLOG 2>&1"
}

stop_daemon ()
{
	# Log
	echo `date`" : Stoping uMurmur..." >> $UMLOG

	# Kill daemon
	if [ -f $UMPID ]; then
		kill `cat $UMPID`
		rm -f $UMPID
		echo " ok"
	else
		echo " error : Can't find PID file!"
		killall umurmurd
	fi
	sleep 1

	# Wait until uMurmur is really dead (may take some time).
	counter=20
	while [ $counter -gt 0 ] 
	do
		daemon_status || exit 0
		let counter=counter-1
		sleep 1
	done

	exit 1
}

reload_daemon ()
{
	if [ -f $UMPID ]; then
		kill -s HUP `cat $UMPID`
		echo " ok"
	else
		echo " error : Can't find PID file!"
	fi
	sleep 1
}

daemon_status ()
{
	[ "`$PSEXE | grep umurmurd | grep -v grep`" != "" ]
}


case $1 in
	start)
		if daemon_status; then
			echo "uMurmur daemon already running!"
			exit 0
		else
			echo "Starting uMurmur daemon..."
			start_daemon
			exit $?
		fi
		;;
	stop)
		echo -n "Stopping uMurmur daemon..."
		stop_daemon
		exit 0
		;;
	restart)
		stop_daemon
		start_daemon
		exit $?
		;;
	reload)
		if daemon_status; then
			reload_daemon
		fi
		exit $?
		;;
	status)
		if daemon_status; then
			echo "Running"
			exit 0
		else
			echo "Not running"
			exit 1
		fi
		;;
	log)
		echo $UMLOG
		exit 0
		;;
	*)
		exit 1
		;;
esac
