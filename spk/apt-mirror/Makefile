SPK_NAME = apt-mirror
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 1
SPK_ICON = src/apt-mirror.png

DEPENDS  = cross/gzip cross/wget
SPK_DEPENDS = "Perl>=5.8.6"

MAINTAINER = SynoCommunity
DESCRIPTION = A small tool that provides ability to mirror any parts of Debian and Ubuntu GNU/Linux distributions or any other apt sources which typically provided by open source developers.
DISPLAY_NAME = Apt-Mirror

SUPPORTED_ARCHS = quoriq bromolow cedarview x86 88f6281

WIZARDS_DIR = src/wizard/

HOMEPAGE   = http://apt-mirror.github.io/
LICENSE    = 

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = aptmirror_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: aptmirror_extra_install
aptmirror_extra_install: $(STAGING_DIR)/share/apt-mirror
	install -m 755 -d $(STAGING_DIR)/bin
	install -m 700 $(STAGING_DIR)/share/apt-mirror/apt-mirror $(STAGING_DIR)/bin/apt-mirror
	install -m 755 -d $(STAGING_DIR)/etc
	install -m 600 src/apt-mirror.list $(STAGING_DIR)/etc/mirror.list
	install -m 600 $(STAGING_DIR)/share/apt-mirror/mirror.list $(STAGING_DIR)/etc/mirror.list.sample
	rm -rf $(STAGING_DIR)/share/
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/var/spool
	install -m 755 -d $(STAGING_DIR)/var/spool/apt-mirror
	install -m 755 -d $(STAGING_DIR)/var/spool/apt-mirror/skel
	install -m 755 -d $(STAGING_DIR)/var/spool/apt-mirror/var
	install -m 755 -d $(STAGING_DIR)/var/spool/apt-mirror/mirror

$(STAGING_DIR)/share/apt-mirror:
	install -m 755 -d $(STAGING_DIR)/share
	cd $(STAGING_DIR)/share && git clone https://github.com/apt-mirror/apt-mirror.git apt-mirror
