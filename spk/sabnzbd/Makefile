SPK_NAME = sabnzbd
SPK_VERS = 1.0.3
SPK_REV = 16
SPK_ICON = src/sabnzbd.png
DSM_UI_DIR = app

DEPENDS  = cross/busybox cross/par2cmdline cross/unrar cross/unzip cross/$(SPK_NAME)
SPK_DEPENDS = "python>=2.7.6-8"

MAINTAINER = Diaoul
DESCRIPTION = SABnzbd makes Usenet as simple and streamlined as possible by automating everything we can. All you have to do is add an .nzb. SABnzbd takes over from there, where it will be automatically downloaded, verified, repaired, extracted and filed away with zero human interaction.
DESCRIPTION_FRE = SABnzbd rend Usenet aussi simple et automatisé que possible. Vous n\\\'avez qu\\\'a ajouter un .nzb, SABnzbd s\\\'occupera du reste sans aucune intervention de votre part : téléchargement, vérification, réparation, extraction et déplacement.
DESCRIPTION_SPN = SABnzbd hace que Usenet sea lo más simple posible, automatizando todo lo que se puede. Todo lo que tienes que hacer es agregar un archivo .nzb. SABnzbd empieza desde ahí. Tus archivos serán automáticamente descargados, verificados, reparados, descomprimidos y archivados.
ADMIN_PORT = 8080
RELOAD_UI = yes
DISPLAY_NAME = SABnzbd
<<<<<<< HEAD
CHANGELOG = "1. Update to 1.0.0<br>2. Warning: When you upgrade an existing 0.7.x installation, release 1.0.0 will NOT be able to finish the queue. It's best to empty your queue first using 0.7.x. Alternatively, you can install 1.0.0 and then use queue repair on the Status page. Some information (like the order of the queue) will be lost.

1.0.1
Prevent creating orphan items in "incomplete" when deleting downloading jobs.
Forced item with missing articles caused overflow into paused jobs
Do QuickCheck even on files that would be removed by the Cleanup-list (problematic for RAR files).
Fix "Download all par2 files" behaviour
Treat ambiguous numeric values as number of minutes for custom pause time.
Accept MIME records that have only LF line endings (error in some third-party utilities)
Fix PushOver support.
Fix breaking Glitter bug with large script_log
Fix issues with deleting jobs via the API
Fix issue where Sonarr could not read using the History-API
Increase default cache to 450M
The pre-queue script can now return an accept value of 2, meaning immediate failure. (Useful for Sonarr.)
Add start script for portable Windows installations

1.0.2
Fix hangups at 100% when QuickCheck is off and "all-pars" is on
Fix handling of "too many connections" for some Usenet servers

1.0.3
Fix jobs hanging at 99% or 100%
Support X-DNZB-PASSWORD header for indexers that use this
Prevent fatal "too many connections" issue
Show checksum errors reported by unrar
Windows: fix coupling of NZB files to SABnzbd, when the name contains non-US-ASCII characters
"
=======
CHANGELOG = "1. Updated to 1.0.3<br>2. Add unzip<br>3. Warning: When you upgrade an existing 0.7.x installation, release 1.x will NOT be able to finish the queue. It's best to empty your queue first using 0.7.x. Alternatively, you can install 1.x and then use queue repair on the Status page. Some information (like the order of the queue) will be lost."
>>>>>>> f2815d794ccae383c06251b72830759f63662e52

HOMEPAGE   = http://sabnzbd.org
LICENSE    = GPL

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
FWPORTS          = src/${SPK_NAME}.sc

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
sabnzbd_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/var/scripts
	install -m 755 src/CharTranslator.py $(STAGING_DIR)/var/scripts/CharTranslator.py
	install -m 600 src/config.ini $(STAGING_DIR)/var/config.ini
	install -m 755 -d $(STAGING_DIR)/app
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 755 -d $(STAGING_DIR)/app/images
	for size in 16 24 32 48 72; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
