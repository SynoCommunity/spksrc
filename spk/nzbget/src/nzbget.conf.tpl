# Sample configuration file for nzbget
#
# On POSIX put this file to one of the following locations:
# ~/.nzbget
# /etc/nzbget.conf
# /usr/etc/nzbget.conf
# /usr/local/etc/nzbget.conf
# /opt/etc/nzbget.conf
#
# On Windows put this file in program's directory.
#
# You can also put the file into any location, if you specify the path to it
# using switch "-c", e.g:
#   nzbget -c /home/user/myconig.txt

# For quick start change the option MAINDIR and configure one news-server


##############################################################################
### PATHS                                                                  ###

# Root directory for all related tasks.
#
# MAINDIR is a variable and therefore starts with "$".
# On POSIX you can use "~" as alias for home directory (e.g. "~/download").
# On Windows use absolute paths (e.g. "C:\Download").
$MAINDIR=~/download

# Destination-directory to store the downloaded files.
DestDir=${MAINDIR}/dst

# Directory to monitor for incoming nzb-jobs.
#
# Can have subdirectories. 
# A nzb-file queued from a subdirectory will be automatically assigned to 
# category with the directory-name.
NzbDir=${MAINDIR}/nzb

# Directory to store download queue.
QueueDir=${MAINDIR}/queue

# Directory to store temporary files.
TempDir=${MAINDIR}/tmp

# Lock-file for daemon-mode, POSIX only.
#
# If the option is not empty, nzbget creates the file and writes process-id 
# (PID) into it. That info can be used in shell scripts.
LockFile=/tmp/nzbget.lock

# Where to store log file, if it needs to be created.
#
# NOTE: See also option <CreateLog>.
LogFile=${DestDir}/nzbget.log


##############################################################################
### NEWS-SERVERS                                                           ###

# This section defines which servers nzbget should connect to.

# Level of newsserver (0-99).
#
# The servers will be ordered by their level, i.e. nzbget will at
# first try to download an article from the level-0-server.
# If that server fails, nzbget proceeds with the level-1-server, etc.
# A good idea is surely to put your major download-server at level 0
# and your fill-servers at levels 1,2,...
#
# NOTE: Do not leave out a level in your server-list and start with level 0.
#
# NOTE: Several servers with the same level may be used, they will have 
# the same priority.
Server1.Level=0

# Host name of newsserver.
Server1.Host=my1.newsserver.com

# Port to connect to (1-65535).
Server1.Port=119

# User name to use for authentication.
Server1.Username=user

# Password to use for authentication.
Server1.Password=pass

# Server requires "Join Group"-command (yes, no).
Server1.JoinGroup=yes

# Encrypted server connection (TLS/SSL) (yes, no).
Server1.Encryption=no

# Maximal number of simultaneous connections to this server (0-999).
Server1.Connections=4

# Second server, on level 0.

#Server2.Level=0
#Server2.Host=my2.newsserver.com
#Server2.Port=119
#Server2.Username=me
#Server2.Password=mypass
#Server2.JoinGroup=yes
#Server2.Connections=4

# Third server, on level 1.

#Server3.Level=1
#Server3.Host=fills.newsserver.com
#Server3.Port=119
#Server3.Username=me2
#Server3.Password=mypass2
#Server3.JoinGroup=yes
#Server3.Connections=1


##############################################################################
### PERMISSIONS                                                            ###

# User name for daemon-mode, POSIX only.
#
# Set the user that the daemon normally runs at (POSIX in daemon-mode only).
# Set $MAINDIR with an absolute path to be sure where it will write.
# This allows nzbget daemon to be launched in rc.local (at boot), and
# download items as a specific user id.
#
# NOTE: This option has effect only if the program was started from 
# root-account, otherwise it is ignored and the daemon runs under 
# current user id.
DaemonUserName=root

# Specify default umask (affects file permissions) for newly created 
# files, POSIX only (000-1000).
#
# The value should be written in octal form (the same as for "umask" shell 
# command).
# Empty value or value "1000" disable the setting of umask-mode; current 
# umask-mode (set via shell) is used in this case.
UMask=1000


