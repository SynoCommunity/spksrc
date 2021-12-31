PKG_NAME = gitea
PKG_VERS = 1.15.9
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-src-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/go-gitea/gitea/releases/download/v$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
EXTRACT_PATH = $(WORK_DIR)/$(PKG_DIR)

BUILD_DEPENDS = native/go

HOMEPAGE = https://gitea.io/
COMMENT  = Gitea is a community managed lightweight code hosting solution written in Go.
LICENSE  = MIT

CGO_ENABLED = 1
COMPILE_TARGET = gitea_compile_target
GO_BIN_DIR = $(WORK_DIR)/$(PKG_DIR)/$(PKG_NAME)
include ../../mk/spksrc.cross-go.mk

SYNOPKG_PKGVAR = /var/packages/$(PKG_NAME)/var
CUSTOM_PATH = -X \"code.gitea.io/gitea/modules/setting.CustomPath=$(SYNOPKG_PKGVAR)/custom\"
CUSTOM_CONF = -X \"code.gitea.io/gitea/modules/setting.CustomConf=$(SYNOPKG_PKGVAR)/conf.ini\"
WORK_PATH = -X \"code.gitea.io/gitea/modules/setting.AppWorkPath=$(SYNOPKG_PKGVAR)\"
PID = -X \"code.gitea.io/gitea/modules/setting.PIDFile=$(SYNOPKG_PKGVAR)/gitea.pid\"

ENV += LDFLAGS="$(CUSTOM_PATH) $(CUSTOM_CONF) $(WORK_PATH) $(PID)"
ENV += TAGS="bindata sqlite sqlite_unlock_notify"
ENV += GITEA_VERSION=$(PKG_VERS)

gitea_compile_target:
	$(RUN) $(MAKE) backend
