SPK_NAME = optware-ng
SPK_VERS = 6.8
SPK_REV = 1
SPK_ICON = src/optware.png

MAINTAINER = SynoCommunity
DESCRIPTION = /opt
# DESCRIPTION_FRE = 
RELOAD_UI = no
DISPLAY_NAME = optware-ng

HOMEPAGE   = https://github.com/Optware/Optware-ng
LICENSE    = GPLv2

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

# Pure multiarch package, make sure ARCH is not defined
override ARCH=
override TCVERSION=

include ../../mk/spksrc.spk.mk

pre_copy_target:
	@mkdir -p $(STAGING_INSTALL_PREFIX)
	@echo : > $(STAGING_INSTALL_PREFIX)/nop
