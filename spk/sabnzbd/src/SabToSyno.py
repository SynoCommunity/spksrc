#!/usr/local/python3
#
# Created by LapinFou.
# https://forums.sabnzbd.org/viewtopic.php?f=9&p=122338
#
#   date     | version |     comment
#---------------------------------------
# 2020-09-13 |   1.0   | Initial version
# 2020-09-19 |   1.1   | Code clean-up
# 2020-09-25 |   1.2   | Removed 7zip recursive unpack option
#

# get library modules
import sys
import os
import subprocess
import shutil

scriptVersionIs = 1.2

# If empty, then no move
# Format must be synology full path (case sensitive). For ex: /volume1/video/News
MoveToThisFolder = ''
# If MoveMergeSubFolder = False, then equivalent to unix command:
# mv -rf srcFolder destFolder
# In case of conflict between an already existing sub-folder in the destination folder:
#   the destination sub-folder will be replaced with source sub-folder
#
# If MoveMergeSubFolder = True, then equivalent to unix command:
# cp -rf srcFolder/* destFolder/
# rm -rf srcFolder
# In case of conflict between an already existing sub-folder in the destination folder:
#   the destination sub-folder will be merged with source sub-folder (kind of incremental)
MoveMergeSubFolder = True

########################
# ----- Functions ---- #
########################
# Get information from SABnzbd
try:
    (scriptname,directory,orgnzbname,jobname,reportnumber,category,group,postprocstatus,url) = sys.argv
except:
    print("No commandline parameters found")
    sys.exit(1)

# add folder in the Syno index database (DLNA server)
def addToSynoIndex(DirName):
    print("Adding folder in the DLNA server")
    synoindex_cmd = ['/usr/syno/bin/synoindex', '-A', DirName]
    try:
        p = subprocess.Popen(synoindex_cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        out, err = p.communicate()
        out = out.decode('ascii')
        err = err.decode('ascii')
        if (str(out) == ''):
            print("synoindex result: " + DirName + " successfully added to Synology database")
        else:
            print("synoindex result: " + str(out))
        if (str(err) != ''):
            print("synoindex failed: " + str(err))
    except OSError as e:
        print("Unable to run synoindex: "+str(e))
    return

########################
# --- Main Program --- #
########################
print("Running SabToSyno Python3 script (v%s)" %scriptVersionIs)
print("")

# Change current directory to SABnzbd "complete" directory
os.chdir(directory)

# display directory of the SABnzbd job
currentFolder = os.getcwd()
print("Current folder is " + currentFolder)

# Move current folder to an another destination if the option has been configured
if (MoveToThisFolder != ''):
    print("")
    print(100*'-')
    print("Moving folder:")
    print(currentFolder)
    print("to:")
    print(MoveToThisFolder)
    # Check if destination folder does exist and can be written
    # If destination doesn't exist, it will be created
    if (os.access(MoveToThisFolder, os.F_OK) == False):
        os.makedirs(MoveToThisFolder)
        os.chmod(MoveToThisFolder, 0o777)
    # Check write access
    if (os.access(MoveToThisFolder, os.W_OK) == False):
        print(100*'#')
        print("File(s)/Folder(s) can not be move in %s" %(MoveToThisFolder))
        print("Please, check Unix permissions")
        print(100*'#')
        sys.exit(1)

    # If MoveMergeSubFolder is True, then move all file(s)/folder(s) to destination
    # then remove source folder
    destFolder = os.path.join(MoveToThisFolder, os.path.split(currentFolder)[-1])
    if (MoveMergeSubFolder):
        print("    Info: Merge option is ON (incremental copy)")
        try:
            synoCopy_cmd = ['/bin/cp', '-Rpf', os.path.abspath(currentFolder), MoveToThisFolder]
            p = subprocess.Popen(synoCopy_cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            out, err = p.communicate()
            out = out.decode('ascii')
            err = err.decode('ascii')
            if (str(err) != ''):
                print("Copy failed: " + str(err))
                sys.exit(1)
        except OSError as e:
            print("Unable to run cp: " + str(e))
            sys.exit(1)
        os.chdir(MoveToThisFolder)
        shutil.rmtree(currentFolder)
    # If MoveMergeSubFolder is False, remove folder with same (if exists)
    # then move all file(s)/folder(s) to destination and remove source folder
    else:
        print("    Info: Merge option is OFF (existing data will be deleted and replaced)")
        # Remove if destination already exist
        if os.path.exists(destFolder):
            shutil.rmtree(destFolder)
        shutil.move(currentFolder, MoveToThisFolder)
else:
    # If move is not enabled, the current folder will be indexed
    destFolder = currentFolder

# Add multimedia files in the Syno DLNA
print("")
print(100*'-')
addToSynoIndex(destFolder)
print("")
print("Moving and indexing file(s) done!")

# Success code
sys.exit(0)