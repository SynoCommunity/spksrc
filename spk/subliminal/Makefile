SPK_NAME = subliminal
SPK_VERS = 2.8.0
SPK_REV = 15
SPK_ICON = src/subliminal.png

PYTHON_PACKAGE = python314

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

# [pymediainfo] is a hard dependency of knowit and wraps libmediainfo via ctypes
DEPENDS = cross/libmediainfo

MAINTAINER = SynoCommunity
DESCRIPTION = Subliminal searches and downloads the best matching subtitles for your movies and TV shows. This package provides the subliminal command line tool.
DESCRIPTION_FRE = Subliminal recherche et télécharge les sous-titres correspondant le mieux à vos films et séries. Ce paquet fournit l\'outil en ligne de commande subliminal.
DISPLAY_NAME = Subliminal
STARTABLE = no
CHANGELOG = "1. Update to Subliminal 2.8.0."

HOMEPAGE = https://github.com/Diaoul/subliminal
LICENSE  = MIT

SERVICE_SETUP = src/service-setup.sh
POST_SERVICE_TARGET = subliminal_extra_install

SPK_COMMANDS = env/bin/subliminal

include ../../mk/spksrc.spk-meta.mk

.PHONY: subliminal_extra_install
subliminal_extra_install:
	@$(MSG) Substituting PYTHON_PACKAGE in service-setup
	@sed -i 's|@@PYTHON_PACKAGE@@|$(PYTHON_PACKAGE)|g' $(WORK_DIR)/scripts/service-setup
