PKG_NAME = gerrit
PKG_VERS = 2.13.3
PKG_EXT = war
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://www.gerritcodereview.com/download
PKG_DIR = $(PKG_NAME)

DEPENDS =

HOMEPAGE = https://www.gerritcodereview.com/
COMMENT  = Gerrit provides web based code review and repository management for the Git version control system.
LICENSE  = Apache License 2.0

CONFIGURE_TARGET = nop
COMPILE_TARGET = nop
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

# Set multiple download URLs after inclusion, to override the single-URL variable in spksrc.cross-cc.mk

GERRIT_URL = $(PKG_DIST_SITE)/$(PKG_DIST_NAME)
BOUNCYCASTLE_DIST_SITE = https://repo1.maven.org/maven2/org/bouncycastle
BC_VER = 1.52
BCPROV_ARTIFACTID = bcprov-jdk15on
BCPKIX_ARTIFACTID = bcpkix-jdk15on
BCPG_ARTIFACTID = bcpg-jdk15on

BCPROV_DIST_PREFIX = bcprov-jdk15on/1.52
BCPKIX_DIST_PREFIX = bcpkix-jdk15on/1.52
BCPG_DIST_PREFIX = bcpg-jdk15on/1.52

BCPROV_DIST_FILE = $(BCPROV_ARTIFACTID)-$(BC_VER).jar
BCPKIX_DIST_FILE = $(BCPKIX_ARTIFACTID)-$(BC_VER).jar
BCPG_DIST_FILE = $(BCPG_ARTIFACTID)-$(BC_VER).jar

URLS = $(GERRIT_URL)\
	   $(BOUNCYCASTLE_DIST_SITE)/$(BCPROV_ARTIFACTID)/$(BC_VER)/$(BCPROV_DIST_FILE)\
	   $(BOUNCYCASTLE_DIST_SITE)/$(BCPKIX_ARTIFACTID)/$(BC_VER)/$(BCPKIX_DIST_FILE)\
	   $(BOUNCYCASTLE_DIST_SITE)/$(BCPG_ARTIFACTID)/$(BC_VER)/$(BCPG_DIST_FILE)

.PHONY: myInstall
myInstall:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/bin
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/lib
	install -m 644 $(DISTRIB_DIR)/$(PKG_DIST_NAME) $(STAGING_INSTALL_PREFIX)/bin/gerrit.war
	install -m 644 $(DISTRIB_DIR)/$(BCPROV_DIST_FILE) $(STAGING_INSTALL_PREFIX)/lib
	install -m 644 $(DISTRIB_DIR)/$(BCPKIX_DIST_FILE) $(STAGING_INSTALL_PREFIX)/lib
	install -m 644 $(DISTRIB_DIR)/$(BCPG_DIST_FILE) $(STAGING_INSTALL_PREFIX)/lib

