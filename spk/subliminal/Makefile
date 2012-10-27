SPK_NAME = subliminal
SPK_VERS = 0.6.2
SPK_REV = 7
SPK_ICON = src/subliminal.png
DSM_UI_DIR = app
CHANGELOG =

DEPENDS =
SPK_DEPENDS = "python>=2.7.3-1"

MAINTAINER = SynoCommunity
DESCRIPTION = Subliminal allows you automatically download best-matching subtitles for your movies and tv shows on your DiskStation. This package is named after Subliminal, the Python library used to search and download subtitles.
DESCRIPTION_FRE = Subliminal vous permet de télécharger automatiquement les meilleurs sous-titres pour vos films et séries sur votre DiskStation. Ce paquet est nommé d\\\'après Subliminal, la librairie Python utilisée pour rechercher et télécharger les sous-titres.
RELOAD_UI = yes
DISPLAY_NAME = Subliminal

HOMEPAGE   = https://github.com/Diaoul/subliminal
LICENSE    = LGPL

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

COPY_TARGET = nop
POST_STRIP_TARGET = subliminal_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: subliminal_extra_install
subliminal_extra_install: $(STAGING_DIR)/share/requirements.pybundle
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/app
	install -m 755 -d $(STAGING_DIR)/cache
	install -m 644 src/app/config $(STAGING_DIR)/app/config
	install -m 644 src/app/index.conf $(STAGING_DIR)/app/index.conf
	install -m 644 src/app/helptoc.conf $(STAGING_DIR)/app/helptoc.conf
	install -m 644 src/app/style.css $(STAGING_DIR)/app/style.css
	install -m 644 src/app/subliminal.js $(STAGING_DIR)/app/subliminal.js
	install -m 755 src/app/setup.py $(STAGING_DIR)/app/setup.py
	install -m 755 src/app/scheduler.py $(STAGING_DIR)/app/scheduler.py
	install -m 755 src/app/scanner.py $(STAGING_DIR)/app/scanner.py
	install -m 755 src/app/subliminal.cgi.py $(STAGING_DIR)/app/subliminal.cgi
	install -m 755 -d $(STAGING_DIR)/app/application
	install -m 644 src/app/application/* $(STAGING_DIR)/app/application/
	install -m 755 -d $(STAGING_DIR)/app/texts
	install -m 755 -d $(STAGING_DIR)/app/help
	for language in enu fre; do \
		install -m 755 -d $(STAGING_DIR)/app/texts/$${language}; \
		install -m 755 -d $(STAGING_DIR)/app/help/$${language}; \
		install -m 644 src/app/texts/$${language}/strings $(STAGING_DIR)/app/texts/$${language}/strings; \
		install -m 644 src/app/help/$${language}/*.html $(STAGING_DIR)/app/help/$${language}/; \
	done
	install -m 755 -d $(STAGING_DIR)/app/images
	install -m 644 src/app/images/*.png $(STAGING_DIR)/app/images/
	install -m 755 -d $(STAGING_DIR)/app/images/superboxselect
	install -m 644 src/app/images/superboxselect/*.png $(STAGING_DIR)/app/images/superboxselect/
	for size in 16 24 32 48; do \
		convert $(SPK_ICON) -thumbnail $${size}x$${size} \
		        $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done

$(STAGING_DIR)/share/requirements.pybundle:
	@$(MSG) "Bundling requirements"
	install -m 755 -d $(STAGING_DIR)/share
	@cd $(WORK_DIR) && $(PIP) bundle $@ subliminal==$(SPK_VERS) pyextdirect==0.3.1 configobj flask
