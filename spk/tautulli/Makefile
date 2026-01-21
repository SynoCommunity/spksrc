SPK_NAME = tautulli
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 1
SPK_ICON = src/tautulli.png

SPK_DEPENDS = "python>2.7.3-3:git"

MAINTAINER = maxrogers
DESCRIPTION = Tautulli is a 3rd party application that you can run alongside your Plex Media Server to monitor activity and track various statistics. Most importantly, these statistics include what has been watched, who watched it, when and where they watched it, and how it was watched. The only thing missing is "why they watched it", but who am I to question your 42 plays of Frozen. All statistics are presented in a nice and clean interface with many tables and graphs, which makes it easy to brag about your server to everyone else.
DESCRIPTION_FRE = Tautulli est une application tierce que vous pouvez exécuter avec votre Plex Media Server pour surveiller l'activité et suivre diverses statistiques. Plus important encore, ces statistiques incluent ce qui a été regardé, qui l'a regardé, quand et où il l'a regardé et comment il a été regardé. La seule chose qui manque est "pourquoi ils l'ont regardé", mais à qui dois-je remettre en question vos 42 pièces de Frozen. Toutes les statistiques sont présentées dans une interface claire et conviviale avec de nombreux tableaux et graphiques, ce qui permet de se vanter facilement de votre serveur.
RELOAD_UI = yes
STARTABLE = yes
DISPLAY_NAME = Tautulli
CHANGELOG = "First Tautulli package"

HOMEPAGE   = http://tautulli.com
LICENSE    = GNU GPL 3.0
HELPURL    =

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8183
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

WIZARDS_DIR = src/wizard/

COPY_TARGET = nop
POST_STRIP_TARGET = tautulli-custom_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: tautulli-custom_extra_install
tautulli-custom_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 600 src/config.ini $(STAGING_DIR)/var/config.ini
