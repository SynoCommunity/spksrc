SPK_NAME = autorun
SPK_VERS = 1.10.0
SPK_REV = 11
SPK_ICON = src/synology-autorun.png
DSM_UI_DIR = ui

DEPENDS = cross/synology-autorun

MAINTAINER = "Jan Reidemeister, Horst Schmid"
MAINTAINER_URL = https://github.com/schmidhorst/synology-autorun

DESCRIPTION = Executes a script on external drive \(USB / eSATA\) when it\'s connected to the disk station.
DISPLAY_NAME = Autorun
CHANGELOG = "Initial package hosted by SynoCommunity<br/>For full changelog see https://github.com/schmidhorst/synology-autorun/blob/main/CHANGELOG"

HOMEPAGE = https://github.com/schmidhorst/synology-autorun
LICENSE  = 3-clause BSD

# Pure script package, make sure ARCH is not defined
override ARCH=

CONF_DIR = $(STAGING_INSTALL_PREFIX)/synology-autorun/conf
WIZARDS_DIR = $(STAGING_INSTALL_PREFIX)/synology-autorun/WIZARD_UIFILES
SSS_SCRIPT = $(STAGING_INSTALL_PREFIX)/synology-autorun/scripts/start-stop-status
SERVICE_SETUP = src/service-setup.sh

COPY_TARGET = autorun_install

include ../../mk/spksrc.spk.mk

# cht, krn, nor are not (yet) supported.
SPK_LANGUAGES = chs cht csy dan enu fre ger hun ita jpn nld plk ptb ptg rus spn sve trk
# we must escape parentheses and single quote characters for variables holding the description
SUBSTITUTION = -e 's/(/\\\(/g' -e 's/)/\\\)/g' -e s/\'/\\\\\'/g

.PHONY: define_descriptions
define_descriptions:
	@$(MSG) Define language dependent descriptions
	$(foreach LANG, $(SPK_LANGUAGES), $(eval DESCRIPTION_$(shell echo $(LANG) | tr [:lower:] [:upper:]) := "$(shell grep descriptionINFO $(STAGING_INSTALL_PREFIX)/synology-autorun/package/ui/texts/$(LANG)/lang.txt | sed $(SUBSTITUTION) | cut -f2 -d=)"))

.PHONY: autorun_install
autorun_install: define_descriptions
	@$(MSG) Install package resources
	@install -m 755 -d $(STAGING_DIR)/app $(STAGING_DIR)/../WIZARD_UIFILES
	@tar -cf - -C $(STAGING_INSTALL_PREFIX)/synology-autorun/package . | tar -xf - -C $(STAGING_DIR)
	@$(MSG) temporary fix: overwrite corrupt icons
	@tar -cf - -C src/images . | tar -xf - -C $(STAGING_DIR)/ui/images
	@chmod 755 -R $(STAGING_DIR)/ui
	@$(MSG) Patch the application name
	@sed -e s/SYNO.SDS._ThirdParty.App.autorun/com.synocommunity.packages.autorun/g -i $(STAGING_DIR)/ui/config
	@$(MSG) Copy additional wizard files
	@cp -p $(STAGING_INSTALL_PREFIX)/synology-autorun/WIZARD_UIFILES/initial_config.txt $(STAGING_DIR)/../WIZARD_UIFILES/
	@cp -p $(STAGING_INSTALL_PREFIX)/synology-autorun/WIZARD_UIFILES/*.json $(STAGING_DIR)/../WIZARD_UIFILES/
