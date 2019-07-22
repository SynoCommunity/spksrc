PKG_NAME = ZeroTierOne
PKG_VERS = 1.2.99-pre1.4.0
PKG_EXT = tar.gz

#PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
#PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
# Special build of 1.2.13 which contains changes required for spksrc pull request.
# This will be removed after next major ZeroTier version bump (1.4.0)
PKG_DIST_NAME = a0f47b12b43c99100c8db87f5a127221d513784b.tar.gz
PKG_DIR = ZeroTierOne-a0f47b12b43c99100c8db87f5a127221d513784b

PKG_DIST_SITE = https://github.com/zerotier/ZeroTierOne/archive

DEPENDS =

GNU_CONFIGURE = 1
CONFIGURE_ARGS = HAVE_CXX=yes
INSTALL_TARGET = zerotier_custom_install
CONFIGURE_TARGET = zerotier_custom_configure

ENV += ZT_SYNOLOGY=1

include ../../mk/spksrc.cross-cc.mk

.PHONY: zerotier_custom_install
zerotier_custom_install:
	$(RUN) mkdir -p $(STAGING_DIR)/bin
	$(RUN) cp zerotier-one $(STAGING_DIR)/bin/zerotier-one
