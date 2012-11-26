SPK_NAME = headphones
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 3
SPK_ICON = src/headphones.png
DSM_UI_DIR = app
BETA = 1

DEPENDS  =
SPK_DEPENDS = "python>=2.7.3-2"

MAINTAINER = SynoCommunity
DESCRIPTION = Headphones is an automatic NZB and torrent downloader for music. Mark albums as wanted and have them downloaded as soon as they are available. Different quality settings are possible, including lossless. With Headphones you can also manage your music library automatically: move, tag, rename and index for your DiskStation.
DESCRIPTION_FRE = Headphones permet le téléchargement automatique de musique via NZB ou torrent. Indiquez les albums que vous désirez et ils seront téléchargés dès que possible. Pous pouvez choisir entre différentes qualités, dont le lossless. Avec Headphones, vous pouvez aussi gérer votre bibliothèque musicale automatiquement: déplacement, tag, renommage et indexation pour votre DiskStation.
DESCRIPTION_SPN = Headphones permite descargar automáticamente música mediante NZB o torrent. Puedes marcar albumes y estos serán descargados en cuanto estén disponibles. Es posible utilizar diferentes calidades, incluido lossless \\\(sin pedida\\\). Con Headphones tambien puedes administrar tu libreria: mover, taguear, renombrar e indexar en el DiskStation
ADMIN_PORT = 8181
RELOAD_UI = yes
DISPLAY_NAME = Headphones

HOMEPAGE   = https://github.com/rembo10/headphones
LICENSE    =

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

COPY_TARGET = nop
POST_STRIP_TARGET = headphones_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: headphones_extra_install
headphones_extra_install: $(STAGING_DIR)/share/Headphones
	install -m 755 -d $(STAGING_DIR)/var
	install -m 600 src/config.ini $(STAGING_DIR)/var/config.ini
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 src/app/headphones.cgi.py $(STAGING_DIR)/app/headphones.cgi
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done

$(STAGING_DIR)/share/Headphones:
	install -m 755 -d $(STAGING_DIR)/share
	cd $(STAGING_DIR)/share && git clone https://github.com/rembo10/headphones.git Headphones
	rm -fr $(STAGING_DIR)/share/Headphones/.git $(STAGING_DIR)/share/Headphones/.gitignore
