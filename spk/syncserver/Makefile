SPK_NAME = syncserver
SPK_VERS = 1.0
SPK_REV = 1
SPK_ICON = src/syncserver.png
DSM_UI_DIR = app

DEPENDS  = cross/busybox
SPK_DEPENDS = "python>2.7.3-3"

MAINTAINER = SynoCommunity
DESCRIPTION = Python implementation of the Firefox Sync Server
DISPLAY_NAME = SyncServer

HOMEPAGE   = https://wiki.mozilla.org/Services/Sync/Server
LICENSE    = MPL/GPL/LGPL

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = syncserver_extra_install

BUSYBOX_CONFIG  = nice
# Add ionice for ARCHs that support it
ifeq ($(findstring $(ARCH),88f6281 qoriq),$(ARCH))
BUSYBOX_CONFIG += ionice
endif
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: syncserver_extra_install
syncserver_extra_install: $(STAGING_DIR)/share/requirements.pybundle $(STAGING_DIR)/share/syncserver
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 src/syncserver.conf $(STAGING_DIR)/var/
	install -m 755 src/syncserver.wsgi $(STAGING_DIR)/var/
	install -m 755 src/syncserver.ini $(STAGING_DIR)/var/
	install -m 755 -d $(STAGING_DIR)/var/log
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
			$(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done

$(STAGING_DIR)/share/requirements.pybundle:
	@$(MSG) "Bundling requirements"
	install -m 755 -d $(STAGING_DIR)/share
	@cd $(WORK_DIR) && $(PIP) bundle $@ MoPyTools cef WebOb==1.0.7 WebTest==1.4.3 Mako Beaker  python-memcached simplejson Routes SQLAlchemy==0.7.10 WSGIProxy recaptcha-client repoze.lru repoze.who zope.deprecation metlog-py>=0.9.6 metlog-cef docopt

$(STAGING_DIR)/share/syncserver:
	install -m 755 -d $(STAGING_DIR)/share
	cd $(STAGING_DIR)/share && hg clone http://hg.mozilla.org/services/server-full syncserver
	