##############################################################################
### INCOMING NZBS                                                          ###

# Create subdirectory with category-name in destination-directory (yes, no).
AppendCategoryDir=yes

# Create subdirectory with nzb-filename in destination-directory (yes, no).
AppendNzbDir=yes

# How often incoming-directory (option <NzbDir>) must be checked for new 
# nzb-files (seconds).
#
# Value "0" disables the check.
NzbDirInterval=5

# How old nzb-file should at least be for it to be loaded to queue (seconds).
#
# Nzbget checks if nzb-file was not modified in last few seconds, defined by
# this option. That safety interval prevents the loading of files, which 
# were not yet completely saved to disk, for example if they are still being
# downloaded in web-browser.
NzbDirFileAge=60

# Automatic merging of nzb-files with the same filename (yes, no).
#
# A typical scenario: you put nzb-file into incoming directory, nzbget adds
# file to queue. You find out, that the file doesn't have par-files. You
# find required par-files, put nzb-file with the par-files into incoming 
# directory, nzbget adds it to queue as a separate group. You want the second 
# file to be merged with the first for parchecking to work properly. With 
# option "MergeNzb" nzbget can merge files automatically. You only need to 
# save the second file under the same filename as the first one.
MergeNzb=no

# Set path to program, that must be executed before any file in incoming 
# directory (option <NzbDir>) is processed.
#
# Example: "NzbProcess=~/nzbprocess.sh".
#
# That program can unpack archives which were put in incoming directory, make
# filename cleanup, assign category and post-processing parameters to nzb-file
# or do something else.
#
# NZBGet passes following arguments to nzbprocess-program as environment
# variables:
#  NZBNP_DIRECTORY - path to directory, where file is located. It is a directory
#                    specified by the option <NzbDir> or a subdirectory;
#  NZBNP_FILENAME  - name of file to be processed;
#
# In addition to these arguments nzbget passes all
# nzbget.conf-options to postprocess-program as environment variables. These
# variables have prefix "NZBOP_" and are written in UPPER CASE. For Example
# option "ParRepair" is passed as environment variable "NZBOP_PARREPAIR".
# The dots in option names are replaced with underscores, for example 
# "SERVER1_HOST". For options with predefined possible values (yes/no, etc.)
# the values are passed always in lower case.
#
# The nzbprocess-script can assign category or post-processing parameters
# to current nzb-file by printing special messages into standard output
# (which is processed by NZBGet).
#
# To assign category use following syntax:
#   echo "[NZB] CATEGORY=my category";
#
# To assign post-processing parameters:
#   echo "[NZB] NZBPR_myvar=my value";
#
# The prefix "NZBPR_" will be removed. In this example a post-processing
# parameter with name "myvar" and value "my value" will be associated
# with nzb-file.
#
# The nzbprocess-script can delete processed file, rename it or move somewhere.
# After the calling of the script the file will be either added to queue 
# (if it was an nzb-file) or renamed by adding the extension ".processed".
#
# NOTE: Files with extensions ".processed", ".queued" and ".error" are skipped
# during the directory scanning.
#
# NOTE: Files with extension ".nzb_processed" are not passed to 
# NzbProcess-script before adding to queue. This feature allows 
# NzbProcess-script to prevent the scanning of nzb-files extracted from 
# archives, if they were already processed by the script.
NzbProcess=

# Check for duplicate files (yes, no).
#
# If this option is enabled the program checks by adding of a new nzb-file:
# 1) if nzb-file contains duplicate entries. This check aims on detecting
#    of reposted files (if first file was not fully uploaded);    
#    If the program find two files with identical names, only the 
#    biggest of these files will be added to queue;
# 2) if download queue already contains file with the same name;
# 3) if destination file on disk already exists.
# In last two cases: if the file exists it will not be added to queue;
#
# If this option is disabled, all files are downloaded and duplicate files 
# are renamed to "filename_duplicate1".
# Existing files are never deleted or overwritten.
DupeCheck=no


##############################################################################
### DOWNLOAD QUEUE                                                         ###

