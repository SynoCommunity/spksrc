SPK_NAME = autossh
SPK_VERS = 1.4g
SPK_REV = 1
CHANGELOG = "Version 1.4g most notably addresses a bug that could see an alarm signal occur without a handler, causing autossh to exit inappropriately."

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = chrisellsworth
DESCRIPTION = autossh is a program to start a copy of ssh and monitor it, restarting it as necessary should it die or stop passing traffic. The idea is from rstunnel (Reliable SSH Tunnel), but implemented in C.
DISPLAY_NAME = autossh
STARTABLE = no

HOMEPAGE = https://www.harding.motd.ca/autossh/

SPK_COMMANDS = bin/autossh

include ../../mk/spksrc.spk.mk
