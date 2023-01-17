SPK_NAME = rsnapshot
SPK_VERS = 1.4.2
SPK_REV = 2
SPK_ICON = src/rdiff-backup.png

DEPENDS = cross/$(SPK_NAME)
SPK_DEPENDS = "Perl"

MAINTAINER = ymartin59
DESCRIPTION = Rsnapshot is a filesystem snapshot utility. It can take incremental snapshots of local and remote filesystems.
STARTABLE = no
DISPLAY_NAME = rsnapshot
CHANGELOG = "Initial release"

HOMEPAGE = http://rsnapshot.org/
LICENSE  = GPLv2

SERVICE_SETUP = src/service-setup.sh

# Pure Perl package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk
