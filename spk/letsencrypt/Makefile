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

MAINTAINER = SynoCommunity
DESCRIPTION = "Let’s Encrypt is a free, automated, and open certificate authority (CA), run for the public’s benefit. Let’s Encrypt is a service provided by the Internet Security Research Group (ISRG)."
DESCRIPTION_GER = "Let’s Encrypt ist eine freie, automatisierte und offene Zertifizierungsstelle (CA). Let’s Encrypt ist ein Service unterstützt durch die Internet Security Research Group (ISRG)."

HOMEPAGE   = http://letsencrypt.org
LICENSE    = GPL

RELOAD_UI = yes
STARTABLE = no
DISPLAY_NAME = Lets Encrypt

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)


POST_STRIP_TARGET = lea_extra_install


include ../../mk/spksrc.spk.mk

.PHONY: lea_extra_install
lea_extra_install:
	install -m 755 -d ${STAGING_DIR}/share
	install -m 644 src/python-augeas.req $(STAGING_DIR)/share/
	install -m 644 src/LeaNoExtIp.mails $(STAGING_DIR)/share/
	install -m 644 src/LeaNoExtAccess.mails $(STAGING_DIR)/share/
	install -m 644 src/LeaCmdFail.mails $(STAGING_DIR)/share/
	install -m 644 src/LeaCmdOk.mails $(STAGING_DIR)/share/
	install -m 755 src/letsencrypt-synology.sh $(STAGING_DIR)/bin/
	
