PKG_NAME = gitea
PKG_VERS = 1.17.2
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/go-gitea/gitea/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = native/go native/nodejs

HOMEPAGE = https://gitea.io/
COMMENT  = Gitea is a community managed lightweight code hosting solution written in Go.
LICENSE  = MIT

ENV += NPM_CONFIG_USER=root

CGO_ENABLED = 1
COMPILE_TARGET = gitea_compile_target
GO_BIN_DIR = $(WORK_DIR)/$(PKG_DIR)/$(PKG_NAME)
include ../../mk/spksrc.cross-go.mk

# PATH must be defined after include of spksrc.cross-go.mk,
# otherwise WORK_DIR is not defined when building in cross/gitea folder
PATH := $(WORK_DIR)/../../../native/nodejs/work-native/node/bin:$(PATH)

SYNOPKG_PKGVAR = /var/packages/$(PKG_NAME)/var
CUSTOM_PATH = -X \"code.gitea.io/gitea/modules/setting.CustomPath=$(SYNOPKG_PKGVAR)/custom\"
CUSTOM_CONF = -X \"code.gitea.io/gitea/modules/setting.CustomConf=$(SYNOPKG_PKGVAR)/conf.ini\"
WORK_PATH = -X \"code.gitea.io/gitea/modules/setting.AppWorkPath=$(SYNOPKG_PKGVAR)\"
PID = -X \"code.gitea.io/gitea/modules/setting.PIDFile=$(SYNOPKG_PKGVAR)/gitea.pid\"

ENV += LDFLAGS="$(CUSTOM_PATH) $(CUSTOM_CONF) $(WORK_PATH) $(PID)"
ENV += TAGS="bindata sqlite sqlite_unlock_notify"
ENV += GITEA_VERSION=$(PKG_VERS)

.PHONY: gitea_compile_target
gitea_compile_target:
	@$(RUN) $(MAKE) build
