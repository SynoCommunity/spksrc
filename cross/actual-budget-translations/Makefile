PKG_NAME = actual-budget-translations
# Pin the translations to the last commit before the release of actual-budget.
# By default bin/package-browser of actual-budget uses latest commit of actualbudget/translations,
# so frontend output drifts as locales change after release day.
PKG_GIT_HASH = 1d3585a06ae3ad8b2833667234317ae149c3c008
# PKG_VERS must match PKG_VERS of cross/actual-budget
PKG_VERS = 26.10.0
PKG_EXT = tar.gz
PKG_DOWNLOAD_METHOD = git
PKG_DIST_SITE = https://github.com/actualbudget/translations.git
PKG_DIST_FILE = $(PKG_NAME)-git$(PKG_GIT_HASH).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-git$(PKG_GIT_HASH)

DEPENDS =

HOMEPAGE = https://actualbudget.org
COMMENT = Translations for actual-budget source tree.
LICENSE = MIT

INSTALL_TARGET = actual-budget-translations_install

include ../../mk/spksrc.cross-install.mk

.PHONY: actual-budget-translations_install
actual-budget-translations_install:
	@$(MSG) Install actual-budget translations into source tree of actual-$(PKG_VERS)
	@install -d -m 755 $(WORK_DIR)/actual-$(PKG_VERS)/packages/desktop-client/locale
	@cp -a $(WORK_DIR)/$(PKG_DIR)/* $(WORK_DIR)/actual-$(PKG_VERS)/packages/desktop-client/locale/
