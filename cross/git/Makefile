PKG_NAME = git
PKG_VERS = 2.37.2
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://kernel.org/pub/software/scm/git
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libexpat cross/zlib cross/openssl cross/libssh2 cross/curl

HOMEPAGE = https://git-scm.com
COMMENT  = Git is a fast, scalable, distributed revision control system with an unusually rich command set that provides both high-level operations and full access to internals.
LICENSE  = GPLv2

GNU_CONFIGURE = 1
CONFIGURE_ARGS  = --without-tcltk --without-python
# the following cannot be evaluated by running tests while cross compiling
CONFIGURE_ARGS += ac_cv_iconv_omits_bom=no
CONFIGURE_ARGS += ac_cv_fread_reads_directories=yes
CONFIGURE_ARGS += ac_cv_snprintf_returns_bogus=no

# git (since version 2.35.0) requires C99 support (such as -std=c99, -std=gnu99, -std=c11 or -std=gnu11)
# builds with -std=c99 do not run on 32 bit arm and ppc archs ("fatal: Cannot handle files this big"),
# but -std=gnu99 works for those.
ADDITIONAL_CPPFLAGS  = -std=gnu99
ADDITIONAL_CPPFLAGS += -O

PRE_CONFIGURE_TARGET = git_pre_configure
POST_INSTALL_TARGET = git_post_install

INSTALL_MAKE_OPTIONS = install DESTDIR=$(INSTALL_DIR) prefix=$(INSTALL_PREFIX) NO_INSTALL_HARDLINKS=1

# compiling needs access to curl-config from cross/curl
ENV += PATH=$$PATH:$(STAGING_INSTALL_PREFIX)/bin

include ../../mk/spksrc.cross-cc.mk

.PHONY: git_pre_configure
git_pre_configure:
	@$(RUN) autoconf

.PHONY: git_post_install
git_post_install:
	@install -m 755 -d $(STAGING_INSTALL_PREFIX)/etc
	@install -m 644 src/gitconfig $(STAGING_INSTALL_PREFIX)/etc/gitconfig
