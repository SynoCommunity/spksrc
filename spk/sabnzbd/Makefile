SPK_NAME = sabnzbd
SPK_VERS = 0.7.13
SPK_REV = 1
SPK_ICON = src/sabnzbd.png
DSM_UI_DIR = app

DEPENDS  = cross/busybox cross/par2cmdline cross/unrar cross/$(SPK_NAME)

SPK_DEPENDS = "python>2.7.3-3"

MAINTAINER = SynoCommunity
DESCRIPTION = SABnzbd makes Usenet as simple and streamlined as possible by automating everything we can. All you have to do is add an .nzb. SABnzbd takes over from there, where it will be automatically downloaded, verified, repaired, extracted and filed away with zero human interaction.
DESCRIPTION_FRE = SABnzbd rend Usenet aussi simple et automatisé que possible. Vous n\\\'avez qu\\\'a ajouter un .nzb, SABnzbd s\\\'occupera du reste sans aucune intervention de votre part : téléchargement, vérification, réparation, extraction et déplacement.
DESCRIPTION_SPN = SABnzbd hace que Usenet sea lo más simple posible, automatizando todo lo que se puede. Todo lo que tienes que hacer es agregar un archivo .nzb. SABnzbd empieza desde ahí. Tus archivos serán automáticamente descargados, verificados, reparados, descomprimidos y archivados.
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

BUSYBOX_CONFIG  = nice
# Add ionice for ARCHs that support it
ifeq ($(findstring $(ARCH),88f6281 qoriq),$(ARCH))
BUSYBOX_CONFIG += ionice
endif
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: sabnzbd_extra_install
sabnzbd_extra_install: $(STAGING_DIR)/share/requirements.pybundle
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/var/scripts
	install -m 755 src/CharTranslator.py $(STAGING_DIR)/var/scripts/CharTranslator.py
	install -m 600 src/config.ini $(STAGING_DIR)/var/config.ini
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 src/app/sabnzbd.cgi.py $(STAGING_DIR)/app/sabnzbd.cgi
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done

$(STAGING_DIR)/share/requirements.pybundle:
	@$(MSG) "Bundling requirements"
	install -m 755 -d $(STAGING_DIR)/share
	@cd $(WORK_DIR) && $(PIP) bundle $@ configobj
