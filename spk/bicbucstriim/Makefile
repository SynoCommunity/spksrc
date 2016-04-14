SPK_NAME = bicbucstriim
SPK_VERS = 1.3.6
SPK_REV = 5
SPK_ICON = src/bicbucstriim.png
DSM_UI_DIR = app

DEPENDS  = cross/$(SPK_NAME)

MAINTAINER = Diaoul
DESCRIPTION = BicBucStriim streams books, digital books. It fills a gap in the functionality of current NAS devices, which provide access to your collection of music, videos and photos -- but not books. BicBucStriim covers that area and provides web-based access to your e-book collection.
ADMIN_URL = /bbs/
RELOAD_UI = yes
STARTABLE = no
DISPLAY_NAME = BicBucStriim
CHANGELOG = Update to 1.3.6

HOMEPAGE   = http://rvolz.github.com/BicBucStriim/
LICENSE    = MIT

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_DEP_SERVICES = apache-web
START_DEP_SERVICES = apache-web
INSTUNINST_RESTART_SERVICES = apache-web

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = bicbucstriim_extra_install

# Pure PHP package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: bicbucstriim_extra_install
bicbucstriim_extra_install:
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
