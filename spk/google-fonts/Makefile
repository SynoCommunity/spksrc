SPK_NAME = google-fonts
SPK_VERS = 20221223
SPK_REV = 1
SPK_ICON = src/google-fonts.png

DEPENDS = cross/google-fonts

MAINTAINER = SynoCommunity
DESCRIPTION = Collection of all available Google Fonts.
DISPLAY_NAME = Google Fonts
STARTABLE = no

HOMEPAGE = http://fonts.google.com/
LICENSE  = Most of the fonts in the collection use the SIL Open Font License, v1.1. Some fonts use the Apache 2 license. The Ubuntu fonts use the Ubuntu Font License v1.0.

# Pure package, make sure ARCH is noarch
override ARCH=noarch

WIZARDS_DIR = src/wizard
SERVICE_SETUP = src/service-setup.sh

SERVICE_USER = auto
SERVICE_WIZARD_SHARE = wizard_shared_folder
# use data share worker for DSM 6 too (default is for DSM 7 only)
USE_DATA_SHARE_WORKER = yes

include ../../mk/spksrc.spk.mk
