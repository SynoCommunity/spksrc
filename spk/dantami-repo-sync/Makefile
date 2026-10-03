SPK_NAME = dantami-repo-sync
SPK_VERS = 1.6.2
SPK_REV = 2
SPK_ICON = src/dantami-repo-sync.png
DEPENDS = cross/dantami-repo-sync
REQUIRED_MIN_DSM = 7.1
# Initial submission targets x64; other architectures need separate validation.
UNSUPPORTED_ARCHS = $(ARM_ARCHS) $(PPC_ARCHS) $(i686_ARCHS)

MAINTAINER = momopanda123
DISPLAY_NAME = Dantami Repo Sync
DESCRIPTION = Synchronize GitHub and Gitea repositories through an authenticated web dashboard. Supports multiple pairs, ancestry-safe synchronization, independent app accounts, and Korean/English settings.
DESCRIPTION_KRN = GitHub와 Gitea 저장소를 웹 대시보드에서 연결하고 안전하게 동기화합니다. 여러 저장소 연결, 독립 앱 계정, 한국어와 영어 설정을 지원합니다.
HOMEPAGE = https://github.com/momopanda123/dantami-repo-sync
HELPURL = https://github.com/momopanda123/dantami-repo-sync#readme
LICENSE = MIT
CHANGELOG = "Initial SynoCommunity package for Dantami Repo Sync 1.6.2."
BETA = 1
STARTABLE = yes
SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SSS_SCRIPT = src/start-stop-status
WIZARDS_DIR = src/wizard
DSM_UI_DIR = ui
DSM_UI_CONFIG = src/config
DSM_APP_NAME = com.synocommunity.packages.dantami-repo-sync
POST_STRIP_TARGET = dantami_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: dantami_extra_install
dantami_extra_install:
	install -d -m 755 $(STAGING_DIR)/ui $(STAGING_DIR)/share/doc/dantami-repo-sync
	install -m 755 src/index.cgi $(STAGING_DIR)/ui/index.cgi
	install -m 644 $(WORK_DIR)/dantami-repo-sync-$(SPK_VERS)/LICENSE $(STAGING_DIR)/share/doc/dantami-repo-sync/
	install -m 644 src/README.md $(STAGING_DIR)/share/doc/dantami-repo-sync/
