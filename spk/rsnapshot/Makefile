SPK_NAME = rsnapshot
SPK_VERS = 1.4.3
SPK_REV = 3
SPK_ICON = src/rsnapshot.png

DEPENDS = cross/$(SPK_NAME)
SPK_DEPENDS = "Perl"

MAINTAINER = ymartin59
DESCRIPTION = Rsnapshot is a filesystem snapshot utility. It can take incremental snapshots of local and remote filesystems.
STARTABLE = no
DISPLAY_NAME = rsnapshot
CHANGELOG = "Update rsnapshot to v1.4.3 released on 17 Nov 2019"

HOMEPAGE = https://rsnapshot.org
LICENSE  = GPLv2

SERVICE_SETUP = src/service-setup.sh

# Pure Perl package, make sure ARCH is not defined
override ARCH=

SPK_COMMANDS = bin/rsnapshot bin/rsnapshot-diff

include ../../mk/spksrc.spk.mk
