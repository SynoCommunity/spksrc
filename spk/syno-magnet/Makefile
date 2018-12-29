SPK_NAME = SynoMagnet
SPK_VERS = 1.0
SPK_REV = 1
SPK_ICON = src/magnet.png

DEPENDS = cross/syno-magnet
SPK_DEPENDS = 

MAINTAINER = neykov
DESCRIPTION = Download Station Magnet Handler. Register Download Station as the application to download magnet links from your browser. No plugins required.
DISPLAY_NAME = Download Station Magnet
CHANGELOG = "Initial Version"

HOMEPAGE   = http://github.com/neykov/syno-magnet
LICENSE    = Apache 2.0

STARTABLE  = no
DSM_UI_DIR = app

PRE_INSTALL_PLIST = nop
COPY_TARGET = syno_magnet_copy

# Pure web package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: syno_magnet_copy

# Icons already included in download
$(ICON_DIR): ;

syno_magnet_copy: 
	install -m 755 -d $(STAGING_DIR)/app
	(cd $(WORK_DIR)/syno-magnet-$(SPK_VERS) && tar cpf - . | \
	  tar xpf - -C $(STAGING_DIR)/app)
