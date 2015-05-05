SPK_NAME = AutoSub-BootstrapBill
SPK_VERS = 0.6.2
SPK_REV = 6
SPK_ICON = src/autosub-bootstrapbill.png
DSM_UI_DIR = app

DEPENDS  =
SPK_DEPENDS = "python>2.7.3-3"

MAINTAINER = Donny87
DISTRIBUTOR = Matr1x and Martijn de Vries
DESCRIPTION = Automated SubtitleSeeker and Addic7ed download script for TV-Series.
DESCRIPTION_NLD = Geautomatiseerde SubtitleSeeker en Addic7ed download script voor TV-Series.
ADMIN_PORT =
RELOAD_UI = yes
DISPLAY_NAME = Auto-Sub Bootstrap Bill

HOMEPAGE   = https://github.com/Donny87/autosub-bootstrapbill
LICENSE    =

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/autosub-bootstrapbill.sc

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

COPY_TARGET = nop
POST_STRIP_TARGET = autosub-bootstrapbill_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: autosub-bootstrapbill_extra_install
autosub-bootstrapbill_extra_install: $(STAGING_DIR)/share/autosub-bootstrapbill
	install -m 600 src/config.properties $(STAGING_DIR)/share/autosub-bootstrapbill/config.properties
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 src/app/autosub-bootstrapbill.cgi $(STAGING_DIR)/app/autosub-bootstrapbill.cgi
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
	mv $(STAGING_DIR)/share/autosub-bootstrapbill/* $(STAGING_DIR)
	rm -R $(STAGING_DIR)/share

$(STAGING_DIR)/share/autosub-bootstrapbill:
	install -m 755 -d $(STAGING_DIR)/share
	cd $(STAGING_DIR)/share && git clone https://github.com/Donny87/autosub-bootstrapbill.git
	rm -fr $(STAGING_DIR)/share/autosub-bootstrapbill/.git $(STAGING_DIR)/share/autosub-bootstrapbill/.gitignore