# Save download queue to disk (yes, no).
#
# This allows to reload it on next start.
SaveQueue=yes

# Reload download queue on start, if it exists (yes, no).
ReloadQueue=yes

# Reload Post-processor-queue on start, if it exists (yes, no).
#
# For this option to work the options <SaveQueue> and <ReloadQueue> must
# be also enabled.
ReloadPostQueue=yes

# Reuse articles saved in temp-directory from previous program start (yes, no).
#
# This allows to continue download of file, if program was exited before 
# the file was completed.
ContinuePartial=yes

# Visibly rename broken files on download appending "_broken" (yes, no).
#
# Do not activate this option if par-check is enabled.
RenameBroken=no

# Decode articles (yes, no).
#
# yes - decode articles using internal decoder (supports yEnc and UU formats);
# no - the articles will not be decoded and joined. External programs 
#      (like "uudeview") can be used to decode and join downloaded articles.
#      Also useful for debugging to look at article's source text.
Decode=yes

# Write decoded articles directly into destination output file (yes, no).
#
# With this option enabled the program at first creates the output 
# destination file with required size (total size of all articles), 
# then writes on the fly decoded articles directly to the file 
# without creating of any temporary files, even for decoded articles.
# This may results in major performance improvement, but this highly 
# depends on OS and file system.
#
# Can improve performance on a very fast internet connections, 
# but you need to test if it works in your case.
#
# INFO: Tests showed, that on Linux with EXT3-partition activating of 
# this option results in up to 20% better performance, but on Windows with NTFS 
# or Linux with FAT32-partitions the performance were decreased. 
# The possible reason is that on EXT3-partition Linux can create large files
# very fast (if the content of file does not need to be initialized), 
# but Windows on NTFS-partition and also Linux on FAT32-partition need to
# initialize created large file with nulls, resulting in a big performance 
# degradation.
#
# NOTE: for testing try to download few big files (with total size 500-1000MB)
# and measure required time. Do not rely on the program's speed indicator.
#
# NOTE: if both options <DirectWrite> and <ContinuePartial> are enabled,
# the program will still create empty articles-files in temp-directory. They
# are used to continue download of file on a next program start. To minimize
# disk-io it is recommended to disable option <ContinuePartial>, if 
# <DirectWrite> is enabled. Especially on a fast connections (where you
# would want to activate <DirectWrite>) it should not be a problem to 
# redownload an interrupted file.
DirectWrite=no

# Check CRC of downloaded and decoded articles (yes, no).
#
# Normally this option should be enabled for better detecting of download 
# errors. However checking of CRC needs about the same CPU time as 
# decoding of articles. On a fast connections with slow CPUs disabling of
# CPU-check may slightly improve performance (if CPU is a limiting factor).
CrcCheck=yes

# How much retries should be attempted if a download error occurs (0-99).
Retries=4

# Set the interval between retries (seconds).
RetryInterval=10

# Redownload article if CRC-check fails (yes, no).
#
# Helps to minimize number of broken files, but may be effective 
# only if you have multiple download servers (even from the same provider
# but from different locations (e.g. europe, usa)).
# In any case the option increases your traffic.
# For slow connections loading of extra par-blocks may be more effective
# The option <CrcCheck> must be enabled for option <RetryOnCrcError> to work.
RetryOnCrcError=no

# Set connection timeout (seconds).
ConnectionTimeout=60

# Timeout until a download-thread should be killed (seconds).
#
# This can help on hanging downloads, but is dangerous. 
# Do not use small values!
TerminateTimeout=600

# Set the (approximate) maximum number of allowed threads (0-999).
#
# Sometimes under certain circumstances the program may create way to many 
# download threads. Most of them are in wait-state. That is not bad,
# but threads are usually a limited resource. If a program creates to many
# of them, operating system may kill it. The option <ThreadLimit> prevents that.
#
# NOTE: the number of threads is not the same as the number of connections
# opened to NNTP-servers. Do not use the option <ThreadLimit> to limit the
# number of connections. Use the appropriate options <ServerX.Connections>
# instead.
#
# NOTE: the actual number of created threads can be slightly larger as
# defined by the option. Important threads may be created even if the
# number of threads is exceeded. The option prevents only the creation of
# additional download threads.
#
# NOTE: in most cases you should leave the default value "100" unchanged.
# However you may increase that value if you need more than 90 connections 
# (that's very unlikely) or decrease the value if the OS does not allow so 
# many threads. But the most OSes should not have problems with 100 threads.
ThreadLimit=100

