PKG_NAME = apparmor-utils
include ../libapparmor/apparmor.pkg.mk

COMMENT  = Tools for interacting with the AppArmor linux kernel security module
LICENSE  = GPLv2

# We need the libapparmor python binding
ENV += AA_BINDING_PYTHON=y

# Make sure python is built first or libapparmor build will fail
DEPENDS  = $(AA_PYTHON_PKG)
DEPENDS += cross/libapparmor

CONFIGURE_TARGET = apparmor-utils_configure

COMPILE_TARGET = apparmor-utils_compile

# Does not work right now. Misconfigured python?
# N.B. Host needs package "pyflakes"
#PRE_INSTALL_TARGET = apparmor-utils_check
INSTALL_TARGET = apparmor-utils_install
POST_INSTALL_TARGET = apparmor-utils_post_install

include ../../mk/spksrc.cross-cc.mk

# Fetch python variables
include $(WORK_DIR)/python-cc.mk

# Python module variables
PYTHONPATH = $(PYTHON_SITE_PACKAGES_NATIVE):$(PYTHON_LIB_NATIVE):$(INSTALL_DIR)$(INSTALL_PREFIX)/$(PYTHON_LIB_DIR)/site-packages/
ENV += PYTHONPATH=$(PYTHONPATH)
AA_UTILS_RUN = cd $(WORK_DIR)/$(PKG_DIR)/utils && env $(ENV)

AA_UTILS_PYTHON_SCRIPTS = bin/aa-easyprof \
	sbin/aa-genprof \
	sbin/aa-logprof \
	sbin/aa-cleanprof \
	sbin/aa-mergeprof \
	sbin/aa-autodep \
	sbin/aa-audit \
	sbin/aa-complain \
	sbin/aa-enforce \
	sbin/aa-disable \
	sbin/aa-notify \
	sbin/aa-unconfined

.PHONY: apparmor-utils_configure
apparmor-utils_configure:
	@$(AA_UTILS_RUN) sed -i "s|@AA_PREFIX@|$(INSTALL_PREFIX)|" apparmor/aa.py
	@$(AA_UTILS_RUN) sed -i "s|@AA_PREFIX@|$(INSTALL_PREFIX)|" logprof.conf
	@$(AA_UTILS_RUN) sed -i "s|@AA_PREFIX@|$(INSTALL_PREFIX)|" easyprof/easyprof.conf

.PHONY: apparmor-utils_compile
apparmor-utils_compile:
	@. $(CROSSENV) && $(AA_UTILS_RUN) $(MAKE) $(COMPILE_MAKE_OPTIONS)

.PHONY: apparmor-utils_install
apparmor-utils_install:
	@. $(CROSSENV) && $(AA_UTILS_RUN) $(MAKE) \
		DESTDIR=$(INSTALL_DIR) \
		PYPREFIX=$(INSTALL_PREFIX) \
		BINDIR=$(INSTALL_DIR)$(INSTALL_PREFIX)/sbin \
		CONFDIR=$(INSTALL_DIR)$(INSTALL_PREFIX)/etc/apparmor \
		install prefix=$(INSTALL_PREFIX)

.PHONY: apparmor-utils_post_install
apparmor-utils_post_install:
	@for SCRIPT in $(AA_UTILS_PYTHON_SCRIPTS); do \
		sed -i "s@^#! /usr/bin/python3@#! $(INSTALL_PREFIX)/bin/python3@" $(INSTALL_DIR)$(INSTALL_PREFIX)/$$SCRIPT; \
	done
