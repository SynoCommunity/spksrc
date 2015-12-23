SPK_NAME = letsencrypt
SPK_VERS = 0.1.1
SPK_REV = 1
SPK_ICON = src/letsencrypt.png
DSM_UI_DIR = app
BETA = 1

SPK_DEPENDS = "python>=2.7.11-15:git"

BUILD_DEPENDS = cross/python cross/setuptools cross/pip cross/wheel

DEPENDS = cross/augeas

REQUIRED_DSM = 5.0
#UNSUPPORTED_ARCHS = $(PPC_ARCHES)

MAINTAINER = SynoCommunity
DESCRIPTION = Letsencrypt test

HOMEPAGE   = http://letsencrypt.org
LICENSE    = GPL

RELOAD_UI = yes
STARTABLE = no
DISPLAY_NAME = Lets Encrypt

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS =

INSTALL_PREFIX = /usr/local/$(SPK_NAME)


POST_STRIP_TARGET = augeas_extra_install


include ../../mk/spksrc.spk.mk

.PHONY: deluge_extra_install
augeas_extra_install:
	install -m 755 -d ${STAGING_DIR}/share/patches
	install -m 644 src/python-augeas.req ${STAGING_DIR}/share/
