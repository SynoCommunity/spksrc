SPK_NAME = monitoring-plugins
SPK_VERS = 2.3.1
SPK_REV = 2
SPK_ICON = src/monitoring-plugins.png

DEPENDS = cross/monitoring-plugins

SPK_DEPENDS = Perl

MAINTAINER = Gagi2k
DESCRIPTION = Standard plugins for Icinga, Naemon, Nagios, Shinken, Sensu, and other monitoring applications.
CHANGELOG = "1. Update monitoring-plugins to v2.3.1<br/>2. Add Perl package as requirement.<br/>3. Link the check commands to /usr/local/bin."
STARTABLE = no
DISPLAY_NAME = Monitoring Plugins

HOMEPAGE = https://www.monitoring-plugins.org
LICENSE  = GPLv3

SPK_COMMANDS  = bin/check_breeze
SPK_COMMANDS += bin/check_clamd
SPK_COMMANDS += bin/check_cluster
SPK_COMMANDS += bin/check_disk
SPK_COMMANDS += bin/check_disk_smb
SPK_COMMANDS += bin/check_dummy
SPK_COMMANDS += bin/check_file_age
SPK_COMMANDS += bin/check_ftp
SPK_COMMANDS += bin/check_http
SPK_COMMANDS += bin/check_ide_smart
SPK_COMMANDS += bin/check_ifoperstatus
SPK_COMMANDS += bin/check_ifstatus
SPK_COMMANDS += bin/check_imap
SPK_COMMANDS += bin/check_ircd
SPK_COMMANDS += bin/check_load
SPK_COMMANDS += bin/check_log
SPK_COMMANDS += bin/check_mailq
SPK_COMMANDS += bin/check_mrtg
SPK_COMMANDS += bin/check_mrtgtraf
SPK_COMMANDS += bin/check_nagios
SPK_COMMANDS += bin/check_nntp
SPK_COMMANDS += bin/check_nt
SPK_COMMANDS += bin/check_ntp
SPK_COMMANDS += bin/check_ntp_peer
SPK_COMMANDS += bin/check_ntp_time
SPK_COMMANDS += bin/check_nwstat
SPK_COMMANDS += bin/check_oracle
SPK_COMMANDS += bin/check_overcr
SPK_COMMANDS += bin/check_ping
SPK_COMMANDS += bin/check_pop
SPK_COMMANDS += bin/check_procs
SPK_COMMANDS += bin/check_real
SPK_COMMANDS += bin/check_rpc
SPK_COMMANDS += bin/check_smtp
SPK_COMMANDS += bin/check_ssh
SPK_COMMANDS += bin/check_swap
SPK_COMMANDS += bin/check_tcp
SPK_COMMANDS += bin/check_time
SPK_COMMANDS += bin/check_udp
SPK_COMMANDS += bin/check_ups
SPK_COMMANDS += bin/check_uptime
SPK_COMMANDS += bin/check_users
SPK_COMMANDS += bin/check_wave
# must be found in /usr/local/bin too:
SPK_COMMANDS += bin/utils.sh
SPK_COMMANDS += bin/utils.pm

include ../../mk/spksrc.spk.mk
