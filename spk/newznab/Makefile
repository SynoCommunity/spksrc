SPK_NAME = newznab
SPK_VERS = 0.2.3
SPK_REV = 6
SPK_ICON = src/newznab.png

DEPENDS  = cross/busybox cross/$(SPK_NAME)
SPK_DEPENDS = "PEAR"

MAINTAINER = Diaoul
DESCRIPTION = Newznab is a usenet indexing application, that makes building a usenet community easy.
DESCRIPTION_FRE = Newznab est une application d\\\'indexation des newsgroups rendant facile la création d\\\'une communauté usenet.
ADMIN_URL = /newznab/www/
RELOAD_UI = yes
DISPLAY_NAME = Newznab
BETA = 1
CHANGELOG = "1. DSM 5.0 compatibility"

HOMEPAGE   = http://www.newznab.com/
LICENSE    = GPLv3

WIZARDS_DIR = src/wizard/
CONF_DIR = src/conf/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_DEP_SERVICES = apache-web mysql
START_DEP_SERVICES = apache-web mysql

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = newznab_extra_install

BUSYBOX_CONFIG = daemon nice
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: newznab_extra_install
newznab_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 src/newznab.sh $(STAGING_DIR)/bin/
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
