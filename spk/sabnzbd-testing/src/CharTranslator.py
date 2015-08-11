#!/usr/local/sabnzbd/env/bin/python -OO
#-*- coding: iso-8859-15 -*-
#
# If a file has been archieved under an ISO-8859 environment and unarchived
# under an UTF8 environment, then you will get an encoding format problem.
# The file will not be readable through SAMBA.
#
# Renaming script for SABnzbd runnning under Synology NAS.
# By default the NZB software is running under UTF-8 encoding format
# in order to correctly handle the french accents (éèàç...) a SABnzbd
# post-script must be run in order to convert the file encoding.
#
# To fix this problem, you must convert the encoding format
# to the UTF8 (default Synology encoding)
# The script is trying to detect if the original file/directory are coming
# from a RAR archive. In this case the unrar command on your Syno system will
# unpack in CP850 format (DOS).
# NB: in all cases, files will be readable through samba, even if the detection
# failed. But converted characters will not be good, ex: Î? instead é
#
# Remark: I guess it should work for any other encoding style. Just replace
# ISO-8859-15 (Western Europe) by the one coresponding to your country:
# http://en.wikipedia.org/wiki/Character_encoding#Common_character_encodings
#
# Done by LapinFou
#   date   | version |     comment
#--------------------------------------
# 12-04-22 |   1.0   | Initial version
# 12-04-22 |   1.1   | Change encoding to ISO-8859-15
#                    | Added CP437 special characters (0x80-0x9A)
# 12-04-24 |   1.2   | Mixed encoding is now supported
#                    | UTF-8 encoding format detected
# 12-04-24 |   1.3   | Fixed typo line 57 (test must be 0xA0, not 0xA1)
# 12-05-24 |   1.4   | Added an exception for "Â" character
#                    | Added 7z unpack
#                    | Added move option
#                    | Added Syno index option
# 13-02-15 |   1.5   | Added an option to activate Sickbear post-processing
#                    | More evoluate move option (merge is now managed)
#                    | Argv1 folder is not renamed anymore (already managed by SABnzbd)
# 13-02-18 |   1.6   | Argv1 folder is now renamed (not managed by SABnzbd)
# 13-02-19 |   1.7   | Changed CP437 detection range
# 13-02-19 |   1.8   | Changed CP437 DOS encoding style with CP850
# 13-10-02 |   1.9   | Fixed an issue with some NZB and Sickbeard option
#                    | In order to simplify the support, the script version is now displayed
#

# get library modules
import sys
import os
import subprocess
import shutil

scriptVersionIs = 1.9

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

# /!\ IndexInSynoDLNA and SickBeardPostProcessing are exclusive
# =============================================================
# If "True", then the folder will be indexed into Synology DLNA
# By default it is "False"
IndexInSynoDLNA = False

# If "True", the folder will be send to SickBeard for Post-Processing
# By default it is "False"
SickBeardPostProcessing = False

# If "True", all .7z files will be unpacked then source .7z file will be deleted
# By default it is "False"
Unpack7z = True

########################
# ----- Functions ---- #
########################

# Special character hex range:
# CP850: 0x80-0xA5 (fortunately not used in ISO-8859-15)
# UTF-8: 1st hex code 0xC2-0xC3 followed by a 2nd hex code 0xA1-0xFF
# ISO-8859-15: 0xA6-0xFF
# The function will detect if fileDirName contains a special character
# If there is special character, detects if it is a UTF-8, CP850 or ISO-8859-15 encoding
def renameFunc(fullPath, fileDirName):
    encodingDetected = False
    # parsing all files/directories in odrer to detect if CP850 is used
    for Idx in range(len(fileDirName)):
        # /!\ detection is done 2char by 2char for UTF-8 special character
        if (len(fileDirName) != 1) & (Idx < (len(fileDirName) - 1)):
            # Detect UTF-8
            if ((fileDirName[Idx] == '\xC2') | (fileDirName[Idx] == '\xC3')) & ((fileDirName[Idx+1] >= '\xA0') & (fileDirName[Idx+1] <= '\xFF')):
                print os.path.join(fullPath, fileDirName) + " -> UTF-8 detected: Nothing to be done"
                encodingDetected = True
                break;
            # Detect CP850
            elif ((fileDirName[Idx] >= '\x80') & (fileDirName[Idx] <= '\xA5')):
                utf8Name = fileDirName.decode('cp850')
                utf8Name = utf8Name.encode('utf-8')
                os.rename(os.path.join(fullPath, fileDirName), os.path.join(fullPath, utf8Name))
                print os.path.join(fullPath, utf8Name) + " -> CP850 detected: Renamed"
                encodingDetected = True
                break;
            # Detect ISO-8859-15
            elif (fileDirName[Idx] >= '\xA6') & (fileDirName[Idx] <= '\xFF'):
                utf8Name = fileDirName.decode('iso-8859-15')
                utf8Name = utf8Name.encode('utf-8')
                os.rename(os.path.join(fullPath, fileDirName), os.path.join(fullPath, utf8Name))
                print os.path.join(fullPath, utf8Name) + " -> ISO-8859-15 detected: Renamed"
                encodingDetected = True
                break;
        else:
            # Detect CP850
            if ((fileDirName[Idx] >= '\x80') & (fileDirName[Idx] <= '\xA5')):
                utf8Name = fileDirName.decode('cp850')
                utf8Name = utf8Name.encode('utf-8')
                os.rename(os.path.join(fullPath, fileDirName), os.path.join(fullPath, utf8Name))
                print os.path.join(fullPath, utf8Name) + " -> CP850 detected: Renamed"
                encodingDetected = True
                break;
            # Detect ISO-8859-15
            elif (fileDirName[Idx] >= '\xA6') & (fileDirName[Idx] <= '\xFF'):
                utf8Name = fileDirName.decode('iso-8859-15')
                utf8Name = utf8Name.encode('utf-8')
                os.rename(os.path.join(fullPath, fileDirName), os.path.join(fullPath, utf8Name))
                print os.path.join(fullPath, utf8Name) + " -> ISO-8859-15 detected: Renamed"
                encodingDetected = True
                break;
    if (encodingDetected == False):
        print os.path.join(fullPath, fileDirName) + " -> No special characters detected: Nothing to be done"
    return

