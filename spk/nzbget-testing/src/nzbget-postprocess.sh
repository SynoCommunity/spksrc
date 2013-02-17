#!/bin/sh 
#
# This file if part of nzbget
#
# Example postprocessing script for NZBGet
#
# Copyright (C) 2008 Peter Roubos <peterroubos@hotmail.com>
# Copyright (C) 2008 Otmar Werner
# Copyright (C) 2008-2013 Andrey Prygunkov <hugbug@users.sourceforge.net>
# Copyright (C) 2012-2013 Antoine Bertin <diaoulael@gmail.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
#

#######################    Usage instructions     #######################
# o  Script will cleanup, join ts-files and rename img-files to iso.
#
# o  To use this script with nzbget set the option "PostProcess" in
#    nzbget configuration file to point to this script file. E.g.:
#        PostProcess=/home/user/nzbget/nzbget-postprocess.sh
#
# o  The script needs a configuration file. An example configuration file
#    is provided in file "nzbget-postprocess.conf". Put the configuration file 
#    into the directory where nzbget's configuration file (nzbget.conf) is located.
#    Then edit the configuration file in any text editor to adjust the settings.
#
# o  You can also edit the script's configuration via web-interface.
#
# o  There are few options, which can be ajdusted for each nzb-file individually.
#
####################### End of Usage instructions #######################


# NZBGet passes following arguments to postprocess-programm as environment
# variables:
#  NZBPP_DIRECTORY    - path to destination dir for downloaded files;
#  NZBPP_NZBNAME      - user-friendly name of processed nzb-file as it is displayed
#                       by the program. The file path and extension are removed.
#                       If download was renamed, this parameter reflects the new name;
#  NZBPP_NZBFILENAME  - name of processed nzb-file. It includes file extension and also
#                       may include full path;
#  NZBPP_CATEGORY     - category assigned to nzb-file (can be empty string);
#  NZBPP_PARSTATUS    - result of par-check:
#                       0 = not checked: par-check is disabled or nzb-file does
#                           not contain any par-files;
#                       1 = checked and failed to repair;
#                       2 = checked and successfully repaired;
#                       3 = checked and can be repaired but repair is disabled.
#  NZBPP_UNPACKSTATUS - result of unpack:
#                       0 = unpack is disabled or was skipped due to nzb-file
#                           properties or due to errors during par-check;
#                       1 = unpack failed;
#                       2 = unpack successful.


# Name of script's configuration file
SCRIPT_CONFIG_FILE="nzbget-postprocess.conf"

# Exit codes
POSTPROCESS_PARCHECK_CURRENT=91
POSTPROCESS_PARCHECK_ALL=92
POSTPROCESS_SUCCESS=93
POSTPROCESS_ERROR=94
POSTPROCESS_NONE=95

# Check if the script is called from nzbget 10.0 or later
if [ "$NZBPP_DIRECTORY" = "" -o "$NZBOP_CONFIGFILE" = "" ]; then
	echo "*** NZBGet post-processing script ***"
	echo "This script is supposed to be called from nzbget (10.0 or later)."
	exit $POSTPROCESS_ERROR
fi
if [ "$NZBOP_UNPACK" = "" ]; then
	echo "[ERROR] This script requires nzbget version at least 10.0-testing-r555 or 10.0-stable."
	exit $POSTPROCESS_ERROR
fi

# Check if postprocessing was disabled in postprocessing parameters 
# (for current nzb-file) via web-interface or via command line with 
# "nzbget -E G O PostProcess=no <ID>"
if [ "$NZBPR_PostProcess" = "no" ]; then
	echo "[WARNING] Post-Process: Post-processing disabled for this nzb-file, exiting"
	exit $POSTPROCESS_NONE
fi

echo "[INFO] Post-Process: Post-processing script successfully started"

# Determine the location of configuration file (it must be stored in
# the directory with nzbget.conf).
ConfigDir="${NZBOP_CONFIGFILE%/*}"
ScriptConfigFile="$ConfigDir/$SCRIPT_CONFIG_FILE"
if [ ! -f "$ScriptConfigFile" ]; then
	echo "[ERROR] Post-Process: Configuration file $ScriptConfigFile not found, exiting"
	exit $POSTPROCESS_ERROR
fi

# Readg configuration file
while read line; do	eval "$line"; done < $ScriptConfigFile

# Check nzbget.conf options
BadConfig=0

if [ "$NZBOP_ALLOWREPROCESS" = "yes" ]; then
	echo "[ERROR] Post-Process: Please disable option \"AllowReProcess\" in nzbget configuration file"
	BadConfig=1
