PKG_NAME = apparmor-profiles
include ../libapparmor/apparmor.pkg.mk

COMMENT  = Profiles and abstractions for the AppArmor linux kernel security module
LICENSE  = GPLv2

DEPENDS = cross/apparmor-parser

CONFIGURE_TARGET = nop

COMPILE_TARGET = apparmor-profiles_compile

INSTALL_TARGET = apparmor-profiles_install

include ../../mk/spksrc.cross-cc.mk

AA_PROFILES_RUN = cd $(WORK_DIR)/$(PKG_DIR)/profiles && env $(ENV)

.PHONY: apparmor-profiles_compile
apparmor-profiles_compile:
	$(AA_PROFILES_RUN) $(MAKE) $(COMPILE_MAKE_OPTIONS)

.PHONY: apparmor-profiles_install
apparmor-profiles_install:
	$(AA_PROFILES_RUN) $(MAKE) \
		DESTDIR=$(INSTALL_DIR) \
		PROFILES_DEST=$(INSTALL_DIR)$(INSTALL_PREFIX)/etc/apparmor.d \
		EXTRAS_DEST=$(INSTALL_DIR)$(INSTALL_PREFIX)/share/apparmor/extra-profiles/ \
		install prefix=$(INSTALL_PREFIX)
