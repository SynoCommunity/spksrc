SPK_NAME = mosh
SPK_VERS = 1.3.2
SPK_REV = 1

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = fredrike
DESCRIPTION = Mosh is a remote terminal application that supports intermittent connectivity, allows roaming, and provides speculative local echo and line editing of user keystrokes.
RELOAD_UI = no
DISPLAY_NAME = Mosh
STARTABLE = no

HOMEPAGE = https://mosh.org
LICENSE  = GPLv3+

REQUIRED_DSM = 5.0
SPK_DEPENDS	= "Perl>=5.14"

SERVICE_SETUP = src/service-setup.sh

include ../../mk/spksrc.spk.mk
