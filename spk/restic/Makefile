SPK_NAME = restic
SPK_VERS = 0.19.1
SPK_REV = 3
SPK_ICON = src/logo.png

DEPENDS = cross/restic

MAINTAINER = fgma
DESCRIPTION = Restic is a fast and secure backup program.
DISPLAY_NAME = restic
STARTABLE = no

CHANGELOG = "Fix the ARMv5 build, which could not start on 88f6281 (illegal instruction)."

HOMEPAGE = https://restic.net/
LICENSE  = BSD 2-Clause License
LICENSE_FILE = $(WORK_DIR)/$(SPK_NAME)/LICENSE

SPK_COMMANDS = bin/restic

include ../../mk/spksrc.spk.mk
