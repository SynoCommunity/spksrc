SPK_NAME = java-11-openjdk
JAVA_REPO_NAME = jdk11u
JAVA_NAME = jdk
JAVA_RELEASE = 7
JAVA_VERSION = 11.0.12
SPK_VERS = $(JAVA_VERSION).$(JAVA_RELEASE)
SPK_REV = 1
SPK_ICON = src/$(SPK_NAME).png

DEPENDS  = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = The OpenJDK 11 runtime environment. Version $(JAVA_VERSION)+$(JAVA_RELEASE)
STARTABLE = no
DISPLAY_NAME = Java 11 OpenJDK
CHANGELOG = "Initial version for Synology NAS's"

HOMEPAGE = http://openjdk.java.net/
LICENSE_FILE = src/LICENSE

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
SPK_COMMANDS += bin/unpack200

# Replace wrong symlinks
POST_STRIP_TARGET = java-11-openjdk_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: java-11-openjdk_extra_install
java-11-openjdk_extra_install:
	cd $(STAGING_DIR)/bin ; \
	ln -sf ../jvm/openjdk-$(JAVA_VERSION)/bin/* .
