SPK_NAME = haproxy
SPK_VERS = 1.5-dev8
SPK_REV = 1
SPK_ICON = src/haproxy.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = SynoCommunity
DESCRIPTION = HAProxy is a free, very fast and reliable solution offering high availability, load balancing, and proxying for TCP and HTTP-based applications.
DESCRIPTION_FRE = HAProxy est un produit libre, très rapide et fiable qui permet la haute disponibilité, la répartition de charge et le proxy de services TCP ou HTTP.
RELOAD_UI = no
DISPLAY_NAME = HAProxy

HOMEPAGE   = http://haproxy.1wt.eu/
LICENSE    = GPL v2

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/start-stop-status
ADDITIONAL_SCRIPTS = 

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

include ../../mk/spksrc.spk.mk

