SPK_NAME = sabnzbd
SPK_VERS = 3.6.1
SPK_REV = 57
SPK_ICON = src/sabnzbd.png

BUILD_DEPENDS = cross/python310
DEPENDS = cross/busybox cross/par2cmdline cross/unrar cross/p7zip cross/$(SPK_NAME)
SPK_DEPENDS = "python310"

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

MAINTAINER = Safihre
DESCRIPTION = SABnzbd makes Usenet as simple and streamlined as possible by automating everything we can. All you have to do is add an .nzb. SABnzbd takes over from there, where it will be automatically downloaded, verified, repaired, extracted and filed away with zero human interaction.
DESCRIPTION_FRE = SABnzbd rend Usenet aussi simple et automatisé que possible. Vous n\'avez qu\'a ajouter un .nzb, SABnzbd s\'occupera du reste sans aucune intervention de votre part : téléchargement, vérification, réparation, extraction et déplacement.
DESCRIPTION_SPN = SABnzbd hace que Usenet sea lo más simple posible, automatizando todo lo que se puede. Todo lo que tienes que hacer es agregar un archivo .nzb. SABnzbd empieza desde ahí. Tus archivos serán automáticamente descargados, verificados, reparados, descomprimidos y archivados.
DISPLAY_NAME = SABnzbd
STARTABLE = yes
CHANGELOG = "Update SABnzbd to 3.6.1"

HOMEPAGE  = https://sabnzbd.org
LICENSE   = GPL

WIZARDS_DIR = src/wizard/

SERVICE_USER = auto
SERVICE_WIZARD_SHARE = wizard_download_dir
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8080
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

POST_STRIP_TARGET = sabnzbd_extra_install

# Add nice and ionice commands
ENV += BUSYBOX_CONFIG="nice ionice"

SPK_COMMANDS = bin/7za

include ../../mk/spksrc.spk.mk

.PHONY: sabnzbd_extra_install
sabnzbd_extra_install:
	install -m 755 -d $(STAGING_DIR)/var/scripts
	install -m 755 src/SabToSyno.py $(STAGING_DIR)/var/scripts/SabToSyno.py
	install -m 600 src/config.ini $(STAGING_DIR)/var/config.ini
