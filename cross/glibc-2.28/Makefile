PKG_NAME = glibc
PKG_VERS = 2.28
PKG_EXT = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.gnu.org/gnu/glibc/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = 

HOMEPAGE = https://www.gnu.org/software/libc/
COMMENT  = The GNU C Library (glibc)
LICENSE  = GPLv2/LGPLv2

GNU_CONFIGURE = 1

include ../../mk/spksrc.archs.mk

CONFIGURE_TARGET = glibc_configure_target
COMPILE_TARGET = glibc_compile_taget
INSTALL_TARGET = glibc_install_target

CONFIGURE_ARGS  = --enable-shared
CONFIGURE_ARGS += --enable-kernel=$(word 1,$(subst ., ,$(TC_KERNEL))).$(word 2,$(subst ., ,$(TC_KERNEL)))
CONFIGURE_ARGS += --disable-timezone-tools
CONFIGURE_ARGS += --disable-crypt
CONFIGURE_ARGS += --disable-build-nscd
CONFIGURE_ARGS += --disable-nscd
CONFIGURE_ARGS += --disable-werror
CONFIGURE_ARGS += --enable-stack-protector=strong
CONFIGURE_ARGS += --with-headers=$(TC_SYSROOT)/usr/include
CONFIGURE_ARGS += ac_cv_prog_MAKEINFO=false

include ../../mk/spksrc.cross-cc.mk

.PHONY: glibc_configure_target
glibc_configure_target:
	@mkdir $(WORK_DIR)/$(PKG_DIR)-build
	$(RUN) && cd ../$(PKG_DIR)-build && env $(ENV) ../$(PKG_DIR)/configure $(REAL_CONFIGURE_ARGS)

.PHONY: glibc_compile_taget
glibc_compile_taget:
	@$(RUN) && cd ../$(PKG_DIR)-build && env $(ENV) $(PSTAT_TIME) $(MAKE) -j$(NCPUS) $(COMPILE_MAKE_OPTIONS)

.PHONY: glibc_install_target
glibc_install_target:
	@$(RUN) && cd ../$(PKG_DIR)-build && env $(ENV) $(MAKE) install DESTDIR=$(INSTALL_DIR)
