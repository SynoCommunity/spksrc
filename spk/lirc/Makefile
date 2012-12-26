SPK_NAME = lirc
SPK_VERS = 0.8.7
SPK_REV = 1
SPK_ICON = src/lirc.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = Dave Russell
DESCRIPTION = LIRC daemon decodes infrared signals and provides them on a Unix domain socket
RELOAD_UI = no
DISPLAY_NAME = LIRC

HOMEPAGE = http://www.lirc.org/
LICENSE  =

WIZARDS_DIR = src/wizard

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS =

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = lirc_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: lirc_extra_install
lirc_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/var/log
	install -m 755 -d $(STAGING_DIR)/etc/lirc/scripts
	install -m 755 src/send_ir.sh $(STAGING_DIR)/etc/lirc/scripts/send_ir.sh
	install -m 644 src/lircrc $(STAGING_DIR)/etc/lirc/lircrc
	install -m 644 src/lircd.conf $(STAGING_DIR)/etc/lirc/lircd.conf
	install $(WIZARDS_DIR)/install_uifile.tmpl $(WIZARDS_DIR)/install_uifile
	cp -R $(WORK_DIR)/$(SPK_NAME)-$(SPK_VERS)/remotes $(STAGING_DIR)/etc/lirc/
	for DRIVER in `ls $(STAGING_DIR)/lib/modules | grep -v lirc_dev.ko | awk -F'_' '{print $$2}' | awk -F'.' '{print $$1}'`; do \
	    sed -i "s/@keys@/\"key\": \"lirc_driver_$${DRIVER}\",\n \"desc\": \"$${DRIVER}\"\n }, {\n@keys@/" $(WIZARDS_DIR)/install_uifile; \
	done; \
	sed -i 's/@keys@//' $(WIZARDS_DIR)/install_uifile
