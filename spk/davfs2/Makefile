SPK_NAME = davfs2
SPK_VERS = 1.5.2
SPK_REV = 3

#icon downloaded from https://www.iconfinder.com/icons/32041/folder_web_icon#size=128
#Free usage see http://mazenl77.deviantart.com/art/NX11-Unfinished-107836821
SPK_ICON = src/webfolder.png

DEPENDS = cross/busybox cross/$(SPK_NAME)

DESCRIPTION = Web Distributed Authoring and Versioning WebDAV, an extension to the HTTP-protocol, allows authoring of resources on a remote web server. davfs2 provides the ability to access such resources like a typical filesystem, allowing for use by standard applications with no built-in support for WebDAV. 
STARTABLE = no
DISPLAY_NAME = davfs2
CHANGELOG = "Initial release"
BETA = 1

HOMEPAGE = http://savannah.nongnu.org/projects/davfs2
LICENSE  = GNU General Public License

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

BUSYBOX_CONFIG = usrmng
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

