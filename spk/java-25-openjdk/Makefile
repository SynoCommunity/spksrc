SPK_NAME = java-25-openjdk
JAVA_RELEASE = 9
JAVA_VERSION = 25.0.3
SPK_VERS = $(JAVA_VERSION).$(JAVA_RELEASE)
SPK_REV = 1
SPK_ICON = src/java-openjdk.png

DEPENDS = cross/java-25-openjdk

# gcc < 10.0 is not officially supported
REQUIRED_MIN_DSM = 7.2
REQUIRED_MIN_SRM = 1.3
# 32 bit archs are not supported
UNSUPPORTED_ARCHS = $(32bit_ARCHS)

MAINTAINER = SynoCommunity
DESCRIPTION = OpenJDK version $(JAVA_VERSION)+$(JAVA_RELEASE). OpenJDK 25 is the open-source reference implementation of version 25 of the Java SE Platform as specified by JSR 400 in the Java Community Process.

STARTABLE = no
DISPLAY_NAME = Java 25 OpenJDK
CHANGELOG = "init package."

HOMEPAGE = https://openjdk.org/projects/jdk/25/
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
SPK_COMMANDS += bin/jhsdb
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

include ../../mk/spksrc.spk.mk
