SPK_NAME = java-11-openjdk
SPK_VERS = 11.0
SPK_REV = 1
SPK_ICON = src/$(SPK_NAME).png

DEPENDS = cross/$(SPK_NAME) cross/cups

MAINTAINER = SynoCommunity
DESCRIPTION = The OpenJDK 11 runtime environment. Version 11.0.12+7
RELOAD_UI = no
STARTABLE = no
DISPLAY_NAME = java-11-openjdk
CHANGELOG = "Initial version for Synology NAS's"

HOMEPAGE = http://openjdk.java.net/
LICENSE_FILE = src/LICENSE

SPK_COMMANDS  = bin/alt-java
SPK_COMMANDS += bin/jaotc
SPK_COMMANDS += bin/jar
SPK_COMMANDS += bin/jarsigner
SPK_COMMANDS += bin/java
SPK_COMMANDS += bin/javac
SPK_COMMANDS += bin/javadoc
SPK_COMMANDS += bin/javap
SPK_COMMANDS += bin/jcmd
SPK_COMMANDS += bin/jconsole
SPK_COMMANDS += bin/jdb
SPK_COMMANDS += bin/jdeprscan
SPK_COMMANDS += bin/jdeps
SPK_COMMANDS += bin/jfr
SPK_COMMANDS += bin/jhsdb
SPK_COMMANDS += bin/jimage
SPK_COMMANDS += bin/jinfo
SPK_COMMANDS += bin/jjs
SPK_COMMANDS += bin/jlink
SPK_COMMANDS += bin/jmap
SPK_COMMANDS += bin/jmod
SPK_COMMANDS += bin/jps
SPK_COMMANDS += bin/jrunscript
SPK_COMMANDS += bin/jshell
SPK_COMMANDS += bin/jstack
SPK_COMMANDS += bin/jstat
SPK_COMMANDS += bin/jstatd
SPK_COMMANDS += bin/keytool
SPK_COMMANDS += bin/pack200
SPK_COMMANDS += bin/rmic
SPK_COMMANDS += bin/rmid
SPK_COMMANDS += bin/rmiregistry
SPK_COMMANDS += bin/serialver

# Replace wrong symlinks
POST_STRIP_TARGET = $(SPK_NAME)_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: $(SPK_NAME)_extra_install
$(SPK_NAME)_extra_install:
	cd $(STAGING_DIR)/bin ; \
	ln -sf ../jvm/openjdk-11.0.12/bin/* .
