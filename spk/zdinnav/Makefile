SPK_NAME = zdinnav
SPK_VERS = 1.1.2
SPK_REV = 1
SPK_ICON = src/zdinnav.png

# 使用 cross 
DEPENDS = cross/zdinnav

REQUIRED_MIN_DSM = 7.0
REQUIRED_MIN_SRM = 1.3

UNSUPPORTED_ARCHS = $(ARMv5_ARCHS) $(OLD_PPC_ARCHS)
UNSUPPORTED_ARCHS += $(PPC_ARCHS) evansport comcerto2k

MAINTAINER = tkme
MAINTAINER_URL = https://github.com/MyTkme/ZdinNav-Link
DESCRIPTION = Build your own personalized navigation website.
DESCRIPTION_CHS = 网页书签管理工具，搭建专属于你的导航网站。
STARTABLE = yes
DISPLAY_NAME = 智淀导航
# CHANGELOG = "Update zdinnav to v1.1.1."

HOMEPAGE = https://github.com/MyTkme/ZdinNav-Link
LICENSE  = Copyright (C) 2026 tkme.

# 使用模板配置向导语言
WIZARDS_TEMPLATES_DIR = src/wizard_templates

SERVICE_PORT_TITLE = ZdinNav Web UI
SERVICE_USER = auto
SERVICE_WIZARD_SHARENAME = zdinnav_wizard_data_folder_name
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 9200
ADMIN_PORT = $(SERVICE_PORT)


# ****************************************cross打包相关配置 Start************************************************
# # 必须加上否则ifeq ($(call version_lt,条件不会调用
include ../../mk/spksrc.common.mk

# 当目标 DSM 系统版本 ${TCVERSION} 严格小于 7.2 时，执行
ifeq ($(call version_lt, ${TCVERSION}, 7.2),1)
# Use libe_sqlite3 built for GLIBC 2.20–2.26 (DSM 6–7.1) instead of upstream ≥ 2.28
DEPENDS += cross/libe_sqlite3
POST_STRIP_TARGET += lidarr_custom_libe_sqlite3
# Disable auto-update for DSM < 7.2
LIDARR_UPDATE = disabled
endif

POST_STRIP_TARGET += zdinnav_extra_install

# 这个位置顺序不能放在前面
include ../../mk/spksrc.spk.mk

# 群晖比较特殊7.2之前版本必须使用特定的libe_sqlite3编译文件
.PHONY: lidarr_custom_libe_sqlite3
lidarr_custom_libe_sqlite3:
	@$(MSG) Replace libe_sqlite3 with version built for DSM
	rm -f $(STAGING_DIR)/application/bin/libe_sqlite3.so
	cp -f $(STAGING_DIR)/lib/libe_sqlite3.so $(STAGING_DIR)/application/bin/libe_sqlite3.so

# 打包
.PHONY: zdinnav_extra_install
zdinnav_extra_install:
	@$(MSG) Install service 
	@install -m 755 -d $(STAGING_DIR)/application/
	@find $(STAGING_DIR)/application -type d -exec chmod 755 {} \;
	@chmod -R 755 $(STAGING_DIR)/application/web/* 2>/dev/null || true
	@find $(STAGING_DIR)/application/web -type d -exec chmod 755 {} \;
	@install -m 755 -d $(STAGING_DIR)/application/configuration
	@cp -r src/app/configuration/ $(STAGING_DIR)/application
	@chmod -R 755 $(STAGING_DIR)/application/configuration/* 2>/dev/null || true
# 	删除不需要的文件
	@rm -rf $(STAGING_DIR)/bin/
	@rm -rf $(STAGING_DIR)/lib/
# ****************************************cross打包相关配置 End************************************************
