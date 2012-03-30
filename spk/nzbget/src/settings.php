<?php

# Configuration file for nzbget web-interface


##############################################################################
### COMMUNICATION WITH NZBGET-SERVER                                       ###

# IP of NZBGet-server.
#
# See option <ServerIp> in nzbget.conf-file.
$ServerIp='127.0.0.1';

# Port of NZBGet-server (1-65535).
#
# See option <ServerPort> in nzbget.conf-file.
$ServerPort=6789;

# Password to NZBGet-server.
#
# See option <ServerPassword> in nzbget.conf-file.
$ServerPassword='tegbzn6789';

# Connect timeout (seconds).
$ConnectTimeout=30;

# Full path to server configuration file.
#
# Needed if you want to edit server options via web-interface.
#
# Example (POSIX): $ServerConfigFile='/tmp/harddisk/download/nzb/nzbget.conf'.
# Example (Windows): $ServerConfigFile='C:\\Downloads\\nzbget\\nzbget.conf'.
#
# NOTE: Backslashes (on Windows) must be doubled.
$ServerConfigFile='/usr/local/nzbget/var/nzbget.conf';

# Full path to the example of server configuration file.
# This file is used to read the list of options and their descriptions.
# Needed if you want to edit server options via web-interface.
#
# Example (POSIX): $ServerConfigTemplate='/tmp/harddisk/www/nzbgetweb/nzbget.conf.example'.
# Example (Windows): $ServerConfigTemplate='C:\\Program Files\\apache\htdocs\nzbgetweb\\nzbget.conf.example'.
#
# NOTE: Use the file nzbget.conf.example distributed with the version of NZBGet,
# which you are currently using (at least 0.6.0).
#
# NOTE: Backslashes (on Windows) must be doubled.
$ServerConfigTemplate='/usr/local/nzbget/var/nzbget.conf.tpl';

# Command line to start NZBGet-server.
#
# Leave this option empty if you do not want/need to shutdown and start 
# NZBGet-server via web-interface.
#
# Example (POSIX): $ServerStartCommand='/usr/bin/nzbget -D -c /usr/etc/nzbget.conf 2>&1';
# Example (Windows): $ServerStartCommand='net start NZBGet';
#
# NOTE: if system cannot execute the command (permission problem, etc.) it
# prints error messages to stderr. To see that messages use output redirection,
# add " 2>&1" at the end of command, see the example above. (POSIX only).
#
# NOTE: VERY IMPORTANT: the command is executed under web-server user-account, you
# must ensure the web-server has permissions to start nzbget
# and access nzbget-directories (read/write).
$ServerStartCommand='';

# Command line to stop NZBGet-server.
#
# The server can be stopped using RPC-command "shutdown". However you might
# need to perform additional steps while stopping the server. In this case
# you can use this option to execute your own stop-script.
#
# Example (POSIX): $ServerStopCommand='/usr/bin/nzbget -Q -c /usr/etc/nzbget.conf 2>&1';
# Example (Windows): $ServerStartCommand='net stop NZBGet';
#
# NOTE: if system cannot execute the command (permission problem, etc.) it
# prints error messages to stderr. To see that messages use output redirection,
# add " 2>&1" at the end of command, see the example above. (POSIX only).
#
# NOTE: VERY IMPORTANT: the command is executed under web-server user-account.
#
# NOTE: Leave this option empty to stop server using internal RPC-command.
$ServerStopCommand='';

# Directory to upload nzb-files.
#
# Set it to the same value as option "NzbDir" in nzbget.conf-file.
#
# Example (POSIX): $NzbDir = '/tmp/harddisk/download/nzb'.
# Example (Windows): $NzbDir = 'C:\\Downloads\\nzbget\\nzb'.
# Example (Windows): $NzbDir = '\\\\192.168.1.1\\share$\\download\\nzb'.
#
# NOTE: Backslashes (on Windows) must be doubled.
$NzbDir='/usr/local/nzbget/var/nzb';

