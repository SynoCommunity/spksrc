SPK_NAME = zstd
SPK_VERS = 1.4.0
SPK_REV = 1
SPK_ICON = src/zstd85.png

DEPENDS = cross/zstd

MAINTAINER = Strong Liu
DESCRIPTION = Zstandard is a real-time compression algorithm, providing high compression ratios.
RELOAD_UI = no
DISPLAY_NAME = Zstandard
STARTABLE = no
BETA = 1
CHANGELOG = First build

HOMEPAGE   = http://www.zstd.net
LICENSE    = GPLv2/BSD

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

#POST_STRIP_TARGET = mutt_extra_install

include ../../mk/spksrc.spk.mk

#.PHONY: mutt_extra_install
#mutt_extra_install:
#	install -m 755 src/mutt-utf8 $(STAGING_DIR)/bin/mutt-utf8
#	install -m 644 src/Muttrc.local $(STAGING_DIR)/etc/Muttrc.local
#	echo "source $(INSTALL_PREFIX)/etc/Muttrc.local" >> $(STAGING_DIR)/etc/Muttrc