# Set the maximum download rate on program start (kilobytes/sec).
#
# Value "0" means no speed control.
# The download rate can be changed later via remote calls.
DownloadRate=0

# Set the size of memory buffer used by writing the articles (bytes).
#
# Bigger values decrease disk-io, but increase memory usage.
# Value "0" causes an OS-dependent default value to be used.
# With value "-1" (which means "max/auto") the program sets the size of 
# buffer according to the size of current article (typically less than 500K).
#
# NOTE: the value must be written in bytes, do not use postfixes "K" or "M".
#
# NOTE: to calculate the memory usage multiply WriteBufferSize by max number
# of connections, configured in section "NEWS-SERVERS".
#
# NOTE: typical article's size not exceed 500000 bytes, so using bigger values
# (like several megabytes) will just waste memory.
#
# NOTE: for desktop computers with large amount of memory value "-1" (max/auto)
# is recommended, but for computers with very low memory (routers, NAS)
# value "0" (default OS-dependent size) could be better alternative.
#
# NOTE: write-buffer is managed by OS (system libraries) and therefore 
# the effect of the option is highly OS-dependent.
WriteBufferSize=0

# Pause if disk space gets below this value (megabytes).
#
# Value "0" disables the check.
# Only the disk space on the drive with <DestDir> is checked.
# The drive with <TempDir> is not checked.
DiskSpace=250

# Delete already downloaded files from disk, if the download of nzb-file was 
# cancelled (nzb-file was deleted from queue) (yes, no).
#
# NOTE: nzbget does not delete files in a case if all remaining files in 
# queue are par-files. That prevents the accidental deletion if the option
# <ParCleanupQueue> is disabled or if the program was interrupted during 
# parcheck and later restarted without reloading of post queue (option 
# <ReloadPostQueue> disabled).
DeleteCleanupDisk=no

# Keep the history of downloaded nzb-files (days).
#
# Value "0" disables the history.
#
# NOTE: when a collection having paused files is added to history all remaining
# files are moved from download queue to a list of parked files. It holds files
# which could be required later if the collection will be moved back to
# download queue for downloading of remaining files. The parked files still
# consume some amount of memory and disk space. If the collection was downloaded
# and successfully par-checked or postprocessed it is recommended to discard the
# unneeded parked files before adding the collection to history. For par2-files
# that can be achieved with the option <ParCleanupQueue>.
KeepHistory=1

##############################################################################
### LOGGING                                                                ###

# Create log file (yes, no).
CreateLog=yes

# Delete log file upon server start (only in server-mode) (yes, no).
ResetLog=no

# How error messages must be printed (screen, log, both, none).
ErrorTarget=both

# How warning messages must be printed (screen, log, both, none).
WarningTarget=both

# How info messages must be printed (screen, log, both, none).
InfoTarget=both

# How detail messages must be printed (screen, log, both, none).
DetailTarget=both

# How debug messages must be printed (screen, log, both, none).
#
# Debug-messages can be printed only if the program was compiled in 
# debug-mode: "./configure --enable-debug".
DebugTarget=both

# Set the default message-kind for output received from process-scripts
# (PostProcess, NzbProcess, TaskX.Process) (none, detail, info, warning, 
# error, debug).
#
# NZBGet checks if the line written by the script to stdout or stderr starts
# with special character-sequence, determining the message-kind, e.g.:
# [INFO] bla-bla.
# [DETAIL] bla-bla.
# [WARNING] bla-bla.
# [ERROR] bla-bla.
# [DEBUG] bla-bla.
#
# If the message-kind was detected the text is added to log with detected type.
# Otherwise the message becomes the default kind, specified in this option.
ProcessLogKind=detail