# The max file size to upload via web-interface (bytes).
$UploadMaxFileSize=10000000;

# Set protocol and library to be used for communication with NZBGet-server
# (auto, json-rpc-ext, json-rpc-lib, xml-rpc-ext, xml-rpc-lib).
#
# NZBGetWeb can communicate with NZBGet-server using either XML-RPC or JSON-RPC.
# For each of these two protocols NZBGetWeb supports two PHP-implementations.
#
# Set the option to "json-rpc-ext" to use the fastest library "JSON".
# From Version 5.2 of PHP this extension is built into PHP and there is 
# no need to install any separate extension or library. 
# For early versions of PHP you can compile the extension yourself. 
# Source code is available on http://www.aurore.net/projects/php-json/.
#
# Set to "xml-rpc-ext" to use extension "xmlrpc" - fast and also recommended. 
# On windows you need to select the extension in section "Extensions" 
# during setup of php. On linux the extension is available as package "php-xmlrpc".
# You can also recompile PHP with configure option "--with-xmlrpc".
#
# Set to "xml-rpc-lib" to use library "XMLRPC for PHP" (very slow, not recommended).
# You need first to download the library from http://phpxmlrpc.sourceforge.net,
# unpack it and put the directory "lib" from archive into the nzbgetweb-directory.
#
# Set to "json-rpc-lib" to use library "JSON-PHP" (very slow, not recommended).
# You need first to download the library from 
# http://pear.php.net/pepr/pepr-proposal-show.php?id=198,
# unpack it and put the file JSON.php in nzbgetweb-directory.
#
# Set to "auto" to automatically detect the installed 
# extensions/libraries and to use the best available option.
$RpcApi='auto';


##############################################################################
### CONFIGURATION OF POSTPROCESSING-SCRIPT                                 ###

# Full path to configuration file for postprocessing-script.
#
# Set this option if you use postprocessing-script and it supports
# configuration via web-interface.
#
# Please refer to documentation of your postprocessing-script.
#
# Example (POSIX): $PostProcessConfigFile='/tmp/harddisk/download/nzb/unpack.conf'.
# Example (Windows): $PostProcessConfigFile='C:\\Downloads\\nzbget\\unpack.conf'.
#
# NOTE: Backslashes (on Windows) must be doubled.
$PostProcessConfigFile='/usr/local/nzbget/var/postprocess.conf';

# Full path to the template of configuration file for postprocessing-script.
# This file is used to read the list of options and their descriptions.
#
# Set this option if you use postprocessing-script and it supports
# configuration via web-interface.
#
# Please refer to documentation of your postprocessing-script.
#
# Example (POSIX): $PostProcessConfigTemplate='/tmp/harddisk/www/nzbgetweb/unpack-template.conf'.
# Example (Windows): $PostProcessConfigTemplate='C:\\Program Files\\apache\htdocs\nzbgetweb\\unpack-template.conf'.
#
# NOTE: Backslashes (on Windows) must be doubled.
$PostProcessConfigTemplate='/usr/local/nzbget/var/postprocess.conf.tpl';


##############################################################################
### LOGIN-SCREEN                                                           ###

# User name for web-interface.
#
# Leave blank to disable authorization-check.
$WebUsername = '';

# Password for web-interface.
$WebPassword = 'pass';


##############################################################################
### DISPLAY                                                                ###

# Page refresh interval for group-mode (which is default mode) (seconds).
#
# "0" disables automatic refreshing.
$GroupModeRefreshInterval=30;

# Page refresh interval for file-mode (seconds).
#
# "0" disables automatic refreshing.
$FileModeRefreshInterval=0;

# Number of groups per page in groupmode (1-999).
$GroupsPerPage=20;

# Number of files per page in filemode (1-999).
$FilesPerPage=20;

# Number of downloads per page in historymode (1-999).
$HistoryPerPage=20;

# Number of downloads on the main page history (0-999).
#
# Set to "0" to hide the history on the main page.
$HistoryPerMainPage=5;

