PKG_NAME = duplicity
PKG_VERS = 0.8.19
PKG_SHORT_VERS = $(word 1,$(subst ., ,$(PKG_VERS))).$(word 2,$(subst ., ,$(PKG_VERS)))
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://launchpad.net/$(PKG_NAME)/$(PKG_SHORT_VERS)-series/$(PKG_VERS)/+download
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/librsync

HOMEPAGE = http://duplicity.nongnu.org/
COMMENT  = Encrypted bandwidth-efficient backup using the rsync algorithm.
LICENSE  = GPLv2

PRE_CONFIGURE_TARGET = duplicity_pre_configure

include ../../mk/spksrc.python-wheel.mk

.PHONY: duplicity_pre_configure
# adjust shebang in python scripts
duplicity_pre_configure:
	$(RUN) ; sed -i -e  '1 s|^#!/.*|#!/var/packages/duplicity/target/env/bin/python|g' bin/duplicity
	$(RUN) ; sed -i -e  '1 s|^#!/.*|#!/var/packages/duplicity/target/env/bin/python|g' bin/rdiffdir
