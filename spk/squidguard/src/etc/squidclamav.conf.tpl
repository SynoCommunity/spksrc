#-----------------------------------------------------------------------------
# SquidClamav default configuration file
#
# To know to customize your configuration file, see squidclamav manpage
# or go to http://squidclamav.darold.net/
#
#-----------------------------------------------------------------------------
#
# Global configuration
#

# Maximum size of a file that may be scanned. Any file bigger that this value
# will not be scanned.
maxsize 5000000

# When a virus is found then redirect the user to this URL
redirect http://==HOSTNAME==:5000/webman/3rdparty/squidguard/clwarn.cgi

# Path to the squiGuard binary if you want URL filtering, note that you'd better
# use the squid configuration directive 'url_rewrite_program' instead.
#squidguard /usr/local/squidGuard/bin/squidGuard

# Path to the clamd socket, use clamd_local if you use Unix socket or if clamd
# is listening on an Inet socket, comment clamd_local and set the clamd_ip and
# clamd_port to the corresponding value.
clamd_local /usr/local/squidguard/var/run/clamd/clamd.ctl
#clamd_ip 192.168.1.5,127.0.0.1
# clamd_port 3310

# Set the timeout for clamd connection. Default is 1 second, this is a good
# value but if you have slow service you can increase up to 3.
timeout 1

# Force SquidClamav to log all virus detection or squiguard block redirection
# to the c-icap log file.
logredir 0

# Enable / disable DNS lookup of client ip address. Default is enabled '1' to
# preserve backward compatibility but you must desactivate this feature if you
# don't use trustclient with hostname in the regexp or if you don't have a DNS
# on your network. Disabling it will also speed up squidclamav.
dnslookup 1

# Enable / Disable Clamav Safe Browsing feature. You mus have enabled the
# corresponding behavior in clamd by enabling SafeBrowsing into freshclam.conf
# Enabling it will first make a safe browsing request to clamd and then the
# virus scan request. 
safebrowsing 0

#
# Here is some defaut regex pattern to have a high speed proxy on system
# with low resources.
#

# Do not scan images
#abort ^.*\.(ico|gif|png|jpg)$
#abortcontent ^image\/.*$

# Do not scan text files
#abort ^.*\.(css|xml|xsl|js|html|jsp)$
#abortcontent ^text\/.*$
#abortcontent ^application\/x-javascript$

# Do not scan streamed videos
#abortcontent ^video\/x-flv$
#abortcontent ^video\/mp4$

# Do not scan flash files
#abort ^.*\.swf$
#abortcontent ^application\/x-shockwave-flash$

# Do not scan sequence of framed Microsoft Media Server (MMS) data packets
#abortcontent ^.*application\/x-mms-framed.*$

# White list some sites
#whitelist .*\.clamav.net

# See also 'trustuser' and 'trustclient' configuration directives