# Number of messages stored in buffer and available for remote 
# clients (messages).
LogBufferSize=1000

# Create a log of all broken files (yes ,no).
#
# It is a text file placed near downloaded files, which contains
# the names of broken files.
CreateBrokenLog=yes

# Create memory dump (core-file) on abnormal termination, Linux only (yes, no).
#
# Core-files are very helpful for debugging.
#
# NOTE: core-files may contain sensible data, like your login/password to
# newsserver etc.
DumpCore=no

# See also option <LogFile> in section "PATHS"


##############################################################################
### DISPLAY (TERMINAL)                                                     ###

# Set screen-outputmode (loggable, colored, curses).
#
# loggable - only messages will be printed to standard output;
# colored  - prints messages (with simple coloring for messages categories)
#            and download progress info; uses escape-sequences to move cursor;
# curses   - advanced interactive interface with the ability to edit 
#            download queue and various output option.
OutputMode=curses

# Shows NZB-Filename in file list in curses-outputmode (yes, no).
#
# This option controls the initial state of curses-frontend,
# it can be switched on/off in run-time with Z-key.
CursesNzbName=yes

# Show files in groups (NZB-files) in queue list in curses-outputmode (yes, no).
#
# This option controls the initial state of curses-frontend,
# it can be switched on/off in run-time with G-key.
CursesGroup=no

# Show timestamps in message list in curses-outputmode (yes, no).
#
# This option controls the initial state of curses-frontend,
# it can be switched on/off in run-time with T-key.
CursesTime=no

# Update interval for Frontend-output in console mode or remote client 
# mode (milliseconds).
#
# Min value 25. Bigger values reduce CPU usage (especially in curses-outputmode)
# and network traffic in remote-client mode.
UpdateInterval=200


##############################################################################
### CLIENT/SERVER COMMUNICATION                                            ###

# IP on which the server listen and which client uses to contact the server. 
#
# It could be dns-hostname or ip-address (more effective since does not 
# require dns-lookup).
# If you want the server to listen to all interfaces, use "0.0.0.0".
ServerIp=127.0.0.1

# Port which the server & client use (1-65535).
ServerPort=6789

# Password which the server & client use.
ServerPassword=tegbzn6789

# See also option <LogBufferSize> in section "LOGGING"


##############################################################################
### PAR CHECK/REPAIR                                                       ###

# How many par2-files to load (none, all, one).
#
# none - all par2-files must be automatically paused;
# all - all par2-files must be downloaded;
# one - only one main par2-file must be dowloaded and other must be paused.
# Paused files remain in queue and can be unpaused by parchecker when needed.
LoadPars=one

# Automatic par-verification (yes, no).
#
# To download only needed par2-files (smart par-files loading) set also 
# the option <LoadPars> to "one". If option <LoadPars> is set to "all",
# all par2-files will be downloaded before verification and repair starts.
# The option <RenameBroken> must be set to "no", otherwise the par-checker
# may not find renamed files and fail.
ParCheck=no

# Automatic par-repair (yes, no).
#
# If option <ParCheck> is enabled and <ParRepair> is not, the program
# only verifies downloaded files and downloads needed par2-files, but does
# not start repair-process. This is useful if the server does not have
# enough CPU power, since repairing of large files may take too much
# resources and time on a slow computers.
# This option has effect only if the option <ParCheck> is enabled.
ParRepair=yes

# Use only par2-files with matching names (yes, no).
#
# If par-check needs extra par-blocks it searches for par2-files
# in download queue, which can be unpaused and used for restore. 
# These par2-files should have the same base name as the main par2-file, 
# currently loaded in par-checker. Sometimes extra par files (especially if 
# they were uploaded by a different poster) have not matching names. 
# Normally par-checker does not use these files, but you can allow it 
# to use these files by setting <StrictParName> to "no".
# This has however a side effect: if NZB-file contains more than one collection
# of files (with different par-sets), par-checker may download par-files from
# a wrong collection. This increases you traffic (but not harm par-check).
#
# NOTE: par-checker always uses only par-files added from the same NZB-file
# and the option <StrictParName> does not change this behavior.
StrictParName=yes

