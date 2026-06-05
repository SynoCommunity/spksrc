SPK_NAME = sabnzbd
SPK_VERS = 5.0.3
SPK_REV = 80
SPK_ICON = src/sabnzbd.png

PYTHON_PACKAGE = python314

DEPENDS = cross/ionice cross/coreutils cross/par2cmdline-turbo cross/7zz cross/sabnzbd
OPTIONAL_DEPENDS = cross/unrar7 cross/unrar

# python311 not supported
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)
# unrar not supported
UNSUPPORTED_ARCHS += $(ARMv5_ARCHS)

# Ensure C++17 compatibility
# sabctools >= 9.0.0 requirement
REQUIRED_MIN_DSM = 7.0
UNSUPPORTED_ARCHS = comcerto2k
REQUIRED_MIN_SRM = 1.3

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

MAINTAINER = Safihre
DESCRIPTION = SABnzbd makes Usenet as simple and streamlined as possible by automating everything we can. All you have to do is add an .nzb. SABnzbd takes over from there, where it will be automatically downloaded, verified, repaired, extracted and filed away with zero human interaction.
DESCRIPTION_FRE = SABnzbd rend Usenet aussi simple et automatisé que possible. Vous n\'avez qu\'a ajouter un .nzb, SABnzbd s\'occupera du reste sans aucune intervention de votre part : téléchargement, vérification, réparation, extraction et déplacement.
DESCRIPTION_SPN = SABnzbd hace que Usenet sea lo más simple posible, automatizando todo lo que se puede. Todo lo que tienes que hacer es agregar un archivo .nzb. SABnzbd empieza desde ahí. Tus archivos serán automáticamente descargados, verificados, reparados, descomprimidos y archivados.
DISPLAY_NAME = SABnzbd
STARTABLE = yes
CHANGELOG = "1. Update to SABnzbd 5.0.3. </br>2. Migrate to Python 3.14."

HOMEPAGE  = https://sabnzbd.org
LICENSE   = GPL

WIZARDS_DIR = src/wizard/

SERVICE_USER = auto
SERVICE_WIZARD_SHARENAME = wizard_shared_folder_name
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8080
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

include ../../mk/spksrc.common.mk
ifeq ($(call version_lt, $(TCVERSION), 7.0),1)
DEPENDS += cross/unrar
else ifeq ($(findstring $(ARCH),comcerto2k),$(ARCH))
DEPENDS += cross/unrar
else
DEPENDS += cross/unrar7
endif

POST_STRIP_TARGET = sabnzbd_extra_install

SPK_COMMANDS = bin/7zz

# [cryptography]
# Version = 45.0.0 requires rustc >= 1.74.0 (qoriq)
# Version = 47.0.0 requires rustc >= 1.83.0
DEPENDS += cross/openssl3
ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
WHEELS += cryptography==46.0.7
else
WHEELS += cryptography==48.0.0
endif

# [orjson]
# Version = 3.11.1 requires rustc >= 1.82 (qoriq)
# Version = 3.11.2 requires rustc >= 1.85
# Version = 3.11.6 requires rustc >= 1.89
ifeq ($(findstring $(ARCH),$(PPC_ARCHS)),$(ARCH))
WHEELS += orjson==3.11.1
else
WHEELS += orjson==3.11.5
endif

include ../../mk/spksrc.spk-meta.mk

# prefer native python tools (pip, maturin, ...) used for orjson
ENV += PATH=$(realpath $(WORK_DIR)/../../../native/$(PYTHON_PACKAGE)/work-native/install/usr/local/bin):$(PATH)

.PHONY: sabnzbd_extra_install
sabnzbd_extra_install:
	install -m 755 -d $(STAGING_DIR)/var/scripts
	install -m 755 src/SabToSyno.py $(STAGING_DIR)/var/scripts/SabToSyno.py
	install -m 600 src/config.ini $(STAGING_DIR)/var/config.ini
