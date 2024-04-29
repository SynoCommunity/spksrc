SPK_NAME = java-17-openjdk
JAVA_REPO_NAME = jdk17u
JAVA_NAME = jdk
JAVA_RELEASE = 10
JAVA_VERSION = 17.0.6
SPK_VERS = $(JAVA_VERSION).$(JAVA_RELEASE)
SPK_REV = 1
SPK_ICON = src/java-openjdk.png

DEPENDS = cross/java-17-openjdk

# gcc >= 5.0 required
REQUIRED_MIN_DSM = 7.0
UNSUPPORTED_ARCHS = comcerto2k

MAINTAINER = SynoCommunity
DESCRIPTION = OpenJDK version $(JAVA_VERSION)+$(JAVA_RELEASE). OpenJDK 17 is the open-source reference implementation of version 17 of the Java SE Platform as specified by JSR 390 in the Java Community Process.

STARTABLE = no
DISPLAY_NAME = Java 17 OpenJDK
CHANGELOG = "Initial Java 17 package release"

HOMEPAGE = https://openjdk.org/projects/jdk/17/
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
SPK_COMMANDS += bin/jlink
SPK_COMMANDS += bin/jmap
SPK_COMMANDS += bin/jmod
SPK_COMMANDS += bin/jpackage
SPK_COMMANDS += bin/jps
SPK_COMMANDS += bin/jrunscript
SPK_COMMANDS += bin/jshell
SPK_COMMANDS += bin/jstack
SPK_COMMANDS += bin/jstat
SPK_COMMANDS += bin/jstatd
SPK_COMMANDS += bin/keytool
SPK_COMMANDS += bin/rmiregistry
SPK_COMMANDS += bin/serialver

include ../../mk/spksrc.spk.mk