# Maximum allowed time for par-repair (minutes).
#
# Value "0" means unlimited.
#
# If you use nzbget on a very slow computer like NAS-device, it may be good to
# limit the time allowed for par-repair. Nzbget calculates the estimated time 
# required for par-repair. If the estimated value exceeds the limit defined
# here, nzbget cancels the repair.
#
# To avoid a false cancellation nzbget compares the estimated time with 
# <ParTimeLimit> after the first 5 minutes of repairing, when the calculated
# estimated time is more or less accurate. But in a case if <ParTimeLimit> is
# set to a value smaller than 5 minutes, the comparison is made after the first 
# whole minute.
#
# NOTE: the option limits only the time required for repairing. It doesn't 
# affect the first stage of parcheck - verification of files. However the 
# verification speed is constant, it doesn't depend on files integrity and
# therefore it is not necessary to limit the time needed for the first stage.
#
# NOTE: this option requires an extended version of libpar2 (the original
# version doesn't support the cancelling of repairing). Please refer to 
# nzbget's README for info on how to apply a patch to libpar2.
ParTimeLimit=0

# Pause download queue during check/repair (yes, no).
#
# Enable the option to give CPU more time for par-check/repair. That helps
# to speed up check/repair on slow CPUs with fast connection (e.g. NAS-devices).
#
# NOTE: if parchecker needs additional par-files it temporary unpauses queue.
#
# NOTE: See also option <PostPauseQueue>.
ParPauseQueue=no

# Cleanup download queue after successful check/repair (yes, no).
#
# Enable this option for automatic deletion of unneeded (paused) par-files 
# from download queue after successful check/repair.
ParCleanupQueue=yes

# Delete source nzb-file after successful check/repair (yes, no).
#
# Enable this option for automatic deletion of nzb-file from incoming directory 
# after successful check/repair.
NzbCleanupDisk=no


##############################################################################
### POSTPROCESSING                                                         ###

