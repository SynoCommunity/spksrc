SPK_NAME = rar2fs
SPK_VERS = 1.0
SPK_REV = 1
SPK_ICON = src/rar2fs.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = github.com/rohtang
DESCRIPTION = rar2fs is a FUSE based file system that can mount a source RAR archive/volume or a directory containing any number of RAR archives and read the contents as regular files on-the-fly.
DISPLAY_NAME = rar2fs
STARTABLE = no
CHANGELOG = "Initial version"
BETA = 1

HOMEPAGE   = https://github.com/hasse69/rar2fshttps://github.com/hasse69/rar2fs
LICENSE    = GPLv3, LGPLv2.1 (libfuse.so), UnRAR License (unrar)

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

include ../../mk/spksrc.spk.mk

