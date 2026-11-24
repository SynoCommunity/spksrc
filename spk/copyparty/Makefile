SPK_NAME = copyparty
SPK_VERS = 1.20.28
SPK_REV = 2
SPK_ICON = src/copyparty.png

PYTHON_PACKAGE = python314

WHEELS = src/requirements-pure.txt src/requirements-crossenv.txt
WHEELS_OFFLINE = 1

MAINTAINER = SynoCommunity
DESCRIPTION = Portable file server with resumable uploads, file sharing, and WebDAV.
DISPLAY_NAME = copyparty
CHANGELOG = "Update copyparty to v1.20.28."
HOMEPAGE = https://github.com/9001/copyparty
LICENSE = MIT

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh

SERVICE_PORT = 3923
SERVICE_PORT_TITLE = $(DISPLAY_NAME) (HTTP)
ADMIN_PORT = $(SERVICE_PORT)

USE_ALTERNATE_TMPDIR = 1

WIZARDS_DIR = src/wizard
SERVICE_WIZARD_SHARENAME = wizard_media_share

POST_SERVICE_TARGET = copyparty_extra_install

# [Pillow]
DEPENDS += python/pillow

include ../../mk/spksrc.spk-meta.mk

.PHONY: copyparty_extra_install
copyparty_extra_install:
	install -m 755 -d $(STAGING_DIR)/share/copyparty
	install -m 644 src/copyparty.conf $(STAGING_DIR)/share/copyparty/copyparty.conf
	@$(MSG) Substituting PYTHON_PACKAGE in service-setup
	@sed -i 's|@@PYTHON_PACKAGE@@|$(PYTHON_PACKAGE)|g' $(WORK_DIR)/scripts/service-setup
