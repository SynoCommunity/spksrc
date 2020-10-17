SPK_NAME = sabnzbd
SPK_VERS = 3.0.2
SPK_REV = 43
SPK_ICON = src/sabnzbd.png

BUILD_DEPENDS = cross/python3 cross/setuptools cross/pip cross/wheel
DEPENDS = cross/busybox cross/par2cmdline cross/unrar cross/p7zip cross/$(SPK_NAME)
SPK_DEPENDS = "python3>=3.7.7-12"

# To generate full requirements.txt, extend SABnzbd's own
# requirements.txt with the depedencies of cherrypy and cheroot
WHEELS = src/requirements.txt

MAINTAINER = Safihre
DESCRIPTION = SABnzbd makes Usenet as simple and streamlined as possible by automating everything we can. All you have to do is add an .nzb. SABnzbd takes over from there, where it will be automatically downloaded, verified, repaired, extracted and filed away with zero human interaction.
DESCRIPTION_FRE = SABnzbd rend Usenet aussi simple et automatisé que possible. Vous n\'avez qu\'a ajouter un .nzb, SABnzbd s\'occupera du reste sans aucune intervention de votre part : téléchargement, vérification, réparation, extraction et déplacement.
DESCRIPTION_SPN = SABnzbd hace que Usenet sea lo más simple posible, automatizando todo lo que se puede. Todo lo que tienes que hacer es agregar un archivo .nzb. SABnzbd empieza desde ahí. Tus archivos serán automáticamente descargados, verificados, reparados, descomprimidos y archivados.
RELOAD_UI = yes
DISPLAY_NAME = SABnzbd
STARTABLE = yes
CHANGELOG = "Update SABnzbd to 3.0.2. Please note that SABnzbd now runs on Python 3. Make sure your post/pre-processing scripts work with Python 3!"

HOMEPAGE  = http://sabnzbd.org
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

BUSYBOX_CONFIG = nice
# Add ionice for ARCHs that support it
ifeq ($(findstring $(ARCH),88f6281 qoriq),$(ARCH))
BUSYBOX_CONFIG += ionice
endif
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: sabnzbd_extra_install
sabnzbd_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 600 src/config.ini $(STAGING_DIR)/var/config.ini