# Set path to program, that must be executed after the download of nzb-file 
# or one collection in nzb-file (if par-check enabled and nzb-file contains 
# multiple collections; see note below for the definition of "collection") 
# is completed and possibly par-checked/repaired.
#
# Example: "PostProcess=~/postprocess-example.sh".
#
# NZBGet passes following arguments to postprocess-program as environment
# variables:
#  NZBPP_DIRECTORY    - path to destination dir for downloaded files;
#  NZBPP_NZBFILENAME  - name of processed nzb-file;
#  NZBPP_PARFILENAME  - name of par-file or empty string (if no collections were 
#                       found);
#  NZBPP_PARSTATUS    - result of par-check:
#                       0 = not checked: par-check disabled or nzb-file does
#                           not contain any par-files;
#                       1 = checked and failed to repair;
#                       2 = checked and successfully repaired;
#                       3 = checked and can be repaired but repair is disabled;
#  NZBPP_NZBCOMPLETED - state of nzb-job:
#                       0 = there are more collections in this nzb-file queued;
#                       1 = this was the last collection in nzb-file;
#  NZBPP_PARFAILED    - indication of failed par-jobs for current nzb-file:
#                       0 = no failed par-jobs;
#                       1 = current par-job or any of the previous par-jobs for
#                           the same nzb-files failed;
#  NZBPP_CATEGORY     - category assigned to nzb-file (can be empty string).
#
# If nzb-file has associated postprocess-parameters (which can be set using
# subcommand <O> of command <-E>, for example: nzbget -E G O "myvar=hello !" 10)
# or using XML-/JSON-RPC (for example via web-interface), they are also passed 
# as environment variables. These variables have prefix "NZBPR_" in their names.
# For example, pp-parameter "myvar" will be passed as environment 
# variable "NZBPR_myvar".
#
# In addition to arguments and postprocess-parameters nzbget passes all
# nzbget.conf-options to postprocess-program as environment variables. These
# variables have prefix "NZBOP_" and are written in UPPER CASE. For Example
# option "ParRepair" is passed as environment variable "NZBOP_PARREPAIR".
# The dots in option names are replaced with underscores, for example 
# "SERVER1_HOST". For options with predefined possible values (yes/no, etc.)
# the values are passed always in lower case.
#
# Return value: nzbget processes the exit code returned by the script:
#  91 - request nzbget to do par-check/repair for current collection in the 
#       current nzb-file;
#  92 - request nzbget to do par-check/repair for all collections in the 
#       current nzb-file;
#  93 - post-process successful (status = SUCCESS);
#  94 - post-process failed (status = FAILURE);
#  95 - post-process skipped (status = NONE);
# All other return codes are interpreted as "status unknown".
#
# The return value is used to display the status of post-processing in
# a history view. In addition to status one or more text messages can be
# passed to history using a special prefix "[HISTORY]" by printing messages
# to standard output. For example:
#   echo "[ERROR] [HISTORY] Unpack failed, not enough disk space";
#
# NOTE: The parameter NZBPP_NZBCOMPLETED is very important and MUST be checked 
# even in the simplest scripts.
# If par-check is enabled and nzb-file contains more than one collection
# of files the postprocess-program is called after each collection is completed
# and par-checked. If you want to unpack files or clean up the directory 
# (delete par-files, etc.) there are two possibilities, when you can do this:
#  1) you parse NZBPP_PARFILENAME to find out the base name of collection and 
#     clean up only files from this collection (not reliable, because par-files
#     sometimes have different names than rar-files);
#  2) or you just check the parameters NZBPP_NZBCOMPLETED and NZBPP_PARFAILED
#     and do the processing, only if NZBPP_NZBCOMPLETED is set to "1" (which 
#     means, that this was the last collection in nzb-file and all files 
#     are now completed) and NZBPP_PARFAILED is set to "0" (no failed par-jobs);
#
# NOTE: the term "collection" in the above description actually means 
# "par-set". To determine what "collections" are present in nzb-file nzbget 
# looks for par-sets. If any collection of files within nzb-file does 
# not have any par-files, this collection will not be detected.
# For example, for nzb-file containing three collections but only two par-sets, 
# the postprocess will be called two times - after processing of each par-set.
#
# NOTE: if nzbget doesn't find any collections it calls PostProcess once
# with empty string for parameter NZBPP_PARFILENAME;
#
# NOTE: the using of special return values (91 and 92) for requesting of 
# par-check/repair allows to organize the delayed parcheck. To do that:
#   1) set options: LoadPars=one, ParCheck=no, ParRepair=yes;
#   2) in post-process-script check the parameter NZBPP_PARSTATUS. If it is "0",
#      that means, the script is called for the first time. Try to unpack files.
#      If unpack fails, exit the script with exit code for par-check/repair;
#   3) nzbget will start par-check/repair. After that it calls the script again;
#   4) on second pass the parameter NZBPP_PARSTATUS will have value 
#      greater than "0". If it is "2" ("checked and successfully repaired")
#      you can try unpack again. 
#
# NOTE: an example script for unrarring is provided within distribution 
# in file "postprocess-example.sh".
PostProcess=

# Allow multiple post-processing for the same nzb-file (yes, no).
#
# After the post-processing (par-check and call of a postprocess-script) is
# completed, nzbget adds the nzb-file to a list of completed-jobs. The nzb-file
# stays in the list until the last file from that nzb-file is deleted from 
# the download queue (it occurs straight away if the par-check was successful 
# and the option <ParCleanupQueue> is enabled).
# That means, if a paused file from a nzb-collection becomes unpaused 
# (manually or from a post-process-script) after the collection was already 
# postprocessed nzbget will not post-process nzb-file again.
# This prevents the unwanted multiple post-processings of the same nzb-file.
# But it might be needed if the par-check/-repair are performed not directly 
# by nzbget but from a post-process-script.
#
# NOTE: enable this option only if you were advised to do that by the author
# of the post-process-script.
#
# NOTE: by enabling <AllowReProcess> you should disable the option <ParCheck>
# to prevent multiple par-checking.
AllowReProcess=no

