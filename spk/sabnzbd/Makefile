SPK_NAME = sabnzbd
SPK_VERS = 0.6.15
SPK_REV = 1
SPK_ICON = src/sabnzbd.png
DSM_UI_DIR = app

DEPENDS  = cross/busybox cross/par2cmdline cross/sabnzbd

SPK_DEPENDS = "python>=2.7.2-1"

MAINTAINER = SynoCommunity
DESCRIPTION = SABnzbd makes Usenet as simple and streamlined as possible by automating everything we can. All you have to do is add an .nzb. SABnzbd takes over from there, where it will be automatically downloaded, verified, repaired, extracted and filed away with zero human interaction.
DESCRIPTION_FRE = SABnzbd rend Usenet aussi simple et automatisé que possible. Vous n\\\'avez qu\\\'a ajouter un .nzb, SABnzbd s\\\'occupera du reste sans aucune intervention de votre part : téléchargement, vérification, réparation, extraction et déplacement.
ADMIN_PORT = 8080
RELOAD_UI = yes
DISPLAY_NAME = SABnzbd

HOMEPAGE   = http://sabnzbd.org/
LICENSE    = GPL

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = sabnzbd_extra_install

include ../../mk/spksrc.spk.mk


ifeq ($(findstring $(ARCH),88f5281 bromolow powerpc ppc824x ppc853x ppc854x x86),$(ARCH))
# No support for building ionice
ENV += BUSYBOX_CONFIG=src/nice_defconfig
else
ENV += BUSYBOX_CONFIG=src/niceionice_defconfig
endif

.PHONY: sabnzbd_extra_install
sabnzbd_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 600 src/config.ini $(STAGING_DIR)/var/config.ini
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 src/app/sabnzbd.cgi.pl $(STAGING_DIR)/app/sabnzbd.cgi
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done