# Format for timestamp in historymode.
#
# See description of php-function "date" for the list of possible
# format-characters - http://www.php.net/date.
$HistoryTimeFormat='r';

# Show latest downloads at the top of list (true, false).
$NewHistoryFirst=true;

# Number of log-messages retrieved from server (0-99999).
$LogLines=100;

# List of filters for log messages.
#
# If you want to see less log messages you can define filters.
# Each filter is a substring. If a log message has this substring,
# the message will not be displayed.
#
# Example (if editing config via web-interface): Successfully downloaded, Verifying file
#
# Example (if editing "settings.php" in a texteditor): $LogFilter=array('Successfully downloaded', 'Verifying file');
#
# NOTE: the log message are received from NZBGet server first, then filtered
# by web-interface. It may require some CPU time.
$LogFilter=array('');

# Format for timestamp in log-entries.
#
# See description of php-function "date" for the list of possible
# format-characters - http://www.php.net/date.
# Set to empty string ('') to hide timestamps.
$LogTimeFormat='r';

# Correction for timestamps (hours).
# 
# If nzbgetweb shows incorrect times you can adjust it here (-23..+23).
$TimeZoneCorrection=0;

# Number of log-messages per page (1-999).
$MessagesPerPage=20;

# Number of messages per page in post-processing log (1-999).
#
# Set to "0" to hide the section with script-messages.
$PostMessagesPerPage=10;

# Show new log-messages at the top of list (true, false).
$NewMessagesFirst=false;

# Show log-messages in file-mode (true, false).
$FileModeLog=false;

# The list of characters to replace with blank-char for better word-breaks in browser.
$NameReplaceChars='_.';

# The list of characters to add extra blank-char for better word-breaks in browser.
#
# Example: $LogBreakChars='_.-\\\/'.
$LogBreakChars='_.-\\\/';

# Path to check for available disk-space.
#
# Set it to the same value as option "DstDir" in nzbget.conf-file.
#
# Example (POSIX): $CheckSpaceDir = '/tmp/harddisk/download'.
# Example (Windows): $CheckSpaceDir = 'C:\\'.
# Example (Windows): $CheckSpaceDir = '\\\\192.168.1.1\\share$\\download'.
#
# NOTE: Backslashes (on Windows) must be doubled.
$CheckSpaceDir='@download_dir@';

# List of available categories.
#
# Empty item allows to set the empty category.
$Categories=array('', 'music', 'video', 'video\tv', 'linux', 'My Staff');

# Tranfer method for web-forms (post, get).
#
# Method "post" is recommended for better security.
# However web-server thttpd on optware doesn't support method "post".
$FormMethod='post';


##############################################################################
### MINI-THEME                                                             ###

# The list of characters to replace with blank-char for better word-breaks in browser.
#
# NOTE: Only for mini theme (mini.php).
$MiniLogReplaceChars='_.';

# Font name in mini theme.
#
# NOTE: Only for mini theme (mini.php).
$MiniFontName='Verdana';

# Font size in mini theme (1-999).
#
# NOTE: Only for mini theme (mini.php).
$MiniFontSize='12';

# Allow usage of JavaScript in mini theme (true, false).
# If enabled, a little javascript code is used in mini theme. That allows
# better formatting. If the browser on your mobile device does not support
# JavaScript, you can disable the option.
#
# NOTE: Only for mini theme (mini.php).
$MiniJavaScript=true;

# Display log-messages in two columns (Kind-Text) in mini theme (true, false).
# If disabled, the Kind and Text are displayed in one column, 
# saving screen space.
#
# NOTE: Only for mini theme (mini.php).
$MiniLogColumns=false;


##############################################################################
### NEWZBIN                                                                ###

# User name for www.newzbin.com.
#
# Leave blank to hide newzbin-input box (if you don't have a newzbin account).
$NewzbinUsername='';

# Password for www.newzbin.com.
$NewzbinPassword='';

# Automatically download nzb's to the Newzbin defined category (true, false).
$NewzbinUseCategories=true;

?>
