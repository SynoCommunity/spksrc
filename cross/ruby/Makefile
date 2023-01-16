PKG_NAME = ruby
PKG_VERS = 3.1.2
PKG_SHORT_VERS = $(word 1,$(subst ., ,$(PKG_VERS))).$(word 2,$(subst ., ,$(PKG_VERS)))
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://cache.ruby-lang.org/pub/ruby/$(PKG_SHORT_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = native/ruby
DEPENDS = cross/openssl cross/readline cross/gdbm cross/berkeleydb

# even it compiles with older cross/gdbm, ruby crashes at runtime
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

HOMEPAGE = http://www.ruby-lang.org/
COMMENT  = Ruby Programming Language.
LICENSE  = 2-clause BSDL

PRE_CONFIGURE_TARGET = ruby_pre_configure
POST_CONFIGURE_TARGET = ruby_post_configure
INSTALL_TARGET = ruby_install

RUBYTOOLS = bundle bundler erb gem irb racc rake rbs rdoc ri typeprof

NATIVE_RUBY = $(realpath $(WORK_DIR)/../../../native/$(PKG_NAME)/work-native/install/usr/local/bin/ruby)

# Configure
GNU_CONFIGURE = 1
CONFIGURE_ARGS = --with-baseruby=$(NATIVE_RUBY) --prefix=$(INSTALL_PREFIX) --disable-install-doc

# avoid warning "_FORTIFY_SOURCE requires compiling with optimization (-O)"
ADDITIONAL_CFLAGS = -O3

include ../../mk/spksrc.cross-cc.mk

# Deactivate fstack-protect because we couldn't link to libspp on synology
.PHONY: ruby_pre_configure
ruby_pre_configure:
	sed -i -e 's/x$$stack_protector/x$$stack_protector_broken/g' $(WORK_DIR)/$(PKG_DIR)/configure

# Fix hard-coded path to target install prefix
.PHONY: ruby_post_configure
ruby_post_configure:
	find $(WORK_DIR)/$(PKG_DIR)/.ext/include -name config.h -exec sed -i -e 's|$(STAGING_INSTALL_PREFIX)|$(INSTALL_PREFIX)|' {} \;

.PHONY: ruby_install
# Ruby's configure remembers its own --prefix and uses it during `make install`,
# _in addition to_ any prefix/DESTDIR passed to `make install`.
# Without this override, the install ends up nested in a doubled prefix.
# Finally fix path to ruby in scripts
ruby_install:
	$(RUN) $(MAKE) DESTDIR=$(INSTALL_DIR) install
	@for tool in $(RUBYTOOLS) ; do \
		sed -i -e 's|^#\!$(STAGING_INSTALL_PREFIX)|#\!$(INSTALL_PREFIX)|' $(STAGING_INSTALL_PREFIX)/bin/$${tool} ; \
	done
