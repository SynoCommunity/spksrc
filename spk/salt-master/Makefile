SPK_NAME = salt-master
SPK_VERS = 2014.7.0
SPK_REV = 2
SPK_ICON = src/salt-master.png
DSM_UI_DIR = app

DEPENDS =
SPK_DEPENDS = "python>2.7.8-10"

MAINTAINER = SynoCommunity
DESCRIPTION = Salt, a new approach to infrastructure management, is easy enough to get running in minutes, scalable enough to manage tens of thousands of servers, and fast enough to communicate with those servers in seconds.
ADMIN_PORT = 8282
RELOAD_UI = yes
DISPLAY_NAME = Salt Master
CHANGELOG = "1. Initial package"

HOMEPAGE   = https://www.saltstack.com/
LICENSE    = Apache

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

COPY_TARGET = nop
POST_STRIP_TARGET = salt-master_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: salt-master_extra_install
salt-master_extra_install: $(STAGING_DIR)/wheelhouse
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/etc
	install -m 644 src/master $(STAGING_DIR)/etc/master
	install -m 755 -d $(STAGING_DIR)/share/extensions
	install -m 755 -d $(STAGING_DIR)/share/extensions/auth
	install -m 644 src/synology.py $(STAGING_DIR)/share/extensions/auth/synology.py
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done


$(STAGING_DIR)/wheelhouse:
	@$(MSG) "Building wheelhouse"
	install -m 755 -d $(STAGING_DIR)/share
	@$(PIP_WHEEL) -r src/requirements.txt