fi

if [ "$NZBOP_UNPACK" != "yes" ]; then
	echo "[ERROR] Post-Process: Please enable option \"Unpack\" in nzbget configuration file"
	BadConfig=1
fi

if [ "$BadConfig" -eq 1 ]; then
	echo "[ERROR] Post-Process: Exiting due to incompatible nzbget configuration"
	exit $POSTPROCESS_ERROR
fi

# Check par status
if [ "$NZBPP_PARSTATUS" -eq 3 ]; then
	echo "[WARNING] Post-Process: Par-check successful, but Par-repair disabled, exiting"
	exit $POSTPROCESS_NONE
fi
if [ "$NZBPP_PARSTATUS" -eq 1 ]; then
	echo "[WARNING] Post-Process: Par-check failed, exiting"
	exit $POSTPROCESS_NONE
fi

# Check unpack status
if [ "$NZBPP_UNPACKSTATUS" -ne 2 ]; then
	echo "[WARNING] Post-Process: Unpack failed or disabled, exiting"
	exit $POSTPROCESS_NONE
fi

# Check if destination directory exists (important for reprocessing of history items)
if [ ! -d "$NZBPP_DIRECTORY" ]; then
	echo "[ERROR] Post-Process: Nothing to post-process: destination directory $NZBPP_DIRECTORY doesn't exist"
	exit $POSTPROCESS_ERROR
fi

cd "$NZBPP_DIRECTORY"

# All checks done, now processing the files

# If download contains only nzb-files move them into nzb-directory
# for further download
# Check if command "wc" exists
wc -l . >/dev/null 2>&1
if [ "$?" -ne 127 ]; then
	AllFilesCount=`ls -1 2>/dev/null | wc -l`
	NZBFilesCount=`ls -1 *.nzb 2>/dev/null | wc -l`
	if [ "$AllFilesCount" -eq "$NZBFilesCount" ]; then
		echo "[INFO] Moving downloaded nzb-files into incoming nzb-directory for further download"
		mv *.nzb $NZBOP_NZBDIR
	fi
fi

# Clean up
echo "[INFO] Post-Process: Cleaning up"
chmod -R a+rw .
rm *.nzb >/dev/null 2>&1
rm *.sfv >/dev/null 2>&1
rm *.1 >/dev/null 2>&1
rm _brokenlog.txt >/dev/null 2>&1
rm *.[pP][aA][rR]2 >/dev/null 2>&1

if [ "$JoinTS" = "yes" ]; then
	# Join any split .ts files if they are named xxxx.0000.ts xxxx.0001.ts
	# They will be joined together to a file called xxxx.0001.ts
	if (ls *.ts >/dev/null 2>&1); then
		echo "[INFO] Post-Process: Joining ts-files"
		tsname=`find . -name "*0001.ts" |awk -F/ '{print $NF}'`
		cat *0???.ts > ./$tsname

        # Remove all the split .ts files
        echo "[INFO] Post-Process: Deleting source ts-files"
        rm *0???.ts >/dev/null 2>&1
	fi
fi

if [ "$RenameIMG" = "yes" ]; then
	# Rename img file to iso
	# It will be renamed to .img.iso so you can see that it has been renamed
	if (ls *.img >/dev/null 2>&1); then
		echo "[INFO] Post-Process: Renaming img-files to iso"
		imgname=`find . -name "*.img" |awk -F/ '{print $NF}'`
		mv $imgname $imgname.iso
	fi
fi

if [ "$SickBeard" = "yes" -a "$NZBPP_CATEGORY" = "$SickBeardCategory" -a -e "$SabToSickBeard" ]; then
	# Call SickBeard's postprocessing script
	echo "[INFO] Post-Process: Running SickBeard's post-processing script"
	$PythonCmd $SabToSickBeard "$NZBPP_DIRECTORY" "$NZBPP_NZBFILENAME" >/dev/null 2>&1
fi

# Check if destination directory was set in postprocessing parameters
# (for current nzb-file) via web-interface or via command line with 
# "nzbget -E G O DestDir=/new/path <ID>"
if [ "$NZBPR_DestDir" != "" ]; then
	mkdir $NZBPR_DestDir
	mv * $NZBPR_DestDir >/dev/null 2>&1
	cd ..
	rmdir $NZBPP_DIRECTORY
fi

# All OK, requesting cleaning up of download queue
exit $POSTPROCESS_SUCCESS
