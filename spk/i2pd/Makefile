SPK_NAME = i2pd
SPK_VERS = 2.18.0
SPK_REV = 0
# SPK_ICON = src/i2pd.png

DEPENDS = cross/$(SPK_NAME)

MAINTAINER = publicarray
DESCRIPTION  = The I2P network provides strong privacy protections for communication over the Internet. Many activities that would risk your privacy on the public Internet can be conducted anonymously inside I2P.
RELOAD_UI = no
DISPLAY_NAME = i2pd
STARTABLE = no
CHANGELOG = Initial release

HOMEPAGE   = https://geti2p.net/en/
LICENSE    = BSD 3 Clause

STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 4444 # browsing the web via i2pd
SERVICE_PORT_TITLE = HTTPProxy
# SERVICE_PORT_ALL_USERS = false
# SERVICE_URL = /

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

include ../../mk/spksrc.spk.mk
