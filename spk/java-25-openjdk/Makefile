SPK_NAME = java-25-openjdk
JAVA_RELEASE = 1
JAVA_VERSION = 25.0.5.0.3
SPK_VERS = 25.0.5
SPK_REV = 2
SPK_ICON = src/java-openjdk.png

DEPENDS = cross/java-25-openjdk

include ../../mk/spksrc.common.mk

MAINTAINER = SynoCommunity
DESCRIPTION = OpenJDK version $(JAVA_VERSION)+$(JAVA_RELEASE). OpenJDK 25 is the open-source reference implementation of version 25 of the Java SE Platform as specified by JSR 400 in the Java Community Process.

STARTABLE = no
DISPLAY_NAME = Java 25 OpenJDK
CHANGELOG = "1. Update to v25.0.5.0.3+1 with October 2026 security fixes.<br/>2. Add the DejaVu fonts, so that Java can render text: DSM ships no font."

HOMEPAGE = https://openjdk.org/projects/jdk/25/
LICENSE_FILE = src/LICENSE

SPK_COMMANDS += bin/jar
SPK_COMMANDS += bin/jarsigner
SPK_COMMANDS += bin/java
SPK_COMMANDS += bin/javac
SPK_COMMANDS += bin/javadoc
SPK_COMMANDS += bin/javap
SPK_COMMANDS += bin/jcmd
SPK_COMMANDS += bin/jdb
SPK_COMMANDS += bin/jdeprscan
SPK_COMMANDS += bin/jdeps
SPK_COMMANDS += bin/jfr
ifeq ($(filter $(ARCH),$(32bit_ARCHS)),)
# Zero, the 32-bit VM, has no serviceability agent
SPK_COMMANDS += bin/jhsdb
endif
SPK_COMMANDS += bin/jimage
SPK_COMMANDS += bin/jinfo
SPK_COMMANDS += bin/jlink
SPK_COMMANDS += bin/jmap
SPK_COMMANDS += bin/jmod
SPK_COMMANDS += bin/jnativescan
SPK_COMMANDS += bin/jpackage
SPK_COMMANDS += bin/jps
SPK_COMMANDS += bin/jrunscript
SPK_COMMANDS += bin/jshell
SPK_COMMANDS += bin/jstack
SPK_COMMANDS += bin/jstat
SPK_COMMANDS += bin/jstatd
SPK_COMMANDS += bin/jwebserver
SPK_COMMANDS += bin/keytool
SPK_COMMANDS += bin/rmiregistry
SPK_COMMANDS += bin/serialver
# named for this version: the unversioned ones go to the JDK started last
SPK_COMMANDS += bin/java25
SPK_COMMANDS += bin/javac25
SPK_COMMANDS += bin/jar25

include ../../mk/spksrc.spk.mk