# scan .7z files and unpack them
def unpack7zFunc(DirName):
    print "Scanning for .7z file(s), then unpack them"
    print "Scanning files..."
    DetectedFiles = False
    for dirname, dirnames, filenames in os.walk(DirName):
        for filename in filenames:
            if (filename[-3:] == ".7z"):
                print "Unpack %s..." %(filename)
                DetectedFiles = True
                try:
                    filepath = os.path.join(dirname, filename)
                    syno7z_cmd = ['/usr/syno/bin/7z', 'x', '-y', filepath]
                    p = subprocess.Popen(syno7z_cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                    out, err = p.communicate()
                    if (str(out) != ''):
                        print("7z result: " + filepath + " successfully unpacked")
                        os.remove(filepath)
                        print(filepath + " has been deleted")
                    if (str(err) != ''):
                        print("7z failed: " + str(err))
                except OSError, e:
                    print("Unable to run 7z: "+str(e))
    if DetectedFiles:
        print "Scanning for .7z files Done !"
    else:
        print "No .7z file Detected !"
    return

# add folder in the Syno index database (DLNA server)
def addToSynoIndex(DirName):
    print "Adding folder in the DLNA server"
    synoindex_cmd = ['/usr/syno/bin/synoindex', '-A', DirName]
    try:
        p = subprocess.Popen(synoindex_cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        out, err = p.communicate()
        if (str(out) == ''):
            print("synoindex result: " + DirName + " successfully added to Synology database")
        else:
            print("synoindex result: " + str(out))
        if (str(err) != ''):
            print("synoindex failed: " + str(err))
    except OSError, e:
        print("Unable to run synoindex: "+str(e))
    return

########################
# --- Main Program --- #
########################
print "Launching CharTranslator Python script (v%s) ..." %scriptVersionIs
print ""

# Get scripts directory of the SABnzbd from its config.ini file
if (SickBeardPostProcessing == True):
    print 100*'-'
    print "SickBeardPostProcessing option is ON"
    print "Locating SABnzbd config.ini file..."
    # Get SABnzbd rundir folder
    currentFolder = os.getcwd()
    # SABnzbd config.ini location
    SabScriptsFolder = ''
    confFile = '../../var/config.ini'
    # Check that file does exit
    if os.path.isfile(confFile):
        SabConfigFile = open('../../var/config.ini', 'r')

        # Parse each lines in order to get scripts folder path
        for line in SabConfigFile.readlines():
            if line[:len('script_dir')] == 'script_dir':
                # Get script_dir result
                SabScriptsFolder = line.split('=')[1]
                # Remove 1st space + \n
                if (SabScriptsFolder[0] == ' '):
                    SabScriptsFolder = SabScriptsFolder[1:]
                SabScriptsFolder = SabScriptsFolder.replace('\n', '')
                break
        SabConfigFile.close

        # Check that SABnzbd script folder has been found
        if (SabScriptsFolder == ''):
            print 100*'#'
            print "SABnzbd script_dir parameter not found!"
            print 100*'#'
            sys.exit(1)
        else:
            print "SABnzbd script_dir parameter is: '%s'" %SabScriptsFolder

        # Load SickBeard module
        SickBeardScript = os.path.join(SabScriptsFolder, 'autoProcessTV.py')
        # Check that SickBeard post-processing is present into SABnzbd scripts folder
        if os.path.isfile(SickBeardScript):
            sys.path.append(SabScriptsFolder)
            print "Loading SickBeard 'autoProcessTV' module"
            import autoProcessTV
            print 100*'-'
            print ""
        else:
            print 100*'#'
            print "Unable to find SickBeard autoProcessTV.py script in folder:"
            print SickBeardScript
            print 100*'#'
            sys.exit(1)

    # Exit if the file doesn't exist
    else:
        print 100*'#'
        print "Unable to find SABnzbd config.ini file in this folder:"
        print os.path.join(currentFolder, confFile)
        print 100*'#'
        sys.exit(1)

# Change current directory to SABnzbd argument 1
os.chdir(sys.argv[1])

# display directory of the SABnzbd job
currentFolder = os.getcwd()
print "Current folder is " + currentFolder

# rename SABnzbd job directory (coming from SABnzbd: never in CP850 format)
print "Renaming destination folder to UTF-8 format..."
renameFunc('', currentFolder)
currentFolder = os.getcwd()
print "Destination folder renamed !"
print ""

# Unpack 7z file(s)
if (Unpack7z == True):
    print 100*'-'
    unpack7zFunc(currentFolder)
    print 100*'-'
    print ""

# process each sub-folders starting from the deepest level
print 100*'-'
print "Renaming folders to UTF-8 format..."
for dirname, dirnames, filenames in os.walk('.', topdown=False):
    for subdirname in dirnames:
        renameFunc(dirname, subdirname)
print "Folder renaming Done !"
print 100*'-'
print ""

# process each file recursively
print 100*'-'
print "Renaming files to UTF-8 format..."
for dirname, dirnames, filenames in os.walk('.'):
    for filename in filenames:
        renameFunc(dirname, filename)
print "Files renaming Done !"
print 100*'-'
print ""

# Move current folder to an another destination if the option has been configured
if (MoveToThisFolder != ''):
    print 100*'-'
    print "Moving folder:"
    print os.getcwd()
    print "to:"
    print MoveToThisFolder
    # Check if destination folder does exist and can be written
    # If destination doesn't exist, it will be created
    if (os.access(MoveToThisFolder, os.F_OK) == False):
        os.makedirs(MoveToThisFolder)
        os.chmod(MoveToThisFolder, 0777)
    # Check write access
    if (os.access(MoveToThisFolder, os.W_OK) == False):
        print 100*'#'
        print "File(s)/Folder(s) can not be move in %s" %(MoveToThisFolder)
        print "Please, check Unix permissions"
        print 100*'#'
        sys.exit(1)

    # If MoveMergeSubFolder is True, then move all file(s)/folder(s) to destination
    # then remove source folder
    destFolder = os.path.join(MoveToThisFolder, os.path.split(os.getcwd())[-1])
    if (MoveMergeSubFolder):
        print "    Info: Merge option is ON (incremental copy)"
        try:
            synoCopy_cmd = ['/bin/cp', '-Rpf', os.path.abspath(currentFolder), MoveToThisFolder]
            p = subprocess.Popen(synoCopy_cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            out, err = p.communicate()
            if (str(err) != ''):
                print("Copy failed: " + str(err))
                sys.exit(1)
        except OSError, e:
            print("Unable to run cp: " + str(e))
            sys.exit(1)
        os.chdir(MoveToThisFolder)
        shutil.rmtree(currentFolder)
    # If MoveMergeSubFolder is False, remove folder with same (if exists)
    # then move all file(s)/folder(s) to destination and remove source folder
    else:
        print "    Info: Merge option is OFF (existing data will be deleted and replaced)"
        # Remove if destination already exist
        if os.path.exists(destFolder):
            shutil.rmtree(destFolder)
        shutil.move(currentFolder, MoveToThisFolder)
        os.chdir(MoveToThisFolder)
    # Update currentFolder variable
    os.chdir(destFolder)
    currentFolder = os.getcwd()
    print 100*'-'
    print ""

# Add multimedia files in the Syno DLNA if the option has been enabled
if (IndexInSynoDLNA == True) & (SickBeardPostProcessing == False):
    print 100*'-'
    addToSynoIndex(currentFolder)
    print ""
    print 100*'-'
# Send to SickBeard for post-processing
elif (IndexInSynoDLNA == False) & (SickBeardPostProcessing == True):
    print 100*'-'
    print "Launching SickBeard post-processing..."
    autoProcessTV.processEpisode(currentFolder)
    print "SickBeard post-processing done!"
    print ""
    print 100*'-'
# Display error message + advise if both options are enabled
elif (IndexInSynoDLNA == True) & (SickBeardPostProcessing == True):
    print 100*'#'
    print "IndexInSynoDLNA and SickBeardPostProcessing options are exclusive"
    print "Please check your configuration"
    print ""
    print "If you want to have both options enables at the same time, please processed as follow:"
    print " 1- Enable only SickBeardPostProcessing option"
    print " 2- In SickBeard GUI -> Config -> Notifications -> Enable 'Synology Indexer'"
    print 100*'#'
    sys.exit(1)

print ""
print "Character encoding translation done!"
