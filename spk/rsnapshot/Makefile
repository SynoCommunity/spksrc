SPK_NAME = rsnapshot
SPK_VERS = 1.4.4
SPK_REV = 4
SPK_ICON = src/rsnapshot.png

DEPENDS = cross/rsnapshot
SPK_DEPENDS = "Perl"

MAINTAINER = ymartin59
DESCRIPTION = rsnapshot is a filesystem snapshot utility based on rsync. rsnapshot makes it easy to make periodic snapshots of local machines, and remote machines over ssh. The code makes extensive use of hard links whenever possible, to greatly reduce the disk space required.
STARTABLE = no
DISPLAY_NAME = rsnapshot
CHANGELOG = "Update rsnapshot to v1.4.4 released on 12 Jun 2021."

HOMEPAGE = https://rsnapshot.org
LICENSE  = GPLv2

SERVICE_SETUP = src/service-setup.sh

# Pure Perl package, make sure ARCH is noarch
override ARCH=noarch

SPK_COMMANDS = bin/rsnapshot bin/rsnapshot-diff

include ../../mk/spksrc.spk.mk
