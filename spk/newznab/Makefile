SPK_NAME = newznab
SPK_VERS = 0.2.3
SPK_REV = 1
SPK_ICON = src/newznab.png

DEPENDS  = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = Newznab is a usenet indexing application, that makes building a usenet community easy.
DESCRIPTION_FRE = Newznab est une application d\\\'indexation des newsgroups rendant facile la création d\\\'une communauté usenet.
ADMIN_URL = /newznab
RELOAD_UI = yes
DISPLAY_NAME = Newznab
BETA = 1

HOMEPAGE   = http://www.newznab.com/
LICENSE    = GPLv3

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = newznab_extra_install

# Pure PHP
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: newznab_extra_install
newznab_extra_install:
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
