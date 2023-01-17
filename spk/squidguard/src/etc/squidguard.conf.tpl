#
# CONFIG FILE FOR SQUIDGUARD
#

# Global variables
logdir	/usr/local/squidguard/var/logs
dbhome	/usr/local/squidguard/var/db

# Time rules
# abbrev for weekdays:
# s = sun, m = mon, t =tue, w = wed, h = thu, f = fri, a = sat

# Source addresses
src localNetwork {
	ip	10.0.0.0/8
	ip	172.16.0.0/12
	ip	192.168.0.0/16
}

# Destination classes

# Rewrite rules

# Policies
acl {
	default {
		pass	all
		redirect	http://==HOSTNAME==:5000/webman/3rdparty/squidguard/squidGuard.cgi?clientaddr=%a&clientname=%n&clientuser=%i&clientgroup=%s&targetgroup=%t&url=%u
	}
}
