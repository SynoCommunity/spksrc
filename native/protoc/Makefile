PKG_NAME = protoc
PKG_VERS = 3.5.1
PKG_EXT = zip
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-linux-x86_64.$(PKG_EXT)
PKG_DIST_SITE = https://github.com/protocolbuffers/protobuf/releases/download/v$(PKG_VERS)

HOMEPAGE = https://developers.google.com/protocol-buffers
COMMENT  = Protocol Buffers implementation in CPP
LICENSE  = https://github.com/protocolbuffers/protobuf/blob/master/LICENSE

# extract only to $(WORK_DIR)
INSTALL_TARGET = nop

include ../../mk/spksrc.native-install.mk
