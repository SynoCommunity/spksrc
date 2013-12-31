SPK_NAME = syncserver
SPK_VERS = 1.0
SPK_REV = 1
SPK_ICON = src/syncserver.png
DSM_UI_DIR = app

DEPENDS  = cross/busybox
SPK_DEPENDS = "python>2.7.3-3"

MAINTAINER = SynoCommunity
DESCRIPTION = Python implementation of the Mozilla Sync Server. You can use Mozilla Sync Server to synchronize your bookmarks, passwords, settings, history, add-ons and tabs with Firefox on other computers. Set up Firefox Sync on your main computer by creating a new account on a custom server, then add your other computers. The service runs on port 8084.
DISPLAY_NAME = Mozilla Sync Server
HOMEPAGE   = https://wiki.mozilla.org/Services/Sync/Server
LICENSE    = MPL/GPL/LGPL

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = syncserver_extra_install

BUSYBOX_CONFIG  = nice
# Add ionice for ARCHs that support it
ifeq ($(findstring $(ARCH),88f6281 qoriq),$(ARCH))
BUSYBOX_CONFIG += ionice
endif
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: syncserver_extra_install
syncserver_extra_install: $(STAGING_DIR)/share/requirements.pybundle $(STAGING_DIR)/share/syncserver
	install -m 755 -d $(STAGING_DIR)/app
	install -m 755 -d $(STAGING_DIR)/app/help
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/var/log
	install -m 644 src/app/helptoc.conf $(STAGING_DIR)/app/helptoc.conf
	install -m 644 src/app/index.conf $(STAGING_DIR)/app/index.conf
	install -m 755 src/syncserver.conf $(STAGING_DIR)/var/
	install -m 755 src/syncserver.ini $(STAGING_DIR)/var/
	for language in enu; do \
		install -m 755 -d $(STAGING_DIR)/app/texts/$${language}; \
		install -m 755 -d $(STAGING_DIR)/app/help/$${language}; \
		install -m 644 src/app/texts/$${language}/strings $(STAGING_DIR)/app/texts/$${language}/strings; \
		install -m 644 src/app/help/$${language}/*.html $(STAGING_DIR)/app/help/$${language}/; \
	done
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
			$(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done

$(STAGING_DIR)/share/requirements.pybundle:
	@$(MSG) "Bundling requirements"
	install -m 755 -d $(STAGING_DIR)/share
	@cd $(WORK_DIR) && $(PIP) bundle $@ SQLAlchemy==0.7.10 Paste PasteScript PasteDeploy WebOb==1.0.7 Routes simplejson cef WSGIProxy metlog-py>=0.9.6 metlog-cef Mako recaptcha-client repoze.lru docopt MarkupSafe
	
$(STAGING_DIR)/share/syncserver:
	install -m 755 -d $(STAGING_DIR)/share
	cd $(STAGING_DIR)/share && hg clone -r "549" http://hg.mozilla.org/services/server-full syncserver
	install -m 755 -d $(STAGING_DIR)/share/syncserver/deps
	cd $(STAGING_DIR)/share/syncserver/deps && hg clone -r "1069" http://hg.mozilla.org/services/server-core server-core
	cd $(STAGING_DIR)/share/syncserver/deps && hg clone -r "552" http://hg.mozilla.org/services/server-reg server-reg
	cd $(STAGING_DIR)/share/syncserver/deps && hg clone -r "813" http://hg.mozilla.org/services/server-storage server-storage
