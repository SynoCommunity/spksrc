PKG_NAME = acl
PKG_VERS = 2.2.52
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).src.$(PKG_EXT)
PKG_DIST_SITE = http://download.savannah.gnu.org/releases/acl
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/attr
ADDITIONAL_CFLAGS = -I$(STAGING_INSTALL_PREFIX)/include/

HOMEPAGE = http://kernel.org/
COMMENT  = 
LICENSE  = 

GNU_CONFIGURE = 1
INSTALL_TARGET = myInstall

CONFIGURE_ARGS  = --exec_prefix=/ CPPFLAGS=-I$(STAGING_INSTALL_PREFIX)/include LDFLAGS=-L$(STAGING_INSTALL_PREFIX)/lib

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
# special-case the install for python3.5.5 avoiding breaking borgbackup (this
# logic says "is 'python3' in the path?" via "if I replace python3 with garbage,
# is it a different path?"
#
# note: borgbackup may also need install/install-* re-orderd: installer now
# fails if a depencent lib is not already installed
myInstall:
ifneq ($(subst python3,garbage,$(STAGING_DIR)),$(STAGING_DIR))
	$(RUN) $(MAKE) DIST_ROOT=$(STAGING_INSTALL_PREFIX) LN_S=ln install-dev install-lib install
	@echo fail fast
	test -e $(STAGING_INSTALL_PREFIX)/lib/libacl.la*
	test -f $(STAGING_INSTALL_PREFIX)/bin/chacl
else
	$(RUN) $(MAKE) DIST_ROOT=$(INSTALL_DIR) install install-lib install-dev
endif
