SPK_NAME = autossh
SPK_VERS = 1.4g
SPK_REV = 2
CHANGELOG = "1. Update OpenSSL to v1.1.<br/>2. Update OpenSSH to v8.4."

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = chrisellsworth
DESCRIPTION = Automatically restart SSH sessions and tunnels. autossh is a program to start a copy of ssh and monitor it, restarting it as necessary should it die or stop passing traffic. The idea is from rstunnel (Reliable SSH Tunnel), but implemented in C.
DISPLAY_NAME = autossh
STARTABLE = no

HOMEPAGE = https://www.harding.motd.ca/autossh/

SPK_COMMANDS = bin/autossh
SPK_COMMANDS += bin/scp bin/sftp bin/slogin bin/ssh bin/ssh-add bin/ssh-agent bin/ssh-keygen bin/ssh-keyscan
SPK_COMMANDS += libexec/sftp-server libexec/ssh-keysign libexec/ssh-pkcs11-helper libexec/ssh-sk-helper
SPK_COMMANDS += sbin/sshd

include ../../mk/spksrc.spk.mk
