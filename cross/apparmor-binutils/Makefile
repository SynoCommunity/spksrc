PKG_NAME = apparmor-binutils
include ../libapparmor/apparmor.pkg.mk

COMMENT  = Tools for interacting with the AppArmor linux kernel security module
LICENSE  = GPLv2

DEPENDS = cross/libapparmor

CONFIGURE_TARGET = nop

COMPILE_TARGET = apparmor-binutils_compile

INSTALL_TARGET = apparmor-binutils_install

include ../../mk/spksrc.cross-cc.mk

AA_BINUTILS_RUN = cd $(WORK_DIR)/$(PKG_DIR)/binutils && env $(ENV)

.PHONY: apparmor-binutils_compile
apparmor-binutils_compile:
	$(AA_BINUTILS_RUN) $(MAKE) $(COMPILE_MAKE_OPTIONS)

.PHONY: apparmor-binutils_install
apparmor-binutils_install:
	$(AA_BINUTILS_RUN) $(MAKE) \
		DESTDIR=$(INSTALL_DIR) \
		BINDIR=$(INSTALL_DIR)$(INSTALL_PREFIX)/bin \
		SBINDIR=$(INSTALL_DIR)$(INSTALL_PREFIX)/sbin \
		LOCALEDIR=$(INSTALL_PREFIX)/share/locale \
		install prefix=$(INSTALL_PREFIX)
