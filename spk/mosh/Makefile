SPK_NAME = mosh
SPK_VERS = 1.3.2
SPK_REV = 2
SPK_ICON = src/mosh.png

DEPENDS = cross/$(SPK_NAME)

SPK_DEPENDS = "Perl>=5.14"

MAINTAINER = SynoCommunity
DESCRIPTION = mosh, the mobile shell is a remote terminal application that allows roaming, supports intermittent connectivity, and provides intelligent local echo and line editing of user keystrokes. Mosh is a replacement for interactive SSH terminals. It's more robust and responsive, especially over Wi-Fi, cellular, and long-distance links.

DISPLAY_NAME = mosh
STARTABLE = no
CHANGELOG = "1. Add libutempter to show detached sessions.<br/>2. Update openssl to v1.1.1l.<br/>3. Add Perl dependency for advanced customization and scripting."

HOMEPAGE = https://mosh.org
LICENSE  = GPLv3+

SPK_COMMANDS = bin/mosh bin/mosh-client bin/mosh-server

include ../../mk/spksrc.spk.mk
