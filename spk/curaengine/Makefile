SPK_NAME = curaengine
SPK_VERS = 2.1.3
SPK_REV = 2
SPK_ICON = src/curaengine.png

DEPENDS = cross/$(SPK_NAME)

# c++11 compiler required
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS) $(ARMv5_ARCHS)

MAINTAINER = SynoCommunity
DESCRIPTION  = CuraEngine is a powerful, fast and robust engine for processing 3D models into 3D printing instruction for Ultimaker and other GCode based 3D printers.
DISPLAY_NAME = CuraEngine

HOMEPAGE = https://ultimaker.com/software/ultimaker-cura
LICENSE  = AGPLv3

STARTABLE = no
SPK_COMMANDS = bin/CuraEngine

include ../../mk/spksrc.spk.mk
