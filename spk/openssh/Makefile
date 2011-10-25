

SPK_NAME = openssh
SPK_VERS = 5.9p1
SPK_REV = 1
SPK_ICON = src/openssh.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = packages@packages.nas-forum.com
COMMENT    = "Open source version of SSH connectivity tools. Only scp and sftp are installed."
RELOAD_UI = no
DISPLAY_NAME = OpenSSH

HOMEPAGE   = http://www.openssh.com/
LICENSE    = 

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/start-stop-status
ADDITIONAL_SCRIPTS = 

INSTALL_PREFIX = /usr/local/$(SPK_NAME)
PRE_COPY_TARGET = install-openssh
COPY_TARGET = nop
STRIP_TARGET = myStrip

include ../../mk/spksrc.spk.mk

.PHONY: install-openssh
install-openssh:
	install -m 755 -d $(STAGING_DIR)/log
	install -m 755 -d $(STAGING_DIR)/bin
	install -m 755 src/bin/*.pl $(STAGING_DIR)/bin/
	install -m 755 $(INSTALL_DIR)/usr/local/bin/scp $(STAGING_DIR)/bin/
	install -m 755 $(INSTALL_DIR)/usr/local/bin/sftp $(STAGING_DIR)/bin/

.PHONY: myStrip 
myStrip:
	@$(RUN) $(STRIP) $(STAGING_DIR)/bin/scp
	@$(RUN) $(STRIP) $(STAGING_DIR)/bin/sftp