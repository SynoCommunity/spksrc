SPK_NAME = HandBrakeCLI
SPK_VERS = 1.3.1
SPK_REV = 12	
SPK_ICON = src/HandBrake.png
CHANGELOG = "1. HandBrake CLI (Command Line Interface) v1.3.1 with Intel QuickSync Media Driver 20.1.1 <br/>"

DEPENDS = cross/HandBrakeCLI

MAINTAINER = jvega1976
DESCRIPTION = HandBrake is an open-source video transcoder available for Linux, Mac, and Windows.
DISPLAY_NAME = HandBrake
STARTABLE = no

HOMEPAGE = https://handbrake.fr
LICENSE  = GPLv3

PRE_COPY_TARGET = myPreCopy

include ../../mk/spksrc.spk.mk


.PHONY: myPreCopy
myPreCopy:
	cp PLIST $(WORK_DIR)/PLIST


