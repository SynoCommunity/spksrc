SPK_NAME = dar
SPK_VERS = 2.5.22
SPK_REV = 3
SPK_ICON = src/dar.png

DEPENDS = cross/dar

MAINTAINER = SynoCommunity
DESCRIPTION = Disk ARchive - dar is a shell command that backs up from a single file to a whole filesystems, taking care of hard links, Extended Attributes, sparse files, MacOS\'s file forks, any inode type \(including Solaris Door inodes\), etc. 
CHANGELOG = "Enable large file support for 32bit archs. Enable public key encryption."

DISPLAY_NAME = DAR
STARTABLE = no

# archs without C++11 support are not supported:
UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)

HOMEPAGE = http://dar.linux.free.fr/

LICENSE = GPLv3

SPK_COMMANDS = bin/dar bin/dar_cp bin/dar_manager bin/dar_slave bin/dar_split bin/dar_xform

include ../../mk/spksrc.spk.mk
