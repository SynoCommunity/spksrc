SPK_NAME = emby
SPK_VERS = 3.0.5597.1
SPK_REV = 3
SPK_ICON = src/emby.png
DSM_UI_DIR = app

BETA = 1

#REQUIRED_DSM = 5.0

DEPENDS = cross/emby cross/busybox cross/sqlite

SPK_DEPENDS = "mono>3.6:imagemagick=6.9.0-1:mediainfo=0.7.72-1:ffmpeg=2.6-3"

MAINTAINER = SynoCommunity

DESCRIPTION = Emby streams everything Your personal videos, music, photos, and live television in the palm of your hand.
ADMIN_PORT = 8096
RELOAD_UI = yes
DISPLAY_NAME = Emby
CHANGELOG = "1. Update emby to 3.0.5597.1<br>2. depend on ffmpeg >= 2.6-3"

HOMEPAGE = http://emby.media/
LICENSE  =

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/$(SPK_NAME).sc

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

# Notify of unsupported architectures
ifneq ($(findstring $(ARCH),bromolow cedarview evansport x86 armada370 88f6281 armadaxp comcerto2k avoton x64 armada375 alpine),$(ARCH))
$(error Sorry $(ARCH) is not a supported architecture)
endif

POST_STRIP_TARGET = emby_extra_install

BUSYBOX_CONFIG = usrmng daemon
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: emby_extra_install
emby_extra_install:
	install -m 755 -d $(STAGING_DIR)/
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/app
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72 ; \
	do \
	    convert $(SPK_ICON) -thumbnail $${size}x$${size} \
	            $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
