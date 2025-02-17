SPK_NAME = fan2go
SPK_VERS = 0.9.0
SPK_REV = 1
SPK_ICON = src/fan2go_icon.png

DEPENDS = cross/fan2go

MAINTAINER = SynoCommunity
DISPLAY_NAME = Fan2Go
DESCRIPTION = "A simple daemon providing dynamic fan speed control based on temperature sensors."
DESCRIPTION_CHS = "基于温度传感器提供动态风扇速度控制的简易守护进程。"
HOMEPAGE = https://github.com/markusressel/fan2go
LICENSE = AGPLv3
LICENSE_FILE = $(WORK_DIR)/$(SPK_NAME)-$(SPK_VERS)/LICENSE
CHANGELOG = "Initial package release 0.9.0."

STARTABLE = yes
SERVICE_SETUP = src/service-setup.sh
SERVICE_USER = auto
FWPORTS = src/fan2go.sc

POST_STRIP_TARGET = fan2go_post_install

include ../../mk/spksrc.spk.mk

.PHONY: fan2go_post_install
fan2go_post_install:
	install -m 644 src/60-sc-fan2go-hwmon.rules $(STAGING_DIR)/60-sc-fan2go-hwmon.rules
	install -m 755 -d $(STAGING_DIR)/var
	install -m 644 src/fan2go.yaml $(STAGING_DIR)/var/fan2go.yaml.example
