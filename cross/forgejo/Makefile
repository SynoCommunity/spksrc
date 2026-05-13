PKG_NAME = forgejo
PKG_VERS = 15.0.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-src-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://codeberg.org/forgejo/forgejo/releases/download/v$(PKG_VERS)
PKG_DIST_FILE = $(PKG_NAME)-src-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-src-$(PKG_VERS)

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS)

BUILD_DEPENDS = native/go native/nodejs

HOMEPAGE = https://forgejo.org/
COMMENT  = Forgejo is a self-hosted lightweight software forge.
LICENSE  = GPLv3

ENV += NPM_CONFIG_USER=root

CGO_ENABLED = 1
COMPILE_TARGET = forgejo_compile_target
# forgejo fork from gitea and keep binary name as gitea
GO_BIN_DIR = $(WORK_DIR)/$(PKG_DIR)/gitea

export EXTRA_GOFLAGS=-buildvcs=false

include ../../mk/spksrc.cross-go.mk

# PATH must be defined after include of spksrc.cross-go.mk,
# otherwise WORK_DIR is not defined when building in cross/gitea folder
PATH := $(WORK_DIR)/../../../native/nodejs/work-native/node/bin:$(PATH)

SYNOPKG_PKGVAR = /var/packages/$(PKG_NAME)/var
CUSTOM_PATH = -X \"forgejo.org/modules/setting.CustomPath=$(SYNOPKG_PKGVAR)/custom\"
CUSTOM_CONF = -X \"forgejo.org/modules/setting.CustomConf=$(SYNOPKG_PKGVAR)/conf.ini\"
WORK_PATH = -X \"forgejo.org/modules/setting.AppWorkPath=$(SYNOPKG_PKGVAR)\"
PID = -X \"forgejo.org/modules/setting.PIDFile=$(SYNOPKG_PKGVAR)/forgejo.pid\"

ENV += LDFLAGS="$(CUSTOM_PATH) $(CUSTOM_CONF) $(WORK_PATH) $(PID)"
ENV += TAGS="bindata timetzdata sqlite sqlite_unlock_notify"
ENV += GITEA_VERSION=$(PKG_VERS)

.PHONY: forgejo_compile_target
forgejo_compile_target:
	@$(RUN) $(MAKE) build
