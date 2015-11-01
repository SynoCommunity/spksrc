SPK_NAME = headphones-custom
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 4
SPK_ICON = src/headphones-custom.png
DSM_UI_DIR = app

DEPENDS  =
SPK_DEPENDS = "python>2.7.3-3:git"

MAINTAINER = SynoCommunity
DESCRIPTION = Headphones is an automatic NZB and torrent downloader for music. Mark albums as wanted and have them downloaded as soon as they are available. Different quality settings are possible, including lossless. With Headphones you can also manage your music library automatically: move, tag, rename and index for your DiskStation.
DESCRIPTION_FRE = Headphones permet le téléchargement automatique de musique via NZB ou torrent. Indiquez les albums que vous désirez et ils seront téléchargés dès que possible. Pous pouvez choisir entre différentes qualités, dont le lossless. Avec Headphones, vous pouvez aussi gérer votre bibliothèque musicale automatiquement: déplacement, tag, renommage et indexation pour votre DiskStation.
DESCRIPTION_SPN = Headphones permite descargar automáticamente música mediante NZB o torrent. Puedes marcar albumes y estos serán descargados en cuanto estén disponibles. Es posible utilizar diferentes calidades, incluido lossless \\\(sin pedida\\\). Con Headphones tambien puedes administrar tu libreria: mover, taguear, renombrar e indexar en el DiskStation
ADMIN_PORT = 8182
RELOAD_UI = yes
DISPLAY_NAME = Headphones Custom
CHANGELOG = "1. Allow non-localhost traffic for new installs<br>2. Add to sc-media group"
BETA = 1

HOMEPAGE   = https://github.com/rembo10/headphones
LICENSE    = GPLv3

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

COPY_TARGET = nop
POST_STRIP_TARGET = headphones-custom_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: headphones-custom_extra_install
headphones-custom_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 600 src/config.ini $(STAGING_DIR)/var/config.ini
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
