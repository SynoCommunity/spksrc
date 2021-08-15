SPK_NAME = java-1.8.0-openjdk
SPK_VERS = 312.2
SPK_REV = 1
SPK_ICON = src/$(SPK_NAME).png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = The OpenJDK 8 runtime environment
RELOAD_UI = no
STARTABLE = no
DISPLAY_NAME = java-1.8.0-openjdk
CHANGELOG = "Java 1.8.0 version 312 b02"

HOMEPAGE = http://openjdk.java.net/
LICENSE  = ASL 1.1 and ASL 2.0 and BSD and BSD with advertising and GPL+ and GPLv2 and GPLv2 with exceptions and IJG and LGPLv2+ and MIT and MPLv2.0 and Public Domain and W3C and zlib

SPK_COMMANDS  = bin/alt-java
SPK_COMMANDS += bin/appletviewer
SPK_COMMANDS += bin/clhsdb
SPK_COMMANDS += bin/extcheck
SPK_COMMANDS += bin/hsdb
SPK_COMMANDS += bin/idlj
SPK_COMMANDS += bin/jar
SPK_COMMANDS += bin/jarsigner
SPK_COMMANDS += bin/java
SPK_COMMANDS += bin/javac
SPK_COMMANDS += bin/javadoc
SPK_COMMANDS += bin/javah
SPK_COMMANDS += bin/javap
SPK_COMMANDS += bin/java-rmi.cgi
SPK_COMMANDS += bin/jcmd
SPK_COMMANDS += bin/jconsole
SPK_COMMANDS += bin/jdb
SPK_COMMANDS += bin/jdeps
SPK_COMMANDS += bin/jfr
SPK_COMMANDS += bin/jhat
SPK_COMMANDS += bin/jinfo
SPK_COMMANDS += bin/jjs
SPK_COMMANDS += bin/jmap
SPK_COMMANDS += bin/jps
SPK_COMMANDS += bin/jrunscript
SPK_COMMANDS += bin/jsadebugd
SPK_COMMANDS += bin/jstack
SPK_COMMANDS += bin/jstat
SPK_COMMANDS += bin/jstatd
SPK_COMMANDS += bin/keytool
SPK_COMMANDS += bin/native2ascii
SPK_COMMANDS += bin/orbd
SPK_COMMANDS += bin/pack200
SPK_COMMANDS += bin/policytool
SPK_COMMANDS += bin/rmic
SPK_COMMANDS += bin/rmid
SPK_COMMANDS += bin/rmiregistry
SPK_COMMANDS += bin/schemagen
SPK_COMMANDS += bin/serialver
SPK_COMMANDS += bin/servertool
SPK_COMMANDS += bin/tnameserv
SPK_COMMANDS += bin/unpack200
SPK_COMMANDS += bin/wsgen
SPK_COMMANDS += bin/wsimport
SPK_COMMANDS += bin/xjc

# Replace wrong symlinks
POST_STRIP_TARGET = $(SPK_NAME)_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: $(SPK_NAME)_extra_install
$(SPK_NAME)_extra_install:
	cd $(STAGING_DIR)/bin ; \
	ln -sf ../jvm/openjdk-1.8.0_312/bin/* .
