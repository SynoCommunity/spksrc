PKG_NAME = apparmor-parser
include ../libapparmor/apparmor.pkg.mk

COMMENT  = Parser for the AppArmor linux kernel security module
LICENSE  = GPLv2

DEPENDS = cross/libapparmor

CONFIGURE_TARGET = apparmor-parser_configure

COMPILE_TARGET = apparmor-parser_compile

INSTALL_TARGET = apparmor-parser_install

include ../../mk/spksrc.cross-cc.mk

AA_PARSER_RUN = cd $(WORK_DIR)/$(PKG_DIR)/parser && env $(ENV)

.PHONY: apparmor-parser_configure
apparmor-parser_configure:
	$(AA_PARSER_RUN) sed -i "s|@AA_PROFILE_DIR@|$(INSTALL_PREFIX)/etc/apparmor.d|" parser.conf

.PHONY: apparmor-parser_compile
apparmor-parser_compile:
	$(AA_PARSER_RUN) $(MAKE) $(COMPILE_MAKE_OPTIONS)

.PHONY: apparmor-parser_install
apparmor-parser_install:
	$(AA_PARSER_RUN) $(MAKE) \
		DESTDIR=$(INSTALL_DIR)$(INSTALL_PREFIX) \
		APPARMOR_BIN_PREFIX=$(INSTALL_DIR)$(INSTALL_PREFIX)/lib/apparmor \
		SBINDIR=$(INSTALL_DIR)$(INSTALL_PREFIX)/sbin \
		USR_SBINDIR=$(INSTALL_DIR)$(INSTALL_PREFIX)/sbin \
		SYSTEMD_UNIT_DIR=$(INSTALL_DIR)$(INSTALL_PREFIX)/lib/systemd/system \
		CONFDIR=/etc/apparmor \
		INSTALL_CONFDIR=$(INSTALL_DIR)$(INSTALL_PREFIX)/etc/apparmor \
		LOCALEDIR=/share/locale \
		install prefix=$(INSTALL_PREFIX)
