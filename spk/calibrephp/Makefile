SPK_NAME = calibrephp
SPK_VERS = 0.0.2
SPK_REV = 1
SPK_ICON = src/calibrephp.png
DSM_UI_DIR = app

DEPENDS  = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = Calibre OPDS and HTML PHP Server.
DESCRIPTION_FRE = Calibre OPDS et HTML PHP Serveur.
ADMIN_URL = /calibrephp/
RELOAD_UI = yes
DISPLAY_NAME = CalibrePHP
CHANGELOG = ""

HOMEPAGE   = https://github.com/demorfi/calibrephp
LICENSE    = GPL

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_DEP_SERVICES = apache-web
START_DEP_SERVICES = apache-web
INSTUNINST_RESTART_SERVICES = apache-web

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = calibrephp_extra_install

# Pure PHP package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: calibrephp_extra_install
calibrephp_extra_install:
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
			$(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
