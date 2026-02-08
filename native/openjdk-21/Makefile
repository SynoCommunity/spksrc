PKG_NAME = openjdk-21
PKG_VERS = 35
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)+$(PKG_VERS)_linux-x64_bin.$(PKG_EXT)
PKG_DIST_SITE = https://download.java.net/openjdk/jdk21/ri
PKG_DIR = jdk-21

HOMEPAGE = https://jdk.java.net/java-se-ri/21
COMMENT  = The official Reference Implementation for Java SE 17 (JSR 392).
# openjdk.java.net/legal/gplv2+ce.html
LICENSE = GPL v2 with Classpath Exception

# use the jdk-21 folder (i.e. PKG_DIR)
INSTALL_TARGET = nop

include ../../mk/spksrc.native-install.mk
