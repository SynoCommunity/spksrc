SPK_NAME = hastation
SPK_VERS = 0.1
SPK_REV = 1
SPK_ICON = src/python.png

DEPENDS  = cross/python cross/pip cross/pyalsa cross/pyaudio
DEPENDS += cross/espeak cross/speechd cross/julius cross/dobby

MAINTAINER = SynoCommunity
DESCRIPTION = Home Automation Station
ADMIN_PORT =
RELOAD_UI = yes
DISPLAY_NAME = H.A. Station

HOMEPAGE =
LICENSE  =

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       =
ADDITIONAL_SCRIPTS =

INSTALL_PREFIX = /usr/local/$(SPK_NAME)
PYTHON_LIB_DIR = lib/python2.7
PLIST_TRANSFORM = sed "s%@PYTHON_SITE_PACKAGES@%$(PYTHON_LIB_DIR)/site-packages%"

POST_STRIP_TARGET = dobby_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: dobby_extra_install
dobby_extra_install: $(STAGING_DIR)/share/Dobby/requirements.pybundle
	install -m 755 -d $(STAGING_DIR)/var

$(STAGING_DIR)/share/Dobby/requirements.pybundle:
	@$(MSG) "Bundling requirements for Dobby"
	sed -i -e "/^pyaudio/d" $(STAGING_DIR)/share/Dobby/requirements.txt
	install -m 755 -d $(STAGING_DIR)/share
	@cd $(WORK_DIR) && pip bundle --use-mirrors $@ -r $(STAGING_DIR)/share/Dobby/requirements.txt

