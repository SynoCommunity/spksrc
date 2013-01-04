SPK_NAME = lirc
SPK_VERS = 0.9.0
SPK_REV = 1
SPK_ICON = src/lirc.png

# Abort for ARCHs that won't compile LIRC cleanly
ifeq ($(findstring $(ARCH),powerpc 88f5281),$(ARCH))
PRE_DEPEND_TARGET = lirc_abort
ABORT_MSG = "Sorry, this package does not support the $(ARCH) architecture."
endif

# Use older LIRC build for ARCHs with kernel < 2.6.36
ifneq ($(findstring $(ARCH),x86 bromolow cedarview),$(ARCH))
SPK_VERS = 0.8.7
endif

DEPENDS = cross/$(SPK_NAME)-$(SPK_VERS)

MAINTAINER = SynoCommunity
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

.PHONY: lirc_extra_install lirc_abort
lirc_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/var/log
	install -m 755 -d $(STAGING_DIR)/etc/lirc/scripts
	install -m 755 src/send_ir.sh $(STAGING_DIR)/etc/lirc/scripts/send_ir.sh
	install -m 644 src/lircrc $(STAGING_DIR)/etc/lirc/lircrc
	install -m 644 src/lircd.conf $(STAGING_DIR)/etc/lirc/lircd.conf
	cp -R $(WORK_DIR)/$(SPK_NAME)-$(SPK_VERS)/remotes $(STAGING_DIR)/
	install src/install_uifile.tmpl $(WIZARDS_DIR)/install_uifile
	@for DRIVER in `ls $(STAGING_DIR)/lib/modules | grep -v lirc_dev.ko | awk -F'_' '{print $$2}' | awk -F'.' '{print $$1}'`; do \
	    sed -i "s/@keys@/$${DRIVER} @keys@/" $(WIZARDS_DIR)/install_uifile; \
	done;
	@sed -i 's/@keys@//' $(WIZARDS_DIR)/install_uifile
lirc_abort:
	@$(MSG) ABORTING: $(ABORT_MSG)
	@exit 1
