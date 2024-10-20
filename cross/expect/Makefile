PKG_NAME = expect
PKG_VERS = 5.45.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://sourceforge.net/projects/expect/files/Expect/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)$(PKG_VERS)

DEPENDS = cross/tcl

HOMEPAGE = https://www.nist.gov/services-resources/software/expect
COMMENT  = Expect is a tool for automating interactive applications such as telnet, ftp, passwd, fsck, rlogin, tip, etc. Expect is also useful for testing these same applications.
LICENSE  = Public Domain

GNU_CONFGURE = 1

PATCHES_LEVEL = 1

CONFIGURE_ARGS = cross_compiling=yes 
# provide info not available with cross compile:
CONFIGURE_ARGS += ac_cv_func_setpgrp_void=yes

# avoid build/install of examples (SCRIPTS) and doc
COMPILE_MAKE_OPTIONS = binaries libraries
INSTALL_MAKE_OPTIONS = install-binaries install-libraries SCRIPTS= DESTDIR=$(INSTALL_DIR) prefix=$(INSTALL_PREFIX)

ADDITIONAL_CFLAGS = -O2

PRE_CONFIGURE_TARGET = expect_pre_configure

include ../../mk/spksrc.cross-cc.mk

.PHONY: expect_pre_configure
expect_pre_configure:
	@$(MSG) Run autoconf since we patched configure.in
	@$(RUN) ; autoconf
