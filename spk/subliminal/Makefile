SPK_NAME = subliminal
SPK_VERS = 2.6.0
SPK_REV = 13
SPK_ICON = src/subliminal.png

PYTHON_PACKAGE = python312

WHEELS = src/requirements-crossenv.txt src/requirements-pure.txt

# [pymediainfo] is a hard dependency of knowit and wraps libmediainfo via ctypes
DEPENDS = cross/libmediainfo

MAINTAINER = SynoCommunity
DESCRIPTION = Subliminal searches and downloads the best matching subtitles for your movies and TV shows. This package provides the subliminal command line tool.
DESCRIPTION_FRE = Subliminal recherche et télécharge les sous-titres correspondant le mieux à vos films et séries. Ce paquet fournit l\'outil en ligne de commande subliminal.
DISPLAY_NAME = Subliminal
STARTABLE = no
CHANGELOG = "1. Update to Subliminal 2.6.0, a full rewrite of the upstream project.<br/>2. The package is now a Python 3 command line tool; the former DSM user interface is gone."

HOMEPAGE = https://github.com/Diaoul/subliminal
LICENSE  = MIT

SERVICE_SETUP = src/service-setup.sh

SPK_COMMANDS = env/bin/subliminal

include ../../mk/spksrc.spk-meta.mk