# Pause download queue during executing of postprocess-script (yes, no).
#
# Enable the option to give CPU more time for postprocess-script. That helps
# to speed up postprocess on slow CPUs with fast connection (e.g. NAS-devices).
#
# NOTE: See also option <ParPauseQueue>.
PostPauseQueue=no


##############################################################################
### SCHEDULER                                                              ###

# This section defines scheduler commands.
# For each command create a set of options <TaskX.Time>, <TaskX.Command>,
# <TaskX.WeekDays> and <TaskX.DownloadRate>.
# The following example shows how to throttle downloads in the daytime 
# by 100 KB/s and download at full speed overnights:

# Time to execute the command (HH:MM).
#
# Multiple comma-separated values are accepted.
# Asterix as hours-part means "every hour".
#
# Examples: "08:00", "00:00,06:00,12:00,18:00", "*:00", "*:00,*:30".
#Task1.Time=08:00

# Week days to execute the command (1-7).
#
# Comma separated list of week days numbers. 
# 1 is Monday.
# Character '-' may be used to define ranges.
#
# Examples: "1-7", "1-5", "5,6", "1-5, 7".
#Task1.WeekDays=1-7

# Command to be executed (PauseDownload, UnpauseDownload, PauseScan,
# UnpauseScan, DownloadRate, Process).
#
# Possible commands:
#   PauseDownload   - pauses download;
#   UnpauseDownload - resumes download;
#   PauseScan       - pauses scan of incoming nzb-directory;
#   UnpauseScan     - resumes scan of incoming nzb-directory;
#   DownloadRate    - sets download rate in KB/s;
#   Process         - executes external program.
#Task1.Command=DownloadRate

# Download rate to be set if the command is "DownloadRate" (kilobytes/sec).
#
# Value "0" means no speed control.
#
# If the option <TaskX.Command> is not set to "DownloadRate" this option
# is ignored and can be omitted.
#Task1.DownloadRate=100

# Path to the porgram to execute if the command is "Process".
#
# Example: "Task1.Process=/home/user/fetch-nzb.sh".
#
# If the option <TaskX.Command> is not set to "Process" this option
# is ignored and can be omitted.
#
# NOTE: it's allowed to add parameters to command line. If filename or
# any parameter contains spaces it must be surrounded with single quotation
# marks. If filename/parameter contains single quotation marks, each of them 
# must be replaced with two single quotation marks and the resulting filename/
# parameter must be surrounded with single quotation marks.
# Example: '/home/user/download/my scripts/task process.sh' 'world''s fun'.
# In this example one parameter (world's fun) is passed to the script 
# (task process.sh).
#Task1.Process=

#Task2.Time=20:00
#Task2.WeekDays=1-7
#Task2.Command=DownloadRate
#Task2.DownloadRate=0


##############################################################################
## PERFORMANCE                                                              ##

# On a very fast connection and slow CPU and/or drive the following 
# settings may improve performance:
# 1) Disable par-checking and -repairing ("ParCheck=no"). VERY important,
#    because par-checking/repairing needs a lot of CPU-power and 
#    significantly increases disk usage;
# 2) Try to activate option <DirectWrite> ("DirectWrite=yes"), especially
#    if you use EXT3-partitions;
# 3) Disable option <CrcCheck> ("CrcCheck=no");
# 4) Disable option <ContinuePartial> ("ContinuePartial=no");
# 5) Do not limit download rate ("DownloadRate=0"), because the bandwidth 
#    throttling eats some CPU time;
# 6) Disable logging for detail- and debug-messages ("DetailTarget=none", 
#    "DebugTarget=none");
# 7) Run the program in daemon (Posix) or service (Windows) mode and use
#    remote client for short periods of time needed for controlling of 
#    download process on server. Daemon/Service mode eats less CPU 
#    resources than console server mode due to not updating the screen.
# 8) Increase the value of option <WriteBufferSize> or better set it to 
#    "-1" (max/auto) if you have spare 5-20 MB of memory.
