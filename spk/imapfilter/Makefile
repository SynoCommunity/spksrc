SPK_NAME = imapfilter
SPK_VERS = 2.5.6
SPK_REV = 1
SPK_ICON = src/imapfilter.png

DEPENDS  = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = IMAPFilter is a mail filtering utility.
STARTABLE = no
DISPLAY_NAME = imapfilter
BETA = 1

HOMEPAGE   = http://github.com/lefcha/imapfilter
LICENSE    = MIT

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

COPY_TARGET = myCopy


include ../../mk/spksrc.spk.mk

.PHONY: myCopy
myCopy: $(PRE_COPY_TARGET)
	cp $(WORK_DIR)/$(SPK_NAME).plist $(WORK_DIR)/PLIST
	(cd $(INSTALL_DIR)/$(INSTALL_PREFIX) && tar cpf - `cat $(INSTALL_PLIST) | cut -d':' -f2`) | \
	  tar xpf - -C $(STAGING_DIR)