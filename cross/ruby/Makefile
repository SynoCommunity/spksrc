PKG_NAME = ruby
PKG_VERS = 2.0.0-p0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp.ruby-lang.org/pub/ruby/2.0
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS  = cross/openssl cross/readline native/$(PKG_NAME)

HOMEPAGE = http://www.ruby-lang.org/
COMMENT  = Ruby Programming Language
LICENSE  =

PRE_CONFIGURE_TARGET = myPreConfigure
POST_CONFIGURE_TARGET = myPostConfigure
POST_INSTALL_TARGET = myPostInstall
RUBYTOOLS = erb gem irb rake rdoc ri testrb

# Configure
GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-baseruby=$(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/$(PKG_DIR)/ruby --prefix=$(STAGING_INSTALL_PREFIX) --disable-install-doc

include ../../mk/spksrc.cross-cc.mk

# Desactivate fstack-protect because we couldn't link to libspp on synology
.PHONY: myPreConfigure
myPreConfigure:
	sed -i -e 's/x$$stack_protector/x$$stack_protector_broken/g' $(WORK_DIR)/$(PKG_DIR)/configure

# Fix hard-coded path to target install prefix
.PHONY: myPostConfigure
myPostConfigure:
	find $(WORK_DIR)/$(PKG_DIR)/.ext/include -name config.h -exec sed -i -e 's|$(STAGING_INSTALL_PREFIX)|$(INSTALL_PREFIX)|' {} \;
	
# Fix path to ruby in scripts
.PHONY: myPostInstall
myPostInstall:
	@for tool in $(RUBYTOOLS) ; \
	do \
		sed -i -e 's|^#\!$(STAGING_INSTALL_PREFIX)|#\!$(INSTALL_PREFIX)|' $(STAGING_INSTALL_PREFIX)/bin/$${tool} ; \
	done